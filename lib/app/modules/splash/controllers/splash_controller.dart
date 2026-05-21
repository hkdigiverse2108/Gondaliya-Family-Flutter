import 'package:get/get.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/network/api_service.dart';
import '../../../data/services/storage_service.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
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
      Get.offAllNamed(Routes.home);
    } else {
      Get.offAllNamed(Routes.login);
    }
  }
}
