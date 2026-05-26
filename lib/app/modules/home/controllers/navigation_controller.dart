import 'package:get/get.dart';
import 'parivar_controller.dart';

class NavigationController extends GetxController {
  final currentIndex = 0.obs;
  final visitedIndices = <int>{0}.obs;

  void changeTab(int index) {
    currentIndex.value = index;
    visitedIndices.add(index);
    if (index == 1) {
      if (Get.isRegistered<ParivarController>()) {
        Get.find<ParivarController>().fetchVillagesIfNeeded();
      }
    }
  }
}
