import 'package:saas_app/core/network/result.dart';
import 'package:saas_app/core/usecases/usecase.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

class GetCartUseCase implements NoParamUseCase<Cart> {
  final CartRepository repository;

  GetCartUseCase(this.repository);

  @override
  Future<Result<Cart>> call() => repository.getCart();
}

class AddToCartUseCase implements UseCase<Cart, AddToCartParams> {
  final CartRepository repository;

  AddToCartUseCase(this.repository);

  @override
  Future<Result<Cart>> call(AddToCartParams params) {
    return repository.addToCart(params.productId, params.quantity);
  }
}

class AddToCartParams {
  final int productId;
  final int quantity;

  AddToCartParams({required this.productId, required this.quantity});
}

class UpdateCartItemUseCase implements UseCase<Cart, UpdateCartItemParams> {
  final CartRepository repository;

  UpdateCartItemUseCase(this.repository);

  @override
  Future<Result<Cart>> call(UpdateCartItemParams params) {
    return repository.updateCartItem(params.productId, params.quantity);
  }
}

class UpdateCartItemParams {
  final int productId;
  final int quantity;

  UpdateCartItemParams({required this.productId, required this.quantity});
}

class RemoveFromCartUseCase implements UseCase<Cart, int> {
  final CartRepository repository;

  RemoveFromCartUseCase(this.repository);

  @override
  Future<Result<Cart>> call(int productId) {
    return repository.removeFromCart(productId);
  }
}

class ClearCartUseCase implements NoParamUseCase<void> {
  final CartRepository repository;

  ClearCartUseCase(this.repository);

  @override
  Future<Result<void>> call() => repository.clearCart();
}
