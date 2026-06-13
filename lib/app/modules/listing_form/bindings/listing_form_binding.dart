import 'package:get/get.dart';
import '../controllers/listing_form_controller.dart';

class ListingFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListingFormController>(ListingFormController.new);
  }
}
