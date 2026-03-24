import 'package:saas_app/features/auth/domain/entities/user.dart';
import 'package:saas_app/core/network/result.dart';
import 'package:saas_app/core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class RegisterParams {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;
  final String role;
  final String? phone;
  final String? companyName;
  final String? companyType;
  final String? companyAddress;

  RegisterParams({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.role,
    this.phone,
    this.companyName,
    this.companyType,
    this.companyAddress,
  });
}

class RegisterUseCase implements UseCase<User, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Result<User>> call(RegisterParams params) async {
    return await repository.register(
      name: params.name,
      email: params.email,
      password: params.password,
      passwordConfirmation: params.passwordConfirmation,
      role: params.role,
      phone: params.phone,
      companyName: params.companyName,
      companyType: params.companyType,
      companyAddress: params.companyAddress,
    );
  }
}
