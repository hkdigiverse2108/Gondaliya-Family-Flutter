import 'package:get/get.dart';
import '../../../../core/network/api_service.dart';
import '../controllers/home_controller.dart';
import '../home_repository.dart';
import '../controllers/navigation_controller.dart';
import '../controllers/parivar_controller.dart';
import '../controllers/marketplace_controller.dart';
import '../controllers/profile_controller.dart';
import '../../announcements/controllers/announcements_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeRepository>(
      () => HomeRepository(Get.find<DioApiService>()),
    );
    Get.lazyPut<NavigationController>(NavigationController.new);
    Get.lazyPut<HomeController>(HomeController.new, fenix: true);
    Get.put<ParivarController>(ParivarController(Get.find<HomeRepository>()));
    Get.lazyPut<MarketplaceController>(
      () => MarketplaceController(Get.find<HomeRepository>()),
      fenix: true,
    );
    Get.lazyPut<ProfileController>(ProfileController.new, fenix: true);
    Get.lazyPut<AnnouncementsController>(
      AnnouncementsController.new,
      fenix: true,
    );
  }
}
