import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saas_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:saas_app/features/orders/domain/entities/order.dart';
import 'package:saas_app/features/orders/presentation/cubit/order_cubit.dart';
import 'package:intl/intl.dart';

class OrderDetailsView extends StatelessWidget {
  final Order order;

  const OrderDetailsView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderCubit, OrderState>(
      listener: (context, state) {
        if (state is OrdersLoaded) {
          // If we are back to OrdersLoaded, it means the refresh happened.
          // In some cases we might want to stay in details, but for confirm/cancel we pop.
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        } else if (state is OrderError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Order #${order.id}'), elevation: 0),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Status Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Order Status',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Chip(
                            label: Text(
                              order.status.name.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: _getStatusColor(
                              order.status.name,
                            ).withOpacity(0.2),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        'Order Date',
                        DateFormat('MMM dd, yyyy HH:mm').format(order.createdAt),
                      ),
                      _buildInfoRow('Order ID', '#${order.id}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Order Items
              const Text(
                'Order Items',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Card(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: order.items.length,
                  separatorBuilder: (_, _) => const Divider(),
                  itemBuilder: (context, index) {
                    final item = order.items[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        child: const Icon(Icons.shopping_bag, color: Colors.grey),
                      ),
                      title: Text(
                        'Product #${item.productId}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text('Quantity: ${item.quantity}'),
                      trailing: Text(
                        '\$${item.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Order Summary
              const Text(
                'Order Summary',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildSummaryRow('Subtotal', order.totalAmount),
                      const SizedBox(height: 8),
                      _buildSummaryRow('Tax', 0.0),
                      const SizedBox(height: 8),
                      _buildSummaryRow('Shipping', 0.0),
                      const Divider(height: 24),
                      _buildSummaryRow('Total', order.totalAmount, isTotal: true),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Shipping Address
              const Text(
                'Shipping Address',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.grey),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          order.shippingAddress,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
        bottomNavigationBar: BlocBuilder<OrderCubit, OrderState>(
          builder: (context, state) {
            if (state is OrderLoading) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: LinearProgressIndicator(),
              );
            }
            return _buildBottomActions(context);
          },
        ),
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    final status = order.status.name.toLowerCase();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, authState) {
            final isSupplier = authState is AuthSupplierSuccess;
            final isAdmin = authState is AuthAdminSuccess;

            if (isSupplier) {
              return _buildSupplierActions(context, status);
            } else if (isAdmin) {
              return _buildAdminActions(context, status);
            } else {
              return _buildBuyerActions(context, status);
            }
          },
        ),
      ),
    );
  }

  Widget _buildSupplierActions(BuildContext context, String status) {
    if (status == 'pending') {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => _updateStatus(context, 'cancelled'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
              ),
              child: const Text('Reject'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _confirmOrder(context, 'confirmed'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Approve'),
            ),
          ),
        ],
      );
    }

    if (status == 'confirmed') {
      return ElevatedButton(
        onPressed: () => _updateStatus(context, 'preparing'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple,
          minimumSize: const Size(double.infinity, 45),
        ),
        child: const Text('Start Preparing'),
      );
    }

    if (status == 'preparing') {
      return ElevatedButton(
        onPressed: () => _updateStatus(context, 'ready_for_delivery'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          minimumSize: const Size(double.infinity, 45),
        ),
        child: const Text('Ready for Delivery'),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildAdminActions(BuildContext context, String status) {
    if (status == 'ready_for_delivery') {
      return ElevatedButton(
        onPressed: () => _showScheduleDialog(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo,
          minimumSize: const Size(double.infinity, 45),
        ),
        child: const Text('Schedule Delivery'),
      );
    }

    if (status == 'scheduled') {
      return ElevatedButton(
        onPressed: () => _updateStatus(context, 'delivered'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          minimumSize: const Size(double.infinity, 45),
        ),
        child: const Text('Mark as Delivered'),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildBuyerActions(BuildContext context, String status) {
    if (status == 'pending') {
      return ElevatedButton(
        onPressed: () => _showCancelDialog(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          minimumSize: const Size(double.infinity, 45),
        ),
        child: const Text('Cancel Order'),
      );
    }

    if (status == 'delivered') {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _downloadInvoice(context),
              icon: const Icon(Icons.file_download),
              label: const Text('Invoice'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _rateSupplier(context),
              icon: const Icon(Icons.star_outline),
              label: const Text('Rate'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  void _confirmOrder(BuildContext context, String status) {
    context.read<OrderCubit>().confirmOrder(order.id, status);
  }

  void _updateStatus(BuildContext context, String status) {
    context.read<OrderCubit>().updateOrderStatus(order.id, status);
  }

  void _downloadInvoice(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invoice downloaded to your device.')),
    );
  }

  void _rateSupplier(BuildContext context) {
    Navigator.pushNamed(context, '/buyer/ratings');
  }

  void _showScheduleDialog(BuildContext context) {
    // Basic date picker for scheduling
    showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 7)),
    ).then((date) {
      if (date != null) {
        // Logic for scheduling would go here, probably needs a new Cubit method if specialized
        // For now, let's just use updateStatus to 'scheduled' if possible or similar
        _updateStatus(context, 'scheduled');
      }
    });
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isTotal ? 20 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'preparing':
        return Colors.purple;
      case 'ready_for_delivery':
        return Colors.teal;
      case 'scheduled':
        return Colors.indigo;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancel Order'),
        content: const Text('Are you sure you want to cancel this order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<OrderCubit>().cancelOrder(order.id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }
}
