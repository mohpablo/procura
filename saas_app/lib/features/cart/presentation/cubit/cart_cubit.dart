import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saas_app/features/cart/domain/entities/cart.dart';
import 'package:saas_app/features/cart/domain/usecases/cart_usecases.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final GetCartUseCase getCartUseCase;
  final AddToCartUseCase addToCartUseCase;
  final UpdateCartItemUseCase updateCartItemUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final ClearCartUseCase clearCartUseCase;

  CartCubit({
    required this.getCartUseCase,
    required this.addToCartUseCase,
    required this.updateCartItemUseCase,
    required this.removeFromCartUseCase,
    required this.clearCartUseCase,
  }) : super(const CartInitial());

  Future<void> loadCart() async {
    emit(const CartLoading());

    final result = await getCartUseCase();

    result.when(
      onSuccess: (cart) {
        if (cart.items.isEmpty) {
          emit(const CartEmpty());
        } else {
          emit(CartLoaded(cart));
        }
      },
      onFailure: (message, code) {
        emit(CartError(message, code: code));
      },
    );
  }

  Future<void> addToCart(int productId, int quantity) async {
    print(
      'CartCubit: Adding to cart - ProductId: $productId, Quantity: $quantity',
    );
    emit(const CartLoading());

    final result = await addToCartUseCase(
      AddToCartParams(productId: productId, quantity: quantity),
    );

    result.when(
      onSuccess: (cart) {
        print(
          'CartCubit: Successfully added to cart. Items: ${cart.items.length}',
        );
        if (cart.items.isEmpty) {
          // If the backend returns an empty cart after a successful add,
          // trigger a full reload to be safe.
          loadCart();
        } else {
          emit(CartUpdated(cart, 'Item added to cart'));
        }
      },
      onFailure: (message, code) {
        print('CartCubit: Failed to add to cart: $message (code: $code)');
        emit(CartError(message, code: code));
      },
    );
  }

  Future<void> updateCartItem(int productId, int quantity) async {
    emit(const CartLoading());

    final result = await updateCartItemUseCase(
      UpdateCartItemParams(productId: productId, quantity: quantity),
    );

    result.when(
      onSuccess: (cart) {
        if (cart.items.isEmpty) {
          loadCart();
        } else {
          emit(CartUpdated(cart, 'Cart updated'));
        }
      },
      onFailure: (message, code) {
        emit(CartError(message, code: code));
      },
    );
  }

  Future<void> removeFromCart(int productId) async {
    emit(const CartLoading());

    final result = await removeFromCartUseCase(productId);

    result.when(
      onSuccess: (cart) {
        if (cart.items.isEmpty) {
          loadCart();
        } else {
          emit(CartUpdated(cart, 'Item removed from cart'));
        }
      },
      onFailure: (message, code) {
        emit(CartError(message, code: code));
      },
    );
  }

  Future<void> clearCart() async {
    final result = await clearCartUseCase();

    result.when(
      onSuccess: (_) {
        emit(const CartEmpty());
      },
      onFailure: (message, code) {
        emit(CartError(message, code: code));
      },
    );
  }

  void refresh() {
    loadCart();
  }
}
