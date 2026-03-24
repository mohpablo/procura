part of 'cart_cubit.dart';

sealed class CartState {
  const CartState();
}

class CartInitial extends CartState {
  const CartInitial();
}

class CartLoading extends CartState {
  const CartLoading();
}

class CartLoaded extends CartState {
  final Cart cart;

  const CartLoaded(this.cart);
}

class CartUpdated extends CartState {
  final Cart cart;
  final String message;

  const CartUpdated(this.cart, this.message);
}

class CartEmpty extends CartState {
  const CartEmpty();
}

class CartError extends CartState {
  final String message;
  final String? code;

  const CartError(this.message, {this.code});
}
