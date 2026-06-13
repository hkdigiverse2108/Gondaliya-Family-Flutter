import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/network/api_response.dart';
import '../../../data/models/business.dart';
import '../../../data/models/enums.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../home/controllers/home_controller.dart';
import 'my_businesses_controller.dart';

class EditBusinessController extends GetxController {
  final _authRepo = AuthRepository();

  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;

  Business? originalBusiness; // Null if adding a new business
  bool get isEditMode => originalBusiness != null;

  // Business Logo variables
  final pickedBusinessLogoPath = ''.obs;
  final existingBusinessLogo = ''.obs;

  // Business Banner variables
  final pickedBusinessBannerPath = ''.obs;
  final existingBusinessBanner = ''.obs;

  // Business Photos variables
  final businessPhotosSlots = RxList<BusinessPhotoSlot>([
    BusinessPhotoSlot(),
    BusinessPhotoSlot(),
    BusinessPhotoSlot(),
    BusinessPhotoSlot(),
  ]);

  // Form Controllers
  final businessNameController = TextEditingController();
  final businessCategory = ''.obs;
  final businessSubCategories = <String>[].obs;
  final businessSubCategoryOtherController = TextEditingController();
  final businessOwnerNameController = TextEditingController();
  final businessDescriptionController = TextEditingController();
  final businessAddressController = TextEditingController();
  final businessCityController = TextEditingController();
  final businessStateController = TextEditingController();
  final businessPincodeController = TextEditingController();
  final businessGoogleMapLinkController = TextEditingController();
  final businessMobile1Controller = TextEditingController();
  final businessMobile2Controller = TextEditingController();
  final businessEmailController = TextEditingController();
  final businessWebsiteController = TextEditingController();
  final businessPortfolioLinkController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map && args.containsKey('business')) {
      originalBusiness = args['business'] as Business;
      _populateFields(originalBusiness!);
    }
  }

  void _populateFields(Business biz) {
    businessNameController.text = biz.name;
    businessCategory.value = biz.category;

    // Populating subcategories safely
    businessSubCategories.clear();
    final standardSubs = biz.category.isEmpty
        ? <String>[]
        : AppEnums.jobCategories[biz.category] ?? <String>[];

    for (final sub in biz.subCategory) {
      if (standardSubs.contains(sub)) {
        businessSubCategories.add(sub);
      } else {
        if (!businessSubCategories.contains('Other Jobs')) {
          businessSubCategories.add('Other Jobs');
        }
        businessSubCategoryOtherController.text = sub;
      }
    }

    businessOwnerNameController.text = biz.ownerName;
    businessDescriptionController.text = biz.description;
    existingBusinessLogo.value = biz.businessLogo ?? '';
    existingBusinessBanner.value = biz.businessBanner ?? '';

    final photos = biz.businessPhotos ?? [];
    for (int i = 0; i < 4; i++) {
      if (i < photos.length) {
        businessPhotosSlots[i] = BusinessPhotoSlot(existingUrl: photos[i]);
      } else {
        businessPhotosSlots[i] = BusinessPhotoSlot();
      }
    }

    // Since address is constructed on client-side, we parse it if needed.
    // If you need structured locations, you can reconstruct or use existing.
    businessAddressController.text = biz.address;
    businessCityController.text = biz.city;
    businessMobile1Controller.text = biz.contact;
  }

  Future<void> pickBusinessLogo() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'webp', 'gif'],
      );
      if (result != null && result.files.single.path != null) {
        pickedBusinessLogoPath.value = result.files.single.path!;
      }
    } catch (e) {
      Get.printError(info: 'pickBusinessLogo error: $e');
    }
  }

  Future<void> pickBusinessBanner() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'webp', 'gif'],
      );
      if (result != null && result.files.single.path != null) {
        pickedBusinessBannerPath.value = result.files.single.path!;
      }
    } catch (e) {
      Get.printError(info: 'pickBusinessBanner error: $e');
    }
  }

  Future<void> pickBusinessPhoto(int index) async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'webp', 'gif'],
      );
      if (result != null && result.files.single.path != null) {
        businessPhotosSlots[index] = BusinessPhotoSlot(
          pickedPath: result.files.single.path!,
        );
      }
    } catch (e) {
      Get.printError(info: 'pickBusinessPhoto error: $e');
    }
  }

  void removeBusinessPhoto(int index) {
    businessPhotosSlots[index] = BusinessPhotoSlot();
  }

  Future<void> saveBusiness() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      // 1. Upload business logo first if a new one was picked
      String? uploadedLogoUrl;
      if (pickedBusinessLogoPath.value.isNotEmpty) {
        final uploadResp = await _authRepo.uploadFile(
          filePath: pickedBusinessLogoPath.value,
          oldFileUrl: existingBusinessLogo.value,
        );
        if (uploadResp.success && uploadResp.data != null) {
          uploadedLogoUrl = uploadResp.data!['url'] as String?;
        } else {
          Get.snackbar('Error', 'Logo upload failed');
          isLoading.value = false;
          return;
        }
      }

      // 2. Upload business banner if a new one was picked
      String? uploadedBannerUrl;
      if (pickedBusinessBannerPath.value.isNotEmpty) {
        final uploadResp = await _authRepo.uploadFile(
          filePath: pickedBusinessBannerPath.value,
          oldFileUrl: existingBusinessBanner.value,
        );
        if (uploadResp.success && uploadResp.data != null) {
          uploadedBannerUrl = uploadResp.data!['url'] as String?;
        } else {
          Get.snackbar('Error', 'Banner upload failed');
          isLoading.value = false;
          return;
        }
      }

      // 3. Upload gallery photos
      final List<String> finalPhotosUrls = [];
      for (final slot in businessPhotosSlots) {
        if (slot.pickedPath != null && slot.pickedPath!.isNotEmpty) {
          final uploadResp = await _authRepo.uploadFile(
            filePath: slot.pickedPath!,
          );
          if (uploadResp.success && uploadResp.data != null) {
            final url = uploadResp.data!['url'] as String;
            finalPhotosUrls.add(url);
          } else {
            Get.snackbar('Error', 'Gallery photo upload failed');
            isLoading.value = false;
            return;
          }
        } else if (slot.existingUrl != null && slot.existingUrl!.isNotEmpty) {
          finalPhotosUrls.add(slot.existingUrl!);
        }
      }

      final payload = {
        'category': businessCategory.value,
        'subCategory': businessSubCategories.map((sub) {
          if (sub == 'Other Jobs') {
            return businessSubCategoryOtherController.text.trim();
          }
          return sub;
        }).toList(),
        'businessName': businessNameController.text.trim(),
        'ownerName': businessOwnerNameController.text.trim(),
        'description': businessDescriptionController.text.trim(),
        'businessLogo': uploadedLogoUrl ?? existingBusinessLogo.value,
        'businessBanner': uploadedBannerUrl ?? existingBusinessBanner.value,
        'businessPhotos': finalPhotosUrls,
        'locations': [
          {
            'shopAddress': businessAddressController.text.trim(),
            'areaCity': businessCityController.text.trim(),
            'state': businessStateController.text.trim(),
            'pincode': businessPincodeController.text.trim(),
            'googleMapLink': businessGoogleMapLinkController.text.trim(),
          },
        ],
        'contactInfo': {
          'mobile1': businessMobile1Controller.text.trim(),
          'mobile2': businessMobile2Controller.text.trim(),
          'email': businessEmailController.text.trim(),
          'website': businessWebsiteController.text.trim(),
          'portfolioLink': businessPortfolioLinkController.text.trim(),
        },
      };

      final ApiResponse<dynamic> response;
      if (isEditMode) {
        response = await _authRepo.updateBusiness(
          originalBusiness!.id,
          payload,
        );
      } else {
        response = await _authRepo.createBusiness(payload);
      }

      if (response.success) {
        if (Get.isRegistered<MyBusinessesController>()) {
          Get.find<MyBusinessesController>().fetchMyBusinesses();
        }
        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().fetchBusinesses();
        }
        Get.back();
        Get.snackbar(
          'Success',
          isEditMode
              ? 'Business updated successfully'
              : 'Business created successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar('Error', response.message ?? 'Save failed');
      }
    } catch (e) {
      Get.printError(info: 'saveBusiness error: $e');
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    businessNameController.dispose();
    businessSubCategoryOtherController.dispose();
    businessOwnerNameController.dispose();
    businessDescriptionController.dispose();
    businessAddressController.dispose();
    businessCityController.dispose();
    businessStateController.dispose();
    businessPincodeController.dispose();
    businessGoogleMapLinkController.dispose();
    businessMobile1Controller.dispose();
    businessMobile2Controller.dispose();
    businessEmailController.dispose();
    businessWebsiteController.dispose();
    businessPortfolioLinkController.dispose();
    super.onClose();
  }
}

class BusinessPhotoSlot {
  final String? existingUrl;
  final String? pickedPath;

  BusinessPhotoSlot({this.existingUrl, this.pickedPath});

  bool get isEmpty =>
      (existingUrl == null || existingUrl!.isEmpty) &&
      (pickedPath == null || pickedPath!.isEmpty);
  bool get hasImage => !isEmpty;
}
