import 'package:saas_app/core/network/result.dart';
import '../entities/user_profile.dart';

abstract class ProfileRepository {
  Future<Result<UserProfile>> getProfile();
  Future<Result<UserProfile>> updateProfile(Map<String, dynamic> data);
  Future<Result<void>> logout();
}
