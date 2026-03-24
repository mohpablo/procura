import 'package:saas_app/core/api/api_endpoints.dart';

class ErrorModel {
  final String message;
  final int? statusCode;

  ErrorModel({required this.message, this.statusCode});

  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    final dynamic messageData = json[APIKeys.message];

    return ErrorModel(
      message: messageData is List
          ? messageData.first.toString()
          : messageData.toString(),
      statusCode: json['status_code'] as int?,
    );
  }
}
