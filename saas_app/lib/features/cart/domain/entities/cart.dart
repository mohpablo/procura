class CartItem {
  final int id;
  final int productId;
  final String productName;
  final double unitPrice;
  final int quantity;
  final double totalPrice;
  final String? productImage;

  const CartItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
    required this.totalPrice,
    this.productImage,
  });

  CartItem copyWith({
    int? id,
    int? productId,
    String? productName,
    double? unitPrice,
    int? quantity,
    double? totalPrice,
    String? productImage,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
      productImage: productImage ?? this.productImage,
    );
  }
}

class Cart {
  final int id;
  final int userId;
  final List<CartItem> items;
  final double subtotal;
  final double tax;
  final double total;

  const Cart({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
  });

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
}
