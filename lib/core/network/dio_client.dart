import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import 'api_exception.dart';

/// Central Dio HTTP client with interceptors and error translation
class DioClient {
  late final Dio _dio;

  DioClient({Dio? dio}) {
    _dio = dio ??
        Dio(
          BaseOptions(
            connectTimeout: ApiConstants.connectTimeout,
            receiveTimeout: ApiConstants.receiveTimeout,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        );

    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  Dio get dio => _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  ApiException _handleDioError(DioException error) {
    String message = 'An unexpected network error occurred';
    if (error.response?.data is Map &&
        (error.response?.data as Map).containsKey('error')) {
      final err = (error.response?.data as Map)['error'];
      if (err is Map && err.containsKey('message')) {
        message = err['message'].toString();
      } else {
        message = err.toString();
      }
    } else if (error.message != null && error.message!.isNotEmpty) {
      message = error.message!;
    }

    return ApiException(
      message: message,
      statusCode: error.response?.statusCode,
      details: error.response?.data,
    );
  }
}
