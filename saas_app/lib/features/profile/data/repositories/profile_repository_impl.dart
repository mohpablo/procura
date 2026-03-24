import 'package:saas_app/core/network/result.dart';
import 'package:saas_app/features/profile/domain/entities/user_profile.dart';
import 'package:saas_app/features/profile/domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<UserProfile>> getProfile() async {
    try {
      final result = await remoteDataSource.getProfile();
      return Result.success(result.toEntity());
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<UserProfile>> updateProfile(Map<String, dynamic> data) async {
    try {
      final result = await remoteDataSource.updateProfile(data);
      return Result.success(result.toEntity());
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      // Implement logout logic here
      return Result.success(null);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
