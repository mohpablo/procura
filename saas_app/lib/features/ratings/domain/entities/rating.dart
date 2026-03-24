class Rating {
  final int id;
  final int orderId;
  final int supplierId;
  final int buyerId;
  final double rating;
  final String? comment;
  final DateTime createdAt;

  Rating({
    required this.id,
    required this.orderId,
    required this.supplierId,
    required this.buyerId,
    required this.rating,
    this.comment,
    required this.createdAt,
  });
}
