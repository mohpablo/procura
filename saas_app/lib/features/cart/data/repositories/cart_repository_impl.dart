import 'package:saas_app/core/network/result.dart';
import 'package:saas_app/core/errors/app_exceptions.dart';
import 'package:saas_app/features/cart/domain/entities/cart.dart';
import 'package:saas_app/features/cart/domain/repositories/cart_repository.dart';
import '../datasources/cart_remote_datasource.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<Cart>> getCart() async {
    try {
      final model = await remoteDataSource.getCart();
      return Result.success(model.toEntity());
    } on ServerException catch (e) {
      return Result.failure(e.message);
    } on NetworkException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Failed to fetch cart: ${e.toString()}');
    }
  }

  @override
  Future<Result<Cart>> addToCart(int productId, int quantity) async {
    try {
      if (quantity <= 0) {
        return Result.failure('Quantity must be greater than 0');
      }
      final model = await remoteDataSource.addToCart(productId, quantity);
      return Result.success(model.toEntity());
    } on ServerException catch (e) {
      return Result.failure(e.message);
    } on NetworkException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Failed to add to cart: ${e.toString()}');
    }
  }

  @override
  Future<Result<Cart>> updateCartItem(int productId, int quantity) async {
    try {
      if (quantity <= 0) {
        return Result.failure('Quantity must be greater than 0');
      }
      final model = await remoteDataSource.updateCartItem(productId, quantity);
      return Result.success(model.toEntity());
    } on ServerException catch (e) {
      return Result.failure(e.message);
    } on NetworkException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Failed to update cart: ${e.toString()}');
    }
  }

  @override
  Future<Result<Cart>> removeFromCart(int productId) async {
    try {
      final model = await remoteDataSource.removeFromCart(productId);
      return Result.success(model.toEntity());
    } on ServerException catch (e) {
      return Result.failure(e.message);
    } on NetworkException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Failed to remove from cart: ${e.toString()}');
    }
  }

  @override
  Future<Result<void>> clearCart() async {
    try {
      await remoteDataSource.clearCart();
      return Result.success(null);
    } on ServerException catch (e) {
      return Result.failure(e.message);
    } on NetworkException catch (e) {
      return Result.failure(e.message);
    } catch (e) {
      return Result.failure('Failed to clear cart: ${e.toString()}');
    }
  }
}
