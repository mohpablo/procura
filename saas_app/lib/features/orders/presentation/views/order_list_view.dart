import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saas_app/features/orders/domain/entities/order.dart';
import 'package:saas_app/features/orders/presentation/cubit/order_cubit.dart';
import 'package:saas_app/features/orders/presentation/views/order_details_view.dart';
import 'package:intl/intl.dart';

class OrderListView extends StatefulWidget {
  const OrderListView({super.key});

  @override
  State<OrderListView> createState() => _OrderListViewState();
}

class _OrderListViewState extends State<OrderListView> {
  @override
  void initState() {
    super.initState();
    context.read<OrderCubit>().getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async => context.read<OrderCubit>().getOrders(),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverAppBar(
                  expandedHeight: 120,
                  pinned: true,
                  flexibleSpace: const FlexibleSpaceBar(
                    title: Text(
                      'Order History',
                      style: TextStyle(
                        color: Color(0xFF1E293B),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    centerTitle: false,
                  ),
                  backgroundColor: Colors.white,
                  elevation: 0,
                ),
                if (state is OrderLoading)
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state is OrderError)
                  SliverFillRemaining(
                    child: _buildErrorState(context, state.message),
                  )
                else if (state is OrdersLoaded) ...[
                  if (state.orders.isEmpty)
                    SliverFillRemaining(child: _buildEmptyState())
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final order = state.orders[index];
                          return _buildOrderCard(context, order);
                        }, childCount: state.orders.length),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              size: 64,
              color: Colors.grey[300],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No orders yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start your procurement journey today!',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, Order order) {
    final statusColor = _getStatusColor(order.status.name);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<OrderCubit>(),
                child: OrderDetailsView(order: order),
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${order.id}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('MMM dd, yyyy').format(order.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      order.status.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: statusColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Amount',
                    style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                  ),
                  Text(
                    '\$${order.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => context.read<OrderCubit>().getOrders(),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFF59E0B);
      case 'confirmed':
        return const Color(0xFF3B82F6);
      case 'processing':
        return const Color(0xFF8B5CF6);
      case 'shipped':
        return const Color(0xFF0EA5E9);
      case 'delivered':
        return const Color(0xFF10B981);
      case 'cancelled':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF64748B);
    }
  }
}
