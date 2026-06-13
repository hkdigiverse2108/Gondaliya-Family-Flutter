import 'package:get/get.dart';
import '../../../data/models/listing.dart';

class ListingDetailController extends GetxController {
  final listing = Rxn<Listing>();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map) {
      listing.value = args['listing'] as Listing?;
    }
  }
}
