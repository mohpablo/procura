part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;

  AuthSuccess(this.user);
}

class AuthBuyerSuccess extends AuthState {
  final User user;

  AuthBuyerSuccess(this.user);
}

class AuthSupplierSuccess extends AuthState {
  final User user;

  AuthSupplierSuccess(this.user);
}

class AuthAdminSuccess extends AuthState {
  final User user;

  AuthAdminSuccess(this.user);
}

class AuthRegisterSuccess extends AuthState {
  AuthRegisterSuccess();
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}
