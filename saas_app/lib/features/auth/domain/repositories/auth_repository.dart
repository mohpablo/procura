import 'package:saas_app/core/network/result.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Result<User>> login(String email, String password, String role);
  Future<Result<User>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String role,
    String? phone,
    String? companyName,
    String? companyType,
    String? companyAddress,
  });
  Future<Result<void>> logout();
  Future<Result<bool>> isUserLoggedIn();
  Future<Result<User?>> getCurrentUser();
  Future<Result<String?>> getUserRole();
}
