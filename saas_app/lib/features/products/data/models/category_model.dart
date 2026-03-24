import 'package:saas_app/features/products/domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required super.id,
    required super.name,
    super.productCount,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return CategoryModel(
      id: parseInt(json['id']),
      name: json['name'] as String? ?? '',
      productCount: json['products_count'] != null
          ? parseInt(json['products_count'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'products_count': productCount};
  }
}
