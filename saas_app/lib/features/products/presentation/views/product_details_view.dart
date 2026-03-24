import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saas_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:saas_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:saas_app/features/products/domain/entities/product.dart';

class ProductDetailsView extends StatelessWidget {
  final Product product;

  const ProductDetailsView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Details'), elevation: 0),
      body: BlocListener<CartCubit, CartState>(
        listener: (context, state) {
          if (state is CartUpdated) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is CartError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Container(
                width: double.infinity,
                height: 300,
                color: Colors.grey[200],
                child: product.imageUrl != null
                    ? Image.network(
                        product.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const Icon(
                          Icons.image_not_supported,
                          size: 100,
                          color: Colors.grey,
                        ),
                      )
                    : const Icon(Icons.image, size: 100, color: Colors.grey),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Price
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Stock Status
                    Row(
                      children: [
                        Icon(
                          product.quantity > 0
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: product.quantity > 0
                              ? Colors.green
                              : Colors.red,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          product.quantity > 0
                              ? 'In Stock (${product.quantity} available)'
                              : 'Out of Stock',
                          style: TextStyle(
                            fontSize: 16,
                            color: product.quantity > 0
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Description
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.description,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                    const SizedBox(height: 24),

                    // Category
                    Row(
                      children: [
                        Chip(label: Text(product.categoryName)),
                        const SizedBox(width: 8),
                        Chip(label: Text('Unit: ${product.unit}')),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: product.quantity > 0 &&
              !(context.read<AuthCubit>().state is AuthSupplierSuccess)
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: BlocBuilder<CartCubit, CartState>(
                  builder: (context, state) {
                    final isLoading = state is CartLoading;
                    return ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              context.read<CartCubit>().addToCart(
                                product.id,
                                1,
                              );
                            },
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Add to Cart'),
                    );
                  },
                ),
              ),
            )
          : null,
    );
  }
}
