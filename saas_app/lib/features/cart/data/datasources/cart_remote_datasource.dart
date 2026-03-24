import 'package:saas_app/core/api/api_consumer.dart';
import 'package:saas_app/core/api/api_endpoints.dart';
import '../models/cart_model.dart';

class CartRemoteDataSource {
  final ApiConsumer api;

  CartRemoteDataSource(this.api);

  Future<CartModel> getCart() async {
    try {
      final response = await api.get(EndPoints.cart, withToken: true);
      return CartModel.fromJson(response[APIKeys.data]);
    } catch (e) {
      rethrow;
    }
  }

  Future<CartModel> addToCart(int productId, int quantity) async {
    try {
      final response = await api.post(
        EndPoints.addToCart,
        body: {APIKeys.productId: productId, APIKeys.quantity: quantity},
        withToken: true,
      );
      return CartModel.fromJson(response[APIKeys.data]);
    } catch (e) {
      rethrow;
    }
  }

  Future<CartModel> updateCartItem(int productId, int quantity) async {
    try {
      final response = await api.put(
        EndPoints.updateCart(productId),
        body: {APIKeys.quantity: quantity},
        withToken: true,
      );
      return CartModel.fromJson(response[APIKeys.data]);
    } catch (e) {
      rethrow;
    }
  }

  Future<CartModel> removeFromCart(int productId) async {
    try {
      final response = await api.delete(
        EndPoints.removeFromCart(productId),
        withToken: true,
      );
      return CartModel.fromJson(response[APIKeys.data]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> clearCart() async {
    try {
      await api.post(EndPoints.clearCart, withToken: true);
    } catch (e) {
      rethrow;
    }
  }
}
