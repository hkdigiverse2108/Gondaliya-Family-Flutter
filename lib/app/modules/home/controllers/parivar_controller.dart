import 'package:get/get.dart';
import '../../../data/models/parivar_directory.dart';
import '../home_repository.dart';

class ParivarController extends GetxController {
  final HomeRepository _homeRepo;

  ParivarController(this._homeRepo);

  final parivarDirectories = <ParivarDirectory>[].obs;
  final parivarVillages = <String>[].obs;
  final isParivarLoading = false.obs;
  final selectedVillage = 'All'.obs;
  final parivarSearchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchParivarData();
  }

  List<ParivarDirectory> get filteredParivar {
    var list = parivarDirectories.toList();
    if (selectedVillage.value != 'All') {
      list = list
          .where((p) => p.head.village == selectedVillage.value)
          .toList();
    }
    if (parivarSearchQuery.value.trim().isNotEmpty) {
      final q = parivarSearchQuery.value.toLowerCase();
      list = list
          .where(
            (p) =>
                p.head.firstName.toLowerCase().contains(q) ||
                p.head.lastName.toLowerCase().contains(q) ||
                p.head.village.toLowerCase().contains(q) ||
                (p.head.workDetailsSummary?.toLowerCase().contains(q) ?? false),
          )
          .toList();
    }
    return list;
  }

  Future<void> fetchParivarData() async {
    isParivarLoading.value = true;
    try {
      final villages = await _homeRepo.getParivarVillages();
      parivarVillages.assignAll(['All', ...villages]);

      final directory = await _homeRepo.getParivarDirectory();
      parivarDirectories.assignAll(directory);
    } catch (e) {
      // Ignore
    } finally {
      isParivarLoading.value = false;
    }
  }
}
