import 'package:saas_app/core/database/secure_storage.dart';
import 'package:saas_app/features/auth/domain/entities/user.dart';

class AuthService {
  final SecureStorage _storage;

  AuthService(this._storage);

  Future<void> saveUserSession(User user, String token) async {
    await _storage.saveToken(token);
    await _storage.saveUser({
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'role': user.role,
      'phone': user.phone,
      'address': user.address,
      'company_id': user.companyId,
    });
    await _storage.saveUserRole(user.role);
  }

  Future<User?> getCurrentUser() async {
    final userData = await _storage.getUser();
    if (userData != null) {
      return User(
        id: userData['id'] ?? 0,
        name: userData['name'] ?? '',
        email: userData['email'] ?? '',
        role: userData['role'] ?? '',
        phone: userData['phone'],
        address: userData['address'],
        companyId: userData['company_id'],
      );
    }
    return null;
  }

  Future<String?> getToken() async {
    return await _storage.getToken();
  }

  Future<String?> getUserRole() async {
    return await _storage.getUserRole();
  }

  Future<bool> isLoggedIn() async {
    return await _storage.isUserLoggedIn();
  }

  Future<void> logout() async {
    await _storage.clearAuthData();
  }
}
