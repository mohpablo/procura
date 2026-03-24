import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saas_app/core/routes/app_routes.dart';
import 'package:saas_app/features/cart/domain/entities/cart.dart';
import 'package:saas_app/features/cart/presentation/cubit/cart_cubit.dart';

class CartView extends StatefulWidget {
  static const routeName = '/buyer/cart';

  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().loadCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shopping Cart'), elevation: 0),
      body: BlocListener<CartCubit, CartState>(
        listener: (context, state) {
          if (state is CartUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is CartError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state is CartInitial || state is CartLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CartEmpty) {
              return _buildEmptyCart();
            }

            if (state is CartLoaded || state is CartUpdated) {
              final cart = state is CartLoaded
                  ? state.cart
                  : (state as CartUpdated).cart;
              return _buildCartContent(context, cart);
            }

            if (state is CartError) {
              return _buildErrorState(context, state.message);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Start shopping to add items to your cart',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.products),
            child: const Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(BuildContext context, Cart cart) {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<CartCubit>().refresh();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final item = cart.items[index];
                return _buildCartItemCard(context, item);
              },
            ),
          ),
        ),
        _buildCheckoutSection(context, cart),
      ],
    );
  }

  Widget _buildCartItemCard(BuildContext context, CartItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.image_outlined, color: Colors.grey[600]),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${item.unitPrice.toStringAsFixed(2)} each',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (item.quantity > 1) {
                                  context.read<CartCubit>().updateCartItem(
                                    item.productId,
                                    item.quantity - 1,
                                  );
                                }
                              },
                              icon: const Icon(Icons.remove),
                              iconSize: 16,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                            ),
                            Text(
                              item.quantity.toString(),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            IconButton(
                              onPressed: () {
                                context.read<CartCubit>().updateCartItem(
                                  item.productId,
                                  item.quantity + 1,
                                );
                              },
                              icon: const Icon(Icons.add),
                              iconSize: 16,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '\$${item.totalPrice.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                context.read<CartCubit>().removeFromCart(item.productId);
              },
              icon: const Icon(Icons.close),
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutSection(BuildContext context, Cart cart) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subtotal:', style: Theme.of(context).textTheme.bodyMedium),
              Text(
                '\$${cart.subtotal.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tax:', style: Theme.of(context).textTheme.bodyMedium),
              Text(
                '\$${cart.tax.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total:',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                '\$${cart.total.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).pushNamed(AppRoutes.checkout);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Proceed to Checkout',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Continue Shopping'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
          const SizedBox(height: 16),
          Text('Error', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<CartCubit>().loadCart();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
