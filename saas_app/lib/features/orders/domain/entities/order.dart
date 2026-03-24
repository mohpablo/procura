enum OrderStatus {
  pending,
  confirmed,
  preparing,
  ready_for_delivery,
  scheduled,
  delivered,
  cancelled
}

class Order {
  final int id;
  final int userId;
  final String orderNumber;
  final double totalAmount;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime? deliveredAt;
  final String shippingAddress;
  final int itemCount;
  final List<dynamic> items;

  const Order({
    required this.id,
    required this.userId,
    required this.orderNumber,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    this.deliveredAt,
    required this.shippingAddress,
    required this.itemCount,
    this.items = const [],
  });
}
