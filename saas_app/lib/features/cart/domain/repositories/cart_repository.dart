import 'package:saas_app/core/network/result.dart';
import '../entities/cart.dart';

abstract class CartRepository {
  Future<Result<Cart>> getCart();
  Future<Result<Cart>> addToCart(int productId, int quantity);
  Future<Result<Cart>> updateCartItem(int productId, int quantity);
  Future<Result<Cart>> removeFromCart(int productId);
  Future<Result<void>> clearCart();
}
