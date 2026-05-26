import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gondalia_family/app/global_widgets/neomorphic_async_dropdown_field.dart';
import '../../../data/models/user.dart';
import '../../../data/models/location_model.dart';
import '../../../data/models/enums.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/location_repository.dart';
import '../../../data/services/storage_service.dart';
import '../../home/controllers/profile_controller.dart';

class EditProfileController extends GetxController {
  final _authRepo = AuthRepository();
  final _locationRepo = LocationRepository();
  final _storage = Get.find<StorageService>();

  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;

  late UserModel originalUser;

  // Form Field Controllers
  final nameController = TextEditingController();
  final fatherNameController = TextEditingController();
  final surnameController = TextEditingController();
  final dobController = TextEditingController();
  final educationController = TextEditingController();

  final bloodGroup = ''.obs;
  final isMarried = ''.obs;
  final phoneNumber2Controller = TextEditingController();

  final currentAddressController = TextEditingController();
  final currentCityController = TextEditingController();
  final currentStateController = TextEditingController();
  final pincodeController = TextEditingController();
  final houseType = ''.obs;

  final selectedLocation = Rx<LocationModel?>(null);
  final villageController = TextEditingController();
  final talukaController = TextEditingController();
  final districtController = TextEditingController();

  final nativeVillageController = TextEditingController();
  final nativeTalukaController = TextEditingController();
  final nativeDistrictController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  void _loadUserData() {
    // Try to get current user from ProfileController or Storage
    UserModel? user;
    if (Get.isRegistered<ProfileController>()) {
      user = Get.find<ProfileController>().currentUser.value;
    }
    user ??= _storage.currentUser;

    if (user != null) {
      originalUser = user;
      nameController.text = user.firstName;
      fatherNameController.text = user.middleName;
      surnameController.text = user.lastName;
      dobController.text = user.dob;
      educationController.text = user.education;

      bloodGroup.value = user.bloodGroup.isNotEmpty
          ? user.bloodGroup
          : AppEnums.bloodGroups.first;
      isMarried.value = user.isMarried.isNotEmpty
          ? user.isMarried
          : AppEnums.maritalStatus.first;

      phoneNumber2Controller.text = user.phoneNumber2 ?? '';
      currentAddressController.text = user.currentAddress;
      currentCityController.text = user.currentCity ?? '';
      currentStateController.text = user.currentState ?? '';
      pincodeController.text = user.pincode;

      houseType.value = user.houseType.isNotEmpty
          ? user.houseType
          : AppEnums.houseTypes.first;

      villageController.text = user.village;
      talukaController.text = user.taluka;
      districtController.text = user.district;

      nativeVillageController.text = user.nativeVillage ?? '';
      nativeTalukaController.text = user.nativeTaluka ?? '';
      nativeDistrictController.text = user.nativeDistrict ?? '';
    } else {
      Get.back();
      Get.snackbar(
        'Error',
        'User session not found',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  Future<List<NeomorphicAsyncDropdownItem<LocationModel>>> searchLocations(
    String query,
  ) async {
    final locations = await _locationRepo.getLocations(search: query);
    return locations
        .map(
          (loc) => NeomorphicAsyncDropdownItem(
            value: loc,
            label: "${loc.village} (${loc.taluka})",
          ),
        )
        .toList();
  }

  Future<void> saveProfile() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final payload = _buildDiffPayload();

      // If no updates other than userId, just go back
      if (payload.keys.length <= 1) {
        isLoading.value = false;
        Get.back();
        Get.snackbar(
          'Info',
          'No changes made',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final response = await _authRepo.updateUser(payload);
      if (response.success && response.data != null) {
        final updatedUser = response.data!;

        // Update local storage
        await _storage.saveUser(updatedUser);

        // Update active profile controller if registered
        if (Get.isRegistered<ProfileController>()) {
          final profileCtrl = Get.find<ProfileController>();
          profileCtrl.currentUser.value = updatedUser;
          profileCtrl.familyMembers.assignAll(updatedUser.familyMembers);
        }
        Get.back();
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          response.message ?? 'Failed to update profile',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.printError(info: 'saveProfile error: $e');
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic> _buildDiffPayload() {
    final payload = <String, dynamic>{'userId': originalUser.id};

    void addIfChanged(String key, String current, String originalVal) {
      if (current.trim() != originalVal.trim()) {
        payload[key] = current.trim();
      }
    }

    addIfChanged('firstName', nameController.text, originalUser.firstName);
    addIfChanged(
      'middleName',
      fatherNameController.text,
      originalUser.middleName,
    );
    addIfChanged('lastName', surnameController.text, originalUser.lastName);
    addIfChanged('dob', dobController.text, originalUser.dob);
    addIfChanged('education', educationController.text, originalUser.education);

    if (bloodGroup.value != originalUser.bloodGroup) {
      payload['bloodGroup'] = bloodGroup.value;
    }
    if (isMarried.value != originalUser.isMarried) {
      payload['isMarried'] = isMarried.value;
    }

    final originalPhone2 = originalUser.phoneNumber2 ?? '';
    addIfChanged('phoneNumber2', phoneNumber2Controller.text, originalPhone2);

    addIfChanged(
      'currentAddress',
      currentAddressController.text,
      originalUser.currentAddress,
    );
    addIfChanged(
      'currentCity',
      currentCityController.text,
      originalUser.currentCity ?? '',
    );
    addIfChanged(
      'currentState',
      currentStateController.text,
      originalUser.currentState ?? '',
    );
    addIfChanged('pincode', pincodeController.text, originalUser.pincode);

    if (houseType.value != originalUser.houseType) {
      payload['houseType'] = houseType.value;
    }

    addIfChanged('village', villageController.text, originalUser.village);
    addIfChanged('taluka', talukaController.text, originalUser.taluka);
    addIfChanged('district', districtController.text, originalUser.district);

    addIfChanged(
      'nativeVillage',
      nativeVillageController.text,
      originalUser.nativeVillage ?? '',
    );
    addIfChanged(
      'nativeTaluka',
      nativeTalukaController.text,
      originalUser.nativeTaluka ?? '',
    );
    addIfChanged(
      'nativeDistrict',
      nativeDistrictController.text,
      originalUser.nativeDistrict ?? '',
    );

    return payload;
  }

  @override
  void onClose() {
    nameController.dispose();
    fatherNameController.dispose();
    surnameController.dispose();
    dobController.dispose();
    educationController.dispose();
    phoneNumber2Controller.dispose();
    currentAddressController.dispose();
    currentCityController.dispose();
    currentStateController.dispose();
    pincodeController.dispose();
    villageController.dispose();
    talukaController.dispose();
    districtController.dispose();
    nativeVillageController.dispose();
    nativeTalukaController.dispose();
    nativeDistrictController.dispose();
    super.onClose();
  }
}
