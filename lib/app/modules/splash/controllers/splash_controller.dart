import 'package:get/get.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/network/api_service.dart';
import '../../../data/services/firebase_notification_service.dart';
import '../../../data/services/socket_service.dart';
import '../../../data/services/storage_service.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    Get.put<DioApiService>(
      DioApiService(baseUrl: AppConfig.baseUrl),
      permanent: true,
    );

    await Future.delayed(const Duration(milliseconds: 2000));

    final storageService = Get.find<StorageService>();
    final token = storageService.authToken;
    if (token != null && token.isNotEmpty) {
      Get.find<SocketService>().connect();
      // Sync FCM Token with backend if service is initialized
      if (Get.isRegistered<FirebaseNotificationService>()) {
        FirebaseNotificationService.to.uploadFcmToken();
      }
      Get.offAllNamed(Routes.home);
    } else {
      Get.offAllNamed(Routes.login);
    }
  }
}
