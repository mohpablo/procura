import 'package:saas_app/features/ratings/domain/entities/rating.dart';

class RatingModel {
  final int id;
  final int orderId;
  final int supplierId;
  final int buyerId;
  final double rating;
  final String? comment;
  final DateTime createdAt;

  RatingModel({
    required this.id,
    required this.orderId,
    required this.supplierId,
    required this.buyerId,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['id'] as int,
      orderId: json['order_id'] as int,
      supplierId: json['supplier_id'] as int,
      buyerId: json['buyer_id'] as int,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'supplier_id': supplierId,
      'buyer_id': buyerId,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Rating toEntity() {
    return Rating(
      id: id,
      orderId: orderId,
      supplierId: supplierId,
      buyerId: buyerId,
      rating: rating,
      comment: comment,
      createdAt: createdAt,
    );
  }
}
