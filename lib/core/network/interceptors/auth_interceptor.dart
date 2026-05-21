import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:gondalia_family/app/data/services/storage_service.dart';
import '../api_endpoints.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final isPublicPath = ApiEndpoints.publicPaths.any(
      (path) => options.path.contains(path),
    );

    if (!isPublicPath) {
      final storageService = Get.find<StorageService>();
      final token = storageService.authToken;
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    super.onRequest(options, handler);
  }
}
