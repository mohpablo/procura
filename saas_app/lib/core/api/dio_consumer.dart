import 'package:dio/dio.dart';
import 'package:saas_app/core/api/api_consumer.dart';
import 'package:saas_app/core/api/api_endpoints.dart';
import 'package:saas_app/core/errors/app_exceptions.dart';
import 'package:saas_app/core/errors/error_model.dart';
import 'package:saas_app/core/database/secure_storage.dart';

class DioConsumer extends ApiConsumer {
  final Dio dio;

  DioConsumer(this.dio) {
    dio.options.baseUrl = EndPoints.baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 15);
    dio.options.receiveTimeout = const Duration(seconds: 15);
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Accept'] = 'application/json';
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: false,
      ),
    );
  }

  Future<Options> _buildOptions(bool withToken) async {
    final Map<String, dynamic> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (withToken) {
      final token = await SecureStorage().getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return Options(headers: headers);
  }

  void _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.unknown) {
      // Network-level errors where e.response is null
      throw ServerException(
        e.message ?? 'Network error. Check your connection.',
      );
    }

    if (e.type == DioExceptionType.badResponse && e.response != null) {
      final data = e.response!.data;
      if (data is Map<String, dynamic>) {
        final errorModel = ErrorModel.fromJson(data);
        throw ServerException(
          errorModel.message,
          statusCode: errorModel.statusCode,
        );
      }
      throw ServerException(
        'Server error (${e.response!.statusCode})',
        statusCode: e.response!.statusCode,
      );
    }

    throw ServerException(e.message ?? 'An unexpected error occurred.');
  }

  @override
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool withToken = false,
  }) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: queryParameters,
        options: await _buildOptions(withToken),
      );
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<dynamic> post(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    bool withToken = false,
  }) async {
    try {
      final response = await dio.post(
        path,
        data: body,
        queryParameters: queryParameters,
        options: await _buildOptions(withToken),
      );
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<dynamic> put(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    bool withToken = false,
  }) async {
    try {
      final response = await dio.put(
        path,
        data: body,
        queryParameters: queryParameters,
        options: await _buildOptions(withToken),
      );
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<dynamic> delete(
    String path, {
    Object? body,
    Map<String, dynamic>? queryParameters,
    bool withToken = false,
  }) async {
    try {
      final response = await dio.delete(
        path,
        data: body,
        queryParameters: queryParameters,
        options: await _buildOptions(withToken),
      );
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }
}
