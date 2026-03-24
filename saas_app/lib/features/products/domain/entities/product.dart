class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final String categoryName;
  final int categoryId;
  final String unit;
  final int supplierId;
  final String? imageUrl;
  final double? rating;
  final DateTime? createdAt;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.categoryName,
    required this.categoryId,
    required this.unit,
    required this.supplierId,
    this.imageUrl,
    this.rating,
    this.createdAt,
  });
}
