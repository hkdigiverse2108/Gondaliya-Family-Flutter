import 'package:get/get.dart';
import 'package:gondalia_family/core/network/api_service.dart';
import '../controllers/home_controller.dart';
import '../home_repository.dart';
import 'package:gondalia_family/app/modules/home/controllers/navigation_controller.dart';
import 'package:gondalia_family/app/modules/home/controllers/parivar_controller.dart';
import 'package:gondalia_family/app/modules/home/controllers/marketplace_controller.dart';
import 'package:gondalia_family/app/modules/home/controllers/profile_controller.dart';
import 'package:gondalia_family/app/modules/announcements/controllers/announcements_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeRepository>(
      () => HomeRepository(Get.find<DioApiService>()),
    );
    Get.lazyPut<NavigationController>(() => NavigationController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ParivarController>(
      () => ParivarController(Get.find<HomeRepository>()),
    );
    Get.lazyPut<MarketplaceController>(
      () => MarketplaceController(Get.find<HomeRepository>()),
    );
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<AnnouncementsController>(() => AnnouncementsController());
  }
}
