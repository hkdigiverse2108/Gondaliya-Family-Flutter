import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:gondalia_family/app/data/services/storage_service.dart';
import 'package:gondalia_family/app/routes/app_pages.dart';
import 'package:gondalia_family/core/network/api_base_response.dart';

class AppException implements Exception {
  final String message;
  final int? statusCode;

  AppException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String errorMessage = "An unexpected error occurred.";
    int? statusCode = err.response?.statusCode;
    final data = err.response?.data;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
        errorMessage = "Connection timed out. Please retry.";
        break;
      case DioExceptionType.receiveTimeout:
        errorMessage = "Server took too long to respond.";
        break;
      case DioExceptionType.badResponse:
        // Parse the standard server envelope to get the right message
        if (data != null && data is Map<String, dynamic>) {
          final envelope = ApiBaseResponse.fromJson(data);
          errorMessage = envelope.errorMessage;
        }

        if (statusCode == 401) {
          Get.find<StorageService>().clearAuthToken();
          if (Get.currentRoute != Routes.login) {
            Get.offAllNamed(Routes.login);
            errorMessage = "Session expired. Please log in again.";
          }
        } else if (statusCode == 403) {
          errorMessage = "You don't have permission to do this.";
        } else if (statusCode == 404) {
          errorMessage = "The requested resource was not found.";
        } else if (statusCode == 500) {
          errorMessage = "Server error. Please try again later.";
        }
        break;
      case DioExceptionType.cancel:
        errorMessage = "Request was cancelled.";
        break;
      case DioExceptionType.connectionError:
        errorMessage = "No internet connection.";
        break;
      case DioExceptionType.unknown:
      default:
        errorMessage = "An unexpected error occurred.";
        break;
    }

    final appException = AppException(errorMessage, statusCode: statusCode);
    return super.onError(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: appException,
        message: errorMessage,
      ),
      handler,
    );
  }
}
