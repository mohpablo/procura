import 'package:saas_app/core/api/api_consumer.dart';
import 'package:saas_app/core/api/api_endpoints.dart';
import '../models/login_response_model.dart';

class AuthRemoteDataSource {
  final ApiConsumer api;

  AuthRemoteDataSource(this.api);

  Future<LoginResponseModel> login(
    String email,
    String password,
    String role,
  ) async {
    final response = await api.post(
      EndPoints.login,
      body: {
        APIKeys.email: email,
        APIKeys.password: password,
        APIKeys.role: role,
        APIKeys.deviceName: 'mobile',
      },
    );

    return LoginResponseModel.fromJson(response[APIKeys.data]);
  }

  Future<LoginResponseModel> register({
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
    final response = await api.post(
      EndPoints.register,
      body: {
        APIKeys.name: name,
        APIKeys.email: email,
        APIKeys.password: password,
        APIKeys.passwordConfirmation: passwordConfirmation,
        APIKeys.role: role,
        APIKeys.phone: phone,
        APIKeys.companyName: companyName,
        APIKeys.companyType: companyType,
        APIKeys.companyAddress: companyAddress,
        APIKeys.deviceName: 'mobile',
      },
    );

    return LoginResponseModel.fromJson(response[APIKeys.data]);
  }

  Future<void> logout() async {
    await api.post(EndPoints.logout, withToken: true);
  }
}
