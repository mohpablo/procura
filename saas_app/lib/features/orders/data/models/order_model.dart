import 'package:saas_app/features/orders/domain/entities/order.dart';

class OrderModel {
  final int id;
  final int userId;
  final String orderNumber;
  final double totalAmount;
  final String status;
  final DateTime createdAt;
  final DateTime? deliveredAt;
  final String shippingAddress;
  final int itemCount;

  OrderModel({
    required this.id,
    required this.userId,
    required this.orderNumber,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    this.deliveredAt,
    required this.shippingAddress,
    required this.itemCount,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // Unwrapping nested data/order
    Map<String, dynamic> data = json;
    if (json.containsKey('order') && json['order'] is Map<String, dynamic>) {
      data = json['order'] as Map<String, dynamic>;
    } else if (json.containsKey('data') &&
        json['data'] is Map<String, dynamic>) {
      final nestedData = json['data'] as Map<String, dynamic>;
      // If the nested data has order-like keys, use it
      if (nestedData.containsKey('id') ||
          nestedData.containsKey('order_number')) {
        data = nestedData;
      }
    }

    num? parseNum(dynamic value) {
      if (value == null) return null;
      if (value is num) return value;
      return num.tryParse(value.toString());
    }

    return OrderModel(
      id: parseNum(data['id'])?.toInt() ?? 0,
      userId:
          parseNum(data['buyer_id'])?.toInt() ??
          parseNum(data['user_id'])?.toInt() ??
          0,
      orderNumber:
          (data['order_number'] ??
                  data['id']?.toString() ??
                  data['order_id']?.toString() ??
                  '')
              .toString(),
      totalAmount:
          parseNum(data['total_amount'])?.toDouble() ??
          parseNum(data['total'])?.toDouble() ??
          0.0,
      status: data['status'] as String? ?? 'pending',
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'] as String)
          : DateTime.now(),
      deliveredAt: data['delivered_at'] != null
          ? DateTime.parse(data['delivered_at'] as String)
          : null,
      shippingAddress:
          (data['shipping_address'] ?? data['address']) as String? ?? '',
      itemCount:
          parseNum(data['item_count'])?.toInt() ??
          (data['order_items'] as List?)?.length ??
          (data['items'] as List?)?.length ??
          0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'order_number': orderNumber,
    'total_amount': totalAmount,
    'status': status,
    'created_at': createdAt.toIso8601String(),
    'delivered_at': deliveredAt?.toIso8601String(),
    'shipping_address': shippingAddress,
    'item_count': itemCount,
  };

  Order toEntity() {
    return Order(
      id: id,
      userId: userId,
      orderNumber: orderNumber,
      totalAmount: totalAmount,
      status: _parseStatus(status),
      createdAt: createdAt,
      deliveredAt: deliveredAt,
      shippingAddress: shippingAddress,
      itemCount: itemCount,
      items: const [], // Could be expanded later if needed
    );
  }

  static OrderStatus _parseStatus(String status) {
    return switch (status.toLowerCase()) {
      'pending' => OrderStatus.pending,
      'confirmed' => OrderStatus.confirmed,
      'preparing' => OrderStatus.preparing,
      'ready_for_delivery' => OrderStatus.ready_for_delivery,
      'scheduled' => OrderStatus.scheduled,
      'delivered' => OrderStatus.delivered,
      'cancelled' => OrderStatus.cancelled,
      _ => OrderStatus.pending,
    };
  }
}
