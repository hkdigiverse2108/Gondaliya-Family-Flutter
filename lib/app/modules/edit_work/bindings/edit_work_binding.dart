import 'package:get/get.dart';
import '../controllers/edit_work_controller.dart';

class EditWorkBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditWorkController>(EditWorkController.new);
  }
}
