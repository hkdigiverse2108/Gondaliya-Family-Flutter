import 'package:get/get.dart';
import '../controllers/placeholder_home_controller.dart';

class PlaceholderHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlaceholderHomeController>(() => PlaceholderHomeController());
  }
}
