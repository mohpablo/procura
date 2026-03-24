import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saas_app/core/routes/app_routes.dart';
import 'package:saas_app/features/products/presentation/cubit/product_cubit.dart';
import 'package:saas_app/features/products/domain/entities/product.dart';

class InventoryView extends StatefulWidget {
  const InventoryView({super.key});

  @override
  State<InventoryView> createState() => _InventoryViewState();
}

class _InventoryViewState extends State<InventoryView> {
  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().getProducts(page: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async =>
                context.read<ProductCubit>().getProducts(page: 1),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverAppBar(
                  expandedHeight: 120,
                  pinned: true,
                  flexibleSpace: const FlexibleSpaceBar(
                    title: Text(
                      'Inventory Management',
                      style: TextStyle(
                        color: Color(0xFF1E293B),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    centerTitle: false,
                  ),
                  backgroundColor: Colors.white,
                  elevation: 0,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline_rounded),
                      onPressed: () => Navigator.pushNamed(
                        context,
                        AppRoutes.supplierAddProduct,
                      ),
                    ),
                  ],
                ),
                if (state is ProductLoading)
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state is ProductError)
                  SliverFillRemaining(child: Center(child: Text(state.message)))
                else if (state is ProductsLoaded) ...[
                  if (state.products.isEmpty)
                    const SliverFillRemaining(
                      child: Center(child: Text('No products in inventory')),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final product = state.products[index];
                          return _buildInventoryItem(context, product);
                        }, childCount: state.products.length),
                      ),
                    ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInventoryItem(BuildContext context, Product product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.inventory_2_outlined, color: Colors.grey),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Stock: ${product.quantity}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.blue,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Color(0xFF6366F1)),
              onPressed: () => Navigator.pushNamed(
                context,
                AppRoutes.supplierEditProduct,
                arguments: product,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
