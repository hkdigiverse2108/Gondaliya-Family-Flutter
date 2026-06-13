import 'package:get/get.dart';
import '../controllers/edit_business_controller.dart';

class EditBusinessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditBusinessController>(EditBusinessController.new);
  }
}
