import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'api_base_response.dart';
import 'api_response.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';

class DioApiService {
  late final Dio _dio;

  DioApiService({required String baseUrl}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        contentType: 'application/json',
        responseType: ResponseType.json,
      ),
    );

    _dio.interceptors.addAll([
      AuthInterceptor(),
      ErrorInterceptor(),
      if (kDebugMode)
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
    ]);
  }

  Future<ApiResponse<T>> _request<T>(
    String path, {
    required String method,
    dynamic data,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    T Function(dynamic json)? fromJson,
    void Function(int sent, int total)? onSendProgress,
  }) async {
    try {
      final response = await _dio.request(
        path,
        data: data,
        queryParameters: queryParams,
        onSendProgress: onSendProgress,
        options: Options(method: method, headers: headers),
      );

      // Parse the standard server envelope first
      final envelope = (response.data is Map<String, dynamic>)
          ? ApiBaseResponse.fromJson(response.data as Map<String, dynamic>)
          : ApiBaseResponse(status: response.statusCode, data: response.data);

      // Hand the inner `data` field to the model-specific fromJson
      T? parsedData;
      if (fromJson != null && envelope.data != null) {
        parsedData = fromJson(envelope.data);
      } else if (envelope.data != null) {
        parsedData = envelope.data as T?;
      }

      return ApiResponse.success(
        parsedData as T,
        statusCode: envelope.status ?? response.statusCode,
        message: envelope.message,
      );
    } on DioException catch (e) {
      if (e.error is AppException) {
        final appException = e.error as AppException;
        return ApiResponse.failure(
          appException.message,
          statusCode: appException.statusCode,
        );
      }
      return ApiResponse.failure(
        e.message ?? 'An unexpected error occurred.',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return ApiResponse.failure(
        'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    T Function(dynamic json)? fromJson,
  }) {
    return _request<T>(
      path,
      method: 'GET',
      queryParams: queryParams,
      headers: headers,
      fromJson: fromJson,
    );
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    T Function(dynamic json)? fromJson,
  }) {
    return _request<T>(
      path,
      method: 'POST',
      data: data,
      queryParams: queryParams,
      headers: headers,
      fromJson: fromJson,
    );
  }

  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    T Function(dynamic json)? fromJson,
  }) {
    return _request<T>(
      path,
      method: 'PUT',
      data: data,
      queryParams: queryParams,
      headers: headers,
      fromJson: fromJson,
    );
  }

  Future<ApiResponse<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    T Function(dynamic json)? fromJson,
  }) {
    return _request<T>(
      path,
      method: 'PATCH',
      data: data,
      queryParams: queryParams,
      headers: headers,
      fromJson: fromJson,
    );
  }

  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    T Function(dynamic json)? fromJson,
  }) {
    return _request<T>(
      path,
      method: 'DELETE',
      data: data,
      queryParams: queryParams,
      headers: headers,
      fromJson: fromJson,
    );
  }

  Future<ApiResponse<T>> uploadFile<T>(
    String path, {
    required FormData formData,
    Map<String, dynamic>? headers,
    T Function(dynamic json)? fromJson,
    void Function(int sent, int total)? onSendProgress,
  }) {
    return _request<T>(
      path,
      method: 'POST',
      data: formData,
      headers: headers,
      fromJson: fromJson,
      onSendProgress: onSendProgress,
    );
  }
}
