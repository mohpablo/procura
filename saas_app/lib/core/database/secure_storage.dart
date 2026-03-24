import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  static const tokenKey = "auth_token";
  static const userKey = "auth_user";
  static const roleKey = "user_role";

  Future<void> saveToken(String token) async {
    await storage.write(key: tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await storage.read(key: tokenKey);
  }

  Future<void> deleteToken() async {
    await storage.delete(key: tokenKey);
  }

  Future<void> saveUser(Map<String, dynamic> userData) async {
    final jsonString = jsonEncode(userData);
    await storage.write(key: userKey, value: jsonString);
  }

  Future<Map<String, dynamic>?> getUser() async {
    final jsonString = await storage.read(key: userKey);
    if (jsonString != null) {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> saveUserRole(String role) async {
    await storage.write(key: roleKey, value: role);
  }

  Future<String?> getUserRole() async {
    return await storage.read(key: roleKey);
  }

  Future<void> clearAuthData() async {
    await deleteToken();
    await storage.delete(key: userKey);
    await storage.delete(key: roleKey);
  }

  Future<bool> isUserLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
