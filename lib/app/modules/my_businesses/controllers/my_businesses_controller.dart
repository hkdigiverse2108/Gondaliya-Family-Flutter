import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/extensions/safe_json_map_extensions.dart';
import '../../../data/models/business.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../home/controllers/home_controller.dart';

class MyBusinessesController extends GetxController {
  final _authRepo = AuthRepository();

  final isLoading = false.obs;
  final myBusinesses = <Business>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyBusinesses();
  }

  Future<void> fetchMyBusinesses() async {
    isLoading.value = true;
    try {
      final response = await _authRepo.getMyBusinesses();
      if (response.success && response.data != null) {
        final List<Business> list = [];
        for (var item in response.data!) {
          try {
            if (item is Map<String, dynamic> && item.containsKey('business')) {
              final bizJson = item['business'] as Map<String, dynamic>;
              final ownerJson = item['owner'] as Map<String, dynamic>?;
              final ownerId = ownerJson?.getString('userId') ?? '';

              final locs = bizJson['locations'] as List<dynamic>?;
              final String shopAddress;
              final String city;
              if (locs != null && locs.isNotEmpty) {
                final firstLoc = locs.first as Map<String, dynamic>;
                city = firstLoc.getString('areaCity');
                final addrParts = [
                  firstLoc['shopAddress'] ?? '',
                  firstLoc['areaCity'] ?? '',
                  firstLoc['state'] ?? '',
                  firstLoc['pincode'] ?? '',
                ].where((part) => part.toString().trim().isNotEmpty).toList();
                shopAddress = addrParts.join(', ');
              } else {
                shopAddress = '';
                city = '';
              }

              final contactInfo = bizJson['contactInfo'] as Map<String, dynamic>?;
              final String contact = contactInfo?.getOrNull('mobile1') ??
                  ownerJson?.getString('phoneNumber') ?? '';
              final String ownerName = (ownerJson != null)
                  ? "${ownerJson.getString('firstName')} ${ownerJson.getString('lastName')}".trim()
                  : (bizJson.getString('ownerName'));

              final businessLogo = bizJson['businessLogo'] as String?;
              final businessBanner = bizJson['businessBanner'] as String?;
              final businessPhotos = (bizJson['businessPhotos'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList();

              final String businessId = bizJson.getOrNull<String>('_id') ??
                  bizJson.getOrNull<String>('id') ??
                  ownerId;

              list.add(
                Business(
                  id: businessId,
                  name: bizJson.getString('businessName'),
                  category: bizJson.getString('category'),
                  subCategory: bizJson['subCategory'] is List
                      ? (bizJson['subCategory'] as List).map((e) => e.toString()).toList()
                      : (bizJson['subCategory'] != null && bizJson['subCategory'].toString().isNotEmpty)
                          ? [bizJson['subCategory'].toString()]
                          : [],
                  address: shopAddress,
                  city: city,
                  contact: contact,
                  description: bizJson.getString('description'),
                  ownerId: ownerId,
                  createdAt: DateTime.now(), // Fallback
                  ownerName: ownerName,
                  businessLogo: businessLogo,
                  businessBanner: businessBanner,
                  businessPhotos: businessPhotos,
                ),
              );
            }
          } catch (e) {
            Get.printError(info: 'Error parsing business item: $e');
          }
        }
        myBusinesses.assignAll(list);
      } else {
        Get.snackbar(
          'error'.tr,
          response.message ??
              ('failed_to_load_businesses'.tr.isEmpty
                  ? 'Failed to load businesses'
                  : 'failed_to_load_businesses'.tr),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.printError(info: 'fetchMyBusinesses error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteBusiness(String id) async {
    isLoading.value = true;
    try {
      final response = await _authRepo.deleteBusiness(id);
      if (response.success) {
        myBusinesses.removeWhere((b) => b.id == id);
        Get.snackbar(
          'success'.tr,
          'business_deleted'.tr.isEmpty ? 'Business deleted successfully' : 'business_deleted'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().fetchBusinesses();
        }
      } else {
        Get.snackbar(
          'error'.tr,
          response.message ?? 'failed_to_delete_business'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.printError(info: 'deleteBusiness error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
