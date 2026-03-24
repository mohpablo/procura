import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saas_app/features/products/domain/entities/product.dart';
import 'package:saas_app/features/products/presentation/cubit/product_cubit.dart';
import 'package:saas_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:saas_app/features/auth/presentation/cubit/auth_cubit.dart';

class ProductDetailView extends StatefulWidget {
  final int productId;

  const ProductDetailView({super.key, required this.productId});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().getProductById(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Product Details'), elevation: 0),
        body: BlocListener<ProductCubit, ProductState>(
          listener: (context, state) {
            if (state is ProductError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: BlocBuilder<ProductCubit, ProductState>(
            builder: (context, state) {
              if (state is ProductDetailLoading || state is ProductInitial) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ProductDetailLoaded) {
                return _buildProductDetail(state.product);
              }

              if (state is ProductError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error Loading Product',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          context.read<ProductCubit>().getProductById(
                            widget.productId,
                          );
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProductDetail(Product product) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image Placeholder
          Container(
            width: double.infinity,
            height: 300,
            color: Colors.grey[300],
            child: Icon(
              Icons.image_outlined,
              color: Colors.grey[600],
              size: 80,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    product.categoryName,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Product Name
                Text(
                  product.name,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                // Price
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Stock Status
                Row(
                  children: [
                    Icon(
                      product.quantity > 0 ? Icons.check_circle : Icons.block,
                      color: product.quantity > 0 ? Colors.green : Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      product.quantity > 0
                          ? '${product.quantity} items in stock'
                          : 'Out of stock',
                      style: TextStyle(
                        color: product.quantity > 0 ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Description
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                // Quantity Selector
                if (product.quantity > 0 &&
                    !(context.read<AuthCubit>().state is AuthSupplierSuccess)) ...[
                  Row(
                    children: [
                      Text(
                        'Quantity',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: _quantity > 1
                                  ? () => setState(() => _quantity--)
                                  : null,
                              icon: const Icon(Icons.remove),
                              iconSize: 20,
                            ),
                            SizedBox(
                              width: 40,
                              child: Center(
                                child: Text(
                                  _quantity.toString(),
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: _quantity < product.quantity
                                  ? () => setState(() => _quantity++)
                                  : null,
                              icon: const Icon(Icons.add),
                              iconSize: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
                // Add to Cart Button
                if (!(context.read<AuthCubit>().state is AuthSupplierSuccess))
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: product.quantity > 0
                          ? () {
                              context.read<CartCubit>().addToCart(
                                product.id,
                                _quantity,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Added $_quantity ${product.name} to cart',
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Add to Cart',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
