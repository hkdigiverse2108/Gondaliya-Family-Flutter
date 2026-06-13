import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/user.dart';
import '../../../data/models/enums.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/services/storage_service.dart';
import '../../home/controllers/profile_controller.dart';

class EditWorkController extends GetxController {
  final _authRepo = AuthRepository();
  final _storage = Get.find<StorageService>();

  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;

  late UserModel originalUser;

  // Job Details Controllers
  final companyNameController = TextEditingController();
  final companyAddressController = TextEditingController(); // acts as jobLocation
  final jobCategory = ''.obs;
  final jobRole = ''.obs;
  final jobRoleOtherController = TextEditingController();

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

      if (wd != null && wd.jobDetails != null) {
        final job = wd.jobDetails!;
        companyNameController.text = job.companyName;
        companyAddressController.text = job.jobLocation;
        jobCategory.value = job.jobCategory;

        final standardRoles = job.jobCategory.isEmpty
            ? <String>[]
            : AppEnums.jobCategories[job.jobCategory] ?? <String>[];
        if (standardRoles.contains(job.jobRole)) {
          jobRole.value = job.jobRole;
        } else {
          jobRole.value = 'Other Jobs';
          jobRoleOtherController.text = job.jobRole;
        }
      }
    }
  }

  Future<void> saveWorkDetails() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      final String category = jobCategory.value;
      final String role = jobRole.value == 'Other Jobs'
          ? jobRoleOtherController.text.trim()
          : jobRole.value;
      final String company = companyNameController.text.trim();
      final String location = companyAddressController.text.trim();

      final jobPayload = category.isEmpty && role.isEmpty && company.isEmpty && location.isEmpty
          ? null
          : {
              'jobCategory': category,
              'jobRole': role,
              'companyName': company,
              'jobLocation': location,
            };

      // Retain existing businessDetails for this user if any (though backend now decouples, we send jobDetails)
      final payload = {
        'userId': originalUser.id,
        'workDetails': {
          'jobDetails': jobPayload,
        },
      };

      final response = await _authRepo.updateUser(payload);
      if (response.success && response.data != null) {
        final updatedUser = response.data!;
        await _storage.saveUser(updatedUser);

        if (Get.isRegistered<ProfileController>()) {
          final profileCtrl = Get.find<ProfileController>();
          profileCtrl.currentUser.value = updatedUser;
        }

        Get.back();
        Get.snackbar(
          'success'.tr,
          'job_details_updated'.tr.isEmpty ? 'Job details updated successfully' : 'job_details_updated'.tr,
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

  Future<void> clearJobDetails() async {
    isLoading.value = true;
    try {
      final payload = {
        'userId': originalUser.id,
        'workDetails': {
          'jobDetails': null,
        },
      };

      final response = await _authRepo.updateUser(payload);
      if (response.success && response.data != null) {
        final updatedUser = response.data!;
        await _storage.saveUser(updatedUser);

        if (Get.isRegistered<ProfileController>()) {
          final profileCtrl = Get.find<ProfileController>();
          profileCtrl.currentUser.value = updatedUser;
        }

        companyNameController.clear();
        companyAddressController.clear();
        jobCategory.value = '';
        jobRole.value = '';
        jobRoleOtherController.clear();

        Get.back();
        Get.snackbar(
          'success'.tr,
          'job_details_cleared'.tr.isEmpty ? 'Job details cleared successfully' : 'job_details_cleared'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'error'.tr,
          response.message ?? 'failed_to_clear_job'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.printError(info: 'clearJobDetails error: $e');
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
    super.onClose();
  }
}
