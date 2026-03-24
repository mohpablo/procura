import 'package:saas_app/core/api/api_consumer.dart';
import 'package:saas_app/core/api/api_endpoints.dart';
import 'package:saas_app/core/database/secure_storage.dart';
import '../models/user_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> getProfile();
  Future<UserProfileModel> updateProfile(Map<String, dynamic> data);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiConsumer api;
  final SecureStorage secureStorage;

  ProfileRemoteDataSourceImpl(this.api, this.secureStorage);

  @override
  Future<UserProfileModel> getProfile() async {
    try {
      final role = await secureStorage.getUserRole();
      final endpoint = role == 'supplier'
          ? EndPoints.supplierProfile
          : EndPoints.buyerProfile;

      final response = await api.get(endpoint, withToken: true);
      return UserProfileModel.fromJson(response[APIKeys.data]);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserProfileModel> updateProfile(Map<String, dynamic> data) async {
    try {
      final role = await secureStorage.getUserRole();
      final endpoint = role == 'supplier'
          ? EndPoints.supplierProfile
          : EndPoints.buyerProfile;

      final response = await api.put(endpoint, body: data, withToken: true);
      return UserProfileModel.fromJson(response[APIKeys.data]);
    } catch (e) {
      rethrow;
    }
  }
}
