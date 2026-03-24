class ApiResponse<T> {
  final T? data;
  final String? message;
  final int? statusCode;
  final bool success;
  final dynamic error;

  ApiResponse({
    this.data,
    this.message,
    this.statusCode,
    this.success = false,
    this.error,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json, {
    required T Function(dynamic)? fromJsonT,
  }) {
    return ApiResponse(
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : null,
      message: json['message'] as String?,
      statusCode: json['status'] as int? ?? json['status_code'] as int?,
      success: json['success'] as bool? ?? false,
      error: json['error'],
    );
  }

  factory ApiResponse.success({required T data, String? message}) {
    return ApiResponse(
      data: data,
      message: message,
      success: true,
      statusCode: 200,
    );
  }

  factory ApiResponse.error({
    required String message,
    int? statusCode,
    dynamic error,
  }) {
    return ApiResponse(
      message: message,
      statusCode: statusCode ?? 500,
      success: false,
      error: error,
    );
  }

  bool get isSuccess => success && statusCode == 200;
  bool get isError => !success || statusCode != 200;

  @override
  String toString() =>
      'ApiResponse(data: $data, message: $message, statusCode: $statusCode, success: $success)';
}
