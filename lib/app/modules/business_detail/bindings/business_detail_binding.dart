import 'package:get/get.dart';
import '../controllers/business_detail_controller.dart';

class BusinessDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BusinessDetailController>(BusinessDetailController.new);
  }
}
