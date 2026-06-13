import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/listing.dart';
import '../../home/home_repository.dart';
import '../../home/controllers/marketplace_controller.dart';

class MyListingsController extends GetxController {
  final HomeRepository _homeRepo;

  MyListingsController(this._homeRepo);

  final isLoading = false.obs;
  final myListings = <Listing>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyListings();
  }

  Future<void> fetchMyListings() async {
    isLoading.value = true;
    try {
      final fetched = await _homeRepo.getMyListings();
      myListings.assignAll(fetched);
    } catch (e) {
      Get.printError(info: 'fetchMyListings error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteListing(String id) async {
    isLoading.value = true;
    try {
      final success = await _homeRepo.deleteListing(id);
      if (success) {
        myListings.removeWhere((l) => l.id == id);
        Get.snackbar(
          'Success',
          'Listing deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        if (Get.isRegistered<MarketplaceController>()) {
          Get.find<MarketplaceController>().fetchListings();
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to delete listing',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.printError(info: 'deleteListing error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
