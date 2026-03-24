import '../entities/user.dart';
import '../repositories/auth_repository.dart';

import 'package:saas_app/core/network/result.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Result<User>> call(String email, String password, String role) async {
    return await repository.login(email, password, role);
  }
}
