import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../../../data/models/user.dart';
import '../../../data/models/enums.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/services/storage_service.dart';
import '../../home/controllers/profile_controller.dart';
import '../../home/controllers/home_controller.dart';

class EditWorkController extends GetxController {
  final _authRepo = AuthRepository();
  final _storage = Get.find<StorageService>();

  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;

  late UserModel originalUser;

  // Selection tab
  final occupationType = 'None'.obs; // 'Business', 'Job', 'None'

  // Business Logo variables
  final pickedBusinessLogoPath = ''.obs;
  final existingBusinessLogo = ''.obs;

  // Business Banner variables
  final pickedBusinessBannerPath = ''.obs;
  final existingBusinessBanner = ''.obs;

  // Business Photos variables
  final businessPhotosSlots = RxList<PhotoSlot>([
    PhotoSlot(),
    PhotoSlot(),
    PhotoSlot(),
    PhotoSlot(),
  ]);

  // Job Details Controllers
  final companyNameController = TextEditingController();
  final companyAddressController = TextEditingController();
  final jobCategory = ''.obs;
  final jobRole = ''.obs;
  final jobRoleOtherController = TextEditingController();

  // Business Details Controllers
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
    _loadWorkData();
  }

  void _loadWorkData() {
    UserModel? user;
    if (Get.isRegistered<ProfileController>()) {
      user = Get.find<ProfileController>().currentUser.value;
    }
    user ??= _storage.currentUser;

    if (user != null) {
      originalUser = user;
      final wd = user.workDetails;

      if (wd != null) {
        if (wd.hasOwnBusiness && wd.businessDetails != null) {
          occupationType.value = 'Business';
          final biz = wd.businessDetails!;
          businessNameController.text = biz.businessName;
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
              // It is a custom subcategory!
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
              businessPhotosSlots[i] = PhotoSlot(existingUrl: photos[i]);
            } else {
              businessPhotosSlots[i] = PhotoSlot();
            }
          }

          if (biz.locations.isNotEmpty) {
            final loc = biz.locations.first;
            businessAddressController.text = loc.shopAddress;
            businessCityController.text = loc.areaCity;
            businessStateController.text = loc.state;
            businessPincodeController.text = loc.pincode;
            businessGoogleMapLinkController.text = loc.googleMapLink;
          }

          if (biz.contactInfo != null) {
            final info = biz.contactInfo!;
            businessMobile1Controller.text = info.mobile1;
            businessMobile2Controller.text = info.mobile2;
            businessEmailController.text = info.email;
            businessWebsiteController.text = info.website;
            businessPortfolioLinkController.text = info.portfolioLink;
          }
        } else if (!wd.hasOwnBusiness && wd.jobDetails != null) {
          occupationType.value = 'Job';
          final job = wd.jobDetails!;
          companyNameController.text = job.companyName;
          companyAddressController.text = job.jobLocation;
          jobCategory.value = job.jobCategory;
          jobRole.value = job.jobRole;
        } else {
          occupationType.value = 'None';
        }
      } else {
        occupationType.value = 'None';
      }
    }
  }

  /// Pick a business logo using FilePicker
  Future<void> pickBusinessLogo() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'webp', 'gif', 'pdf'],
      );
      if (result != null && result.files.single.path != null) {
        pickedBusinessLogoPath.value = result.files.single.path!;
      }
    } catch (e) {
      Get.printError(info: 'pickBusinessLogo error: $e');
      Get.snackbar(
        'error'.tr,
        'failed_to_pick_logo'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
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
      Get.snackbar(
        'error'.tr,
        'failed_to_pick_banner'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  Future<void> pickBusinessPhoto(int index) async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'webp', 'gif'],
      );
      if (result != null && result.files.single.path != null) {
        businessPhotosSlots[index] = PhotoSlot(
          pickedPath: result.files.single.path!,
        );
      }
    } catch (e) {
      Get.printError(info: 'pickBusinessPhoto error: $e');
      Get.snackbar(
        'error'.tr,
        'failed_to_pick_photo'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  void removeBusinessPhoto(int index) {
    businessPhotosSlots[index] = PhotoSlot();
  }

  Future<void> saveWorkDetails() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      // 1. Upload business logo first if a new one was picked
      String? uploadedLogoUrl;
      if (pickedBusinessLogoPath.value.isNotEmpty) {
        final uploadResp = await _authRepo.uploadFile(
          filePath: pickedBusinessLogoPath.value,
          oldFileUrl: originalUser.workDetails?.businessDetails?.businessLogo,
        );
        if (uploadResp.success && uploadResp.data != null) {
          uploadedLogoUrl = uploadResp.data!['url'] as String?;
        } else {
          Get.snackbar(
            'error'.tr,
            uploadResp.message ?? 'failed_to_upload_logo'.tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
          isLoading.value = false;
          return;
        }
      }

      // 1b. Upload business banner if a new one was picked
      String? uploadedBannerUrl;
      if (pickedBusinessBannerPath.value.isNotEmpty) {
        final uploadResp = await _authRepo.uploadFile(
          filePath: pickedBusinessBannerPath.value,
          oldFileUrl: originalUser.workDetails?.businessDetails?.businessBanner,
        );
        if (uploadResp.success && uploadResp.data != null) {
          uploadedBannerUrl = uploadResp.data!['url'] as String?;
        } else {
          Get.snackbar(
            'error'.tr,
            uploadResp.message ?? 'failed_to_upload_banner'.tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
          isLoading.value = false;
          return;
        }
      }

      // 1c. Upload details gallery photos if new ones were picked
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
            Get.snackbar(
              'error'.tr,
              uploadResp.message ?? 'failed_to_upload_photo'.tr,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
            );
            isLoading.value = false;
            return;
          }
        } else if (slot.existingUrl != null && slot.existingUrl!.isNotEmpty) {
          finalPhotosUrls.add(slot.existingUrl!);
        }
      }

      final workDetailsPayload = <String, dynamic>{
        'hasOwnBusiness': occupationType.value == 'Business',
      };

      if (occupationType.value == 'Business') {
        workDetailsPayload['businessDetails'] = {
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
          'businessLogo':
              uploadedLogoUrl ??
              originalUser.workDetails?.businessDetails?.businessLogo,
          'businessBanner':
              uploadedBannerUrl ??
              originalUser.workDetails?.businessDetails?.businessBanner,
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
      } else if (occupationType.value == 'Job') {
        workDetailsPayload['jobDetails'] = {
          'jobCategory': jobCategory.value,
          'jobRole': jobRole.value == 'Other Jobs'
              ? jobRoleOtherController.text.trim()
              : jobRole.value,
          'companyName': companyNameController.text.trim(),
          'jobLocation': companyAddressController.text.trim(),
        };
      } else {
        // None: backend might expect null or empty workDetails object
      }

      final payload = {
        'userId': originalUser.id,
        'workDetails': occupationType.value == 'None'
            ? null
            : workDetailsPayload,
      };

      final response = await _authRepo.updateUser(payload);
      if (response.success && response.data != null) {
        final updatedUser = response.data!;
        await _storage.saveUser(updatedUser);

        if (Get.isRegistered<ProfileController>()) {
          final profileCtrl = Get.find<ProfileController>();
          profileCtrl.currentUser.value = updatedUser;
        }

        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>()
              .fetchBusinesses(); // Refresh global list of businesses
        }

        Get.back();
        Get.snackbar(
          'success'.tr,
          'work_details_updated'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'error'.tr,
          response.message ?? 'failed_to_update_work'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.printError(info: 'saveWorkDetails error: $e');
      Get.snackbar(
        'error'.tr,
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    companyNameController.dispose();
    companyAddressController.dispose();
    jobRoleOtherController.dispose();
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

class PhotoSlot {
  final String? existingUrl;
  final String? pickedPath;

  PhotoSlot({this.existingUrl, this.pickedPath});

  bool get isEmpty =>
      (existingUrl == null || existingUrl!.isEmpty) &&
      (pickedPath == null || pickedPath!.isEmpty);
  bool get hasImage => !isEmpty;
}
