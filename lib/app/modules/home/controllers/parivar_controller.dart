import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../data/models/parivar_directory.dart';
import '../home_repository.dart';

class ParivarController extends GetxController {
  final HomeRepository _homeRepo;

  ParivarController(this._homeRepo);

  final parivarDirectories = <ParivarDirectory>[].obs;
  final parivarVillages = <String>[].obs;
  final isParivarLoading = false.obs;
  final isDirectoryLoading = false.obs; // Loader for lazy directory API fetch
  final selectedVillage =
      ''.obs; // Default to empty string for village grid view
  final parivarSearchQuery = ''.obs;
  final searchController = TextEditingController();

  final isApiSuccess = true.obs;
  final isDirectoryApiSuccess = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to search queries and prefetch parivar directory if no matching villages are found
    ever(parivarSearchQuery, (query) {
      if (query.trim().isNotEmpty &&
          selectedVillage.value.isEmpty &&
          filteredVillages.isEmpty) {
        preFetchDirectoryIfNeeded();
      }
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> preFetchDirectoryIfNeeded() async {
    if (parivarDirectories.isEmpty && !isDirectoryLoading.value) {
      isDirectoryLoading.value = true;
      try {
        await _preFetchParivarDirectory();
      } catch (e) {
        // Ignore
      } finally {
        isDirectoryLoading.value = false;
      }
    }
  }

  List<String> get filteredVillages {
    final list = parivarVillages.toList();
    if (parivarSearchQuery.value.trim().isNotEmpty) {
      final q = parivarSearchQuery.value.toLowerCase();
      return list.where((v) => v.toLowerCase().contains(q)).toList();
    }
    return list;
  }

  int getMemberCountForVillage(String village) {
    return parivarDirectories.where((p) => p.head.village == village).length;
  }

  Future<void>? _preFetchFuture;

  Future<void> _preFetchParivarDirectory() {
    if (parivarDirectories.isNotEmpty) {
      return Future.value();
    }
    _preFetchFuture ??= _doPreFetch();
    return _preFetchFuture!;
  }

  Future<void> _doPreFetch() async {
    isDirectoryApiSuccess.value = true;
    try {
      final directory = await _homeRepo.getParivarDirectory();
      if (directory != null) {
        parivarDirectories.assignAll(directory);
        isDirectoryApiSuccess.value = true;
      } else {
        isDirectoryApiSuccess.value = false;
      }
    } catch (e) {
      isDirectoryApiSuccess.value = false;
    }
  }

  Future<void> selectVillage(String village) async {
    selectedVillage.value = village;
    parivarSearchQuery.value = '';
    searchController.clear();

    // If directory list is not loaded yet, wait for the background pre-fetch
    if (parivarDirectories.isEmpty) {
      isDirectoryLoading.value = true;
      try {
        await _preFetchParivarDirectory();
      } catch (e) {
        // Ignore
      } finally {
        isDirectoryLoading.value = false;
      }
    }
  }

  void clearVillageSelection() {
    selectedVillage.value = '';
    parivarSearchQuery.value = '';
    searchController.clear();
  }

  List<ParivarDirectory> get filteredParivar {
    var list = parivarDirectories.toList();
    if (selectedVillage.value.isNotEmpty) {
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
    isApiSuccess.value = true;
    try {
      final villages = await _homeRepo.getParivarVillages();
      if (villages != null) {
        parivarVillages.assignAll(villages);
        isApiSuccess.value = true;
      } else {
        isApiSuccess.value = false;
      }
    } catch (e) {
      isApiSuccess.value = false;
    } finally {
      isParivarLoading.value = false;
    }
  }

  void fetchVillagesIfNeeded() {
    if (parivarVillages.isEmpty && !isParivarLoading.value) {
      fetchParivarData();
    }
  }
}
