import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saas_app/core/routes/app_routes.dart';
import 'package:saas_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:saas_app/features/orders/presentation/cubit/order_cubit.dart';
import 'package:saas_app/features/cart/presentation/cubit/cart_cubit.dart';

class CheckoutView extends StatefulWidget {
  static const String routeName = '/buyer/checkout';
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  String _paymentMethod = 'wallet';

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _placeOrder(BuildContext context) {
    if (_addressController.text.isEmpty || _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    final cartState = context.read<CartCubit>().state;
    if (cartState is! CartLoaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cart is empty or still loading')),
      );
      return;
    }

    final cartItems = cartState.cart.items
        .map(
          (item) => {'product_id': item.productId, 'quantity': item.quantity},
        )
        .toList();

    final orderData = {
      'shipping_address': _addressController.text,
      'address': _addressController.text, // Fallback for some backends
      'phone': _phoneController.text,
      'payment_method': _paymentMethod,
      'cart_items': cartItems,
      'items': cartItems, // Fallback for some backends
    };

    context.read<OrderCubit>().createOrder(orderData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout'), elevation: 0),
      body: BlocConsumer<OrderCubit, OrderState>(
        listener: (context, state) {
          if (state is OrderCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Order placed successfully!')),
            );
            // Clear cart and navigate back to Home
            context.read<CartCubit>().clearCart();

            final authState = context.read<AuthCubit>().state;
            if (authState is AuthBuyerSuccess) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.buyerHome,
                (route) => false,
                arguments: authState.user,
              );
            } else if (authState is AuthSuccess) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.buyerHome,
                (route) => false,
                arguments: authState.user,
              );
            } else {
              // Fallback if user state isn't as expected, pop to root
              Navigator.of(context).popUntil((route) => route.isFirst);
            }
          } else if (state is OrderError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shipping Details',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Shipping Address',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 24),
                Text(
                  'Payment Method',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _paymentMethod,
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(
                          value: 'wallet',
                          child: Text('Wallet / Cash'),
                        ),
                        DropdownMenuItem(
                          value: 'credit_card',
                          child: Text('Credit Card (Coming Soon)'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null && value != 'credit_card') {
                          setState(() => _paymentMethod = value);
                        } else if (value == 'credit_card') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Credit Card payments are coming soon',
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Estimated Delivery: Within 3 business days',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => _placeOrder(context),
                    child: const Text(
                      'Place Order',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
