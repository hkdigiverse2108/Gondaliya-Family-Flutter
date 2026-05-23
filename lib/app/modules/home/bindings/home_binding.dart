import 'package:get/get.dart';
import 'package:gondalia_family/core/network/api_service.dart';
import '../controllers/home_controller.dart';
import '../home_repository.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeRepository>(
      () => HomeRepository(Get.find<DioApiService>()),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}

