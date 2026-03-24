import 'package:saas_app/features/products/domain/entities/product.dart';
import 'package:saas_app/core/utils/json_utils.dart';

class ProductModel {
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

  ProductModel({
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

  /// Convert ProductModel to Product entity
  Product toEntity() {
    return Product(
      id: id,
      name: name,
      description: description,
      price: price,
      quantity: quantity,
      categoryName: categoryName,
      categoryId: categoryId,
      unit: unit,
      supplierId: supplierId,
      imageUrl: imageUrl,
      rating: rating,
      createdAt: createdAt,
    );
  }

  /// Create ProductModel from JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Handle category name from nested object or direct field
    String categoryName = 'General';
    int categoryId = 0;
    if (json['category'] != null) {
      if (json['category'] is Map) {
        categoryName = json['category']['name'] ?? 'General';
        categoryId = JsonUtils.parseInt(json['category']['id']);
      } else {
        categoryName = json['category'].toString();
      }
    }

    if (categoryId == 0 && json['category_id'] != null) {
      categoryId = JsonUtils.parseInt(json['category_id']);
    }

    // Handle image URL from images array or image_url field
    String? imageUrl;
    if (json['images'] != null &&
        json['images'] is List &&
        (json['images'] as List).isNotEmpty) {
      imageUrl = json['images'][0].toString();
    } else {
      imageUrl = json['image_url'] as String?;
    }

    return ProductModel(
      id: JsonUtils.parseInt(json['id']),
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: JsonUtils.parseDouble(json['price']),
      quantity: JsonUtils.parseInt(json['stock'] ?? json['quantity']),
      categoryName: categoryName,
      categoryId: categoryId != 0
          ? categoryId
          : JsonUtils.parseInt(json['category_id']),
      unit: json['unit'] as String? ?? 'pcs',
      supplierId: JsonUtils.parseInt(json['supplier_id']),
      imageUrl: imageUrl,
      rating: json['rating'] != null
          ? JsonUtils.parseDouble(json['rating'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  /// Convert ProductModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': quantity,
      'category_id': categoryId,
      'unit': unit,
      'supplier_id': supplierId,
      'image_url': imageUrl,
      'rating': rating,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
