import 'user_model.dart';

class LoginResponseModel {
  final String token;
  final String tokenType;
  final UserModel user;

  LoginResponseModel({
    required this.token,
    required this.tokenType,
    required this.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json['token'] ?? '',
      tokenType: json['token_type'] ?? 'Bearer',
      user: UserModel.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'token': token, 'token_type': tokenType, 'user': user.toJson()};
  }
}
