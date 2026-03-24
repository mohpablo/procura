import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:saas_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:saas_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:saas_app/features/auth/domain/entities/user.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;

  AuthCubit({required this.loginUseCase, required this.registerUseCase})
    : super(AuthInitial());

  Future<void> login(String email, String password, String role) async {
    emit(AuthLoading());
    final result = await loginUseCase(email, password, role);

    result.when(
      onSuccess: (user) {
        if (user.role.toLowerCase() == 'buyer') {
          emit(AuthBuyerSuccess(user));
        } else if (user.role.toLowerCase() == 'supplier') {
          emit(AuthSupplierSuccess(user));
        } else if (user.role.toLowerCase() == 'admin') {
          emit(AuthAdminSuccess(user));
        } else {
          emit(AuthSuccess(user));
        }
      },
      onFailure: (message, code) {
        emit(AuthError(message));
      },
    );
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String role,
    String? phone,
    String? companyName,
    String? companyType,
    String? companyAddress,
  }) async {
    emit(AuthLoading());
    final result = await registerUseCase(
      RegisterParams(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        role: role,
        phone: phone,
        companyName: companyName,
        companyType: companyType,
        companyAddress: companyAddress,
      ),
    );

    result.when(
      onSuccess: (user) {
        if (user.role.toLowerCase() == 'buyer') {
          emit(AuthBuyerSuccess(user));
        } else if (user.role.toLowerCase() == 'supplier') {
          emit(AuthSupplierSuccess(user));
        } else if (user.role.toLowerCase() == 'admin') {
          emit(AuthAdminSuccess(user));
        } else {
          emit(AuthSuccess(user));
        }
      },
      onFailure: (message, code) {
        emit(AuthError(message));
      },
    );
  }
}
