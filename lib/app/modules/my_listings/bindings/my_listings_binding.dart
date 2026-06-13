import 'package:get/get.dart';
import '../controllers/my_listings_controller.dart';
import '../../home/home_repository.dart';
import '../../../../core/network/api_service.dart';

class MyListingsBinding extends Bindings {
  @override
  void dependencies() {
    // Only put HomeRepository if not already registered (HomeBinding might have registered it)
    if (!Get.isRegistered<HomeRepository>()) {
      Get.lazyPut<HomeRepository>(
        () => HomeRepository(Get.find<DioApiService>()),
      );
    }
    Get.lazyPut<MyListingsController>(
      () => MyListingsController(Get.find<HomeRepository>()),
    );
  }
}
