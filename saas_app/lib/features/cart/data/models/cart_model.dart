import 'package:saas_app/features/cart/domain/entities/cart.dart';
import 'package:saas_app/core/utils/json_utils.dart';

class CartItemModel {
  final int id;
  final int productId;
  final String productName;
  final double unitPrice;
  final int quantity;
  final double totalPrice;
  final String? productImage;

  CartItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
    required this.totalPrice,
    this.productImage,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    // Handle nested product object or flat structure
    final Map<String, dynamic> product =
        (json['product'] as Map<String, dynamic>?) ??
        (json['product_details'] as Map<String, dynamic>?) ??
        json;

    final int productId = JsonUtils.parseInt(
      product['id'] ?? json['product_id'],
    );
    int id = JsonUtils.parseInt(json['id']);
    if (id == 0) id = productId;

    return CartItemModel(
      id: id,
      productId: productId,
      productName:
          (product['name'] ?? json['product_name']) as String? ??
          'Unknown Product',
      unitPrice: JsonUtils.parseDouble(product['price'] ?? json['unit_price']),
      quantity: JsonUtils.parseInt(json['quantity']),
      totalPrice: JsonUtils.parseDouble(json['total'] ?? json['total_price']),
      productImage: (product['image_url'] ?? json['product_image']) as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'product_id': productId,
    'product_name': productName,
    'unit_price': unitPrice,
    'quantity': quantity,
    'total_price': totalPrice,
    'product_image': productImage,
  };

  CartItem toEntity() {
    return CartItem(
      id: id,
      productId: productId,
      productName: productName,
      unitPrice: unitPrice,
      quantity: quantity,
      totalPrice: totalPrice,
      productImage: productImage,
    );
  }
}

class CartModel {
  final int id;
  final int userId;
  final List<CartItemModel> items;
  final double subtotal;
  final double tax;
  final double total;

  CartModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    // Robust unwrapping: if the json contains a 'cart' or 'data' key that is a map,
    // and it doesn't look like a CartModel itself (it has items or total), use that.
    Map<String, dynamic> effectiveJson = json;
    if (json.containsKey('cart') && json['cart'] is Map<String, dynamic>) {
      effectiveJson = json['cart'] as Map<String, dynamic>;
    } else if (json.containsKey('data') &&
        json['data'] is Map<String, dynamic>) {
      // Check if it's the data wrapper for the whole cart
      final dataMap = json['data'] as Map<String, dynamic>;
      if (dataMap.containsKey('items') ||
          dataMap.containsKey('cart_items') ||
          dataMap.containsKey('total')) {
        effectiveJson = dataMap;
      }
    }

    // Handle both 'items' and 'cart_items' keys
    final dynamic itemsData =
        effectiveJson['items'] ?? effectiveJson['cart_items'];

    final itemsList =
        (itemsData as List<dynamic>?)
            ?.map(
              (item) => CartItemModel.fromJson(item as Map<String, dynamic>),
            )
            .toList() ??
        [];

    // Calculate subtotal if missing by summing item totals
    double calculatedTotal = JsonUtils.parseDouble(
      effectiveJson['total'] ?? effectiveJson['grand_total'],
    );
    double calculatedSubtotal = JsonUtils.parseDouble(
      effectiveJson['subtotal'] ?? effectiveJson['total'],
    );

    if (calculatedSubtotal == 0 && itemsList.isNotEmpty) {
      calculatedSubtotal = itemsList.fold(
        0,
        (sum, item) => sum + item.totalPrice,
      );
    }

    if (calculatedTotal == 0) {
      calculatedTotal =
          calculatedSubtotal + JsonUtils.parseDouble(effectiveJson['tax']);
    }

    return CartModel(
      id: JsonUtils.parseInt(effectiveJson['id']),
      userId: JsonUtils.parseInt(effectiveJson['user_id']),
      items: itemsList,
      subtotal: calculatedSubtotal,
      tax: JsonUtils.parseDouble(effectiveJson['tax']),
      total: calculatedTotal,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'items': items.map((item) => item.toJson()).toList(),
    'subtotal': subtotal,
    'tax': tax,
    'total': total,
  };

  Cart toEntity() {
    return Cart(
      id: id,
      userId: userId,
      items: items.map((item) => item.toEntity()).toList(),
      subtotal: subtotal,
      tax: tax,
      total: total,
    );
  }
}
