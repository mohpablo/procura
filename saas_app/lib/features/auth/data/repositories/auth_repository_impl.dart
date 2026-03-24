import 'package:saas_app/core/database/secure_storage.dart';
import 'package:saas_app/core/network/result.dart';
import 'package:saas_app/core/errors/app_exceptions.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final SecureStorage storage;

  AuthRepositoryImpl(this.remote, this.storage);

  @override
  Future<Result<UserModel>> login(
    String email,
    String password,
    String role,
  ) async {
    try {
      final response = await remote.login(email, password, role);

      // Save token
      await storage.saveToken(response.token);

      // Save user data
      await storage.saveUser(response.user.toJson());

      // Save user role
      await storage.saveUserRole(response.user.role);

      return Success(response.user);
    } on ServerException catch (e) {
      return Failure(e.message);
    } on NetworkException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<UserModel>> register({
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
    try {
      final response = await remote.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        role: role,
        phone: phone,
        companyName: companyName,
        companyType: companyType,
        companyAddress: companyAddress,
      );

      // Save token
      await storage.saveToken(response.token);

      // Save user data
      await storage.saveUser(response.user.toJson());

      // Save user role
      await storage.saveUserRole(response.user.role);

      return Success(response.user);
    } on ServerException catch (e) {
      return Failure(e.message);
    } on NetworkException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await remote.logout();
      await storage.clearAuthData();
      return const Success(null);
    } on ServerException catch (e) {
      return Failure(e.message);
    } on NetworkException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<bool>> isUserLoggedIn() async {
    try {
      final isLoggedIn = await storage.isUserLoggedIn();
      return Success(isLoggedIn);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<UserModel?>> getCurrentUser() async {
    try {
      final userData = await storage.getUser();
      if (userData != null) {
        return Success(
          UserModel(
            id: userData['id'] ?? 0,
            name: userData['name'] ?? '',
            email: userData['email'] ?? '',
            role: userData['role'] ?? 'buyer',
            companyId: userData['company_id'],
            address: userData['address'],
            phone: userData['phone'],
          ),
        );
      }
      return const Success(null);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<String?>> getUserRole() async {
    try {
      final role = await storage.getUserRole();
      return Success(role);
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
