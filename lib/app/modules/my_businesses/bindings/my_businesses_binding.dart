import 'package:get/get.dart';
import '../controllers/my_businesses_controller.dart';

class MyBusinessesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyBusinessesController>(MyBusinessesController.new);
  }
}
