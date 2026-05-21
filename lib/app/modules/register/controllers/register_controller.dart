import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gondalia_family/app/global_widgets/neomorphic_async_dropdown_field.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/family_member.dart';
import '../../../data/models/location_model.dart';
import '../../../data/models/enums.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/location_repository.dart';
import '../../../data/services/storage_service.dart';
import '../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  final _authRepo = AuthRepository();
  final _locationRepo = LocationRepository();
  final _storage = Get.find<StorageService>();
  final _uuid = const Uuid();

  final selectedLocation = Rx<LocationModel?>(null);

  Future<List<NeomorphicAsyncDropdownItem<LocationModel>>> searchLocations(
    String query,
  ) async {
    final locations = await _locationRepo.getLocations(search: query);
    return locations
        .map(
          (loc) => NeomorphicAsyncDropdownItem(value: loc, label: loc.village),
        )
        .toList();
  }

  // Stepper
  final currentStep = 0.obs;

  // Step 1 — Account
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final mobile1Controller = TextEditingController();
  final mobile2Controller = TextEditingController();

  // Step 2 — Profile
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final fatherNameController = TextEditingController();
  final currentAddressController = TextEditingController();

  final houseType = AppEnums.houseTypes.first.obs;

  final villageController = TextEditingController();
  final pincodeController = TextEditingController();
  final talukaController = TextEditingController();
  final districtController = TextEditingController();

  final dobController = TextEditingController();
  final educationController = TextEditingController();
  final bloodGroup = AppEnums.bloodGroups.first.obs;
  final isMarried = AppEnums.maritalStatus.first.obs;

  final nativeVillageController = TextEditingController();
  final nativeTalukaController = TextEditingController();
  final nativeDistrictController = TextEditingController();

  final currentCityController = TextEditingController();
  final currentStateController = TextEditingController();

  // Step 3 — Occupation
  final occupationType = 'None'.obs;
  final occupationFormKey = GlobalKey<FormState>();

  // Job Details
  final companyNameController = TextEditingController();
  final companyAddressController = TextEditingController();
  final jobCategory = ''.obs;
  final jobRole = ''.obs;

  // Business Details
  final businessNameController = TextEditingController();
  final businessCategoryController = TextEditingController();
  final businessSubCategoryController = TextEditingController();
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

  // Step 4 — Family draft (typed list so widgets can read .name, .age, etc.)
  final familyMembers = <FamilyMember>[].obs;

  final accountFormKey = GlobalKey<FormState>();
  final profileFormKey = GlobalKey<FormState>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    phoneController.addListener(() {
      mobile1Controller.text = phoneController.text;
    });
  }

  @override
  void onClose() {
    for (final c in [
      phoneController,
      passwordController,
      confirmPasswordController,
      mobile1Controller,
      mobile2Controller,
      nameController,
      surnameController,
      fatherNameController,
      currentAddressController,
      villageController,
      pincodeController,
      talukaController,
      districtController,
      dobController,
      educationController,
      nativeVillageController,
      nativeTalukaController,
      nativeDistrictController,
      currentCityController,
      currentStateController,
      businessNameController,
      businessCategoryController,
      businessSubCategoryController,
      businessOwnerNameController,
      businessDescriptionController,
      businessAddressController,
      businessCityController,
      businessStateController,
      businessPincodeController,
      businessGoogleMapLinkController,
      businessMobile1Controller,
      businessMobile2Controller,
      businessEmailController,
      businessWebsiteController,
      businessPortfolioLinkController,
      companyNameController,
      companyAddressController,
    ]) {
      c.dispose();
    }
    super.onClose();
  }

  // --- Stepper ---
  void nextStep() {
    if (currentStep.value == 0) {
      if (accountFormKey.currentState!.validate()) currentStep.value++;
    } else if (currentStep.value == 1) {
      if (profileFormKey.currentState!.validate()) currentStep.value++;
    } else if (currentStep.value == 2) {
      if (occupationType.value == 'None' ||
          (occupationFormKey.currentState?.validate() ?? true)) {
        currentStep.value++;
      }
    }
  }

  void previousStep() {
    if (currentStep.value > 0) currentStep.value--;
  }

  // --- Family draft ---
  /// Adds a family member with named parameters matching the sheet widget.
  void addFamilyMemberDraft({
    required String firstName,
    required String middleName,
    required String lastName,
    required String relation,
    required String dob,
    required String education,
    required String occupation,
    required String isMarried,
    required String bloodGroup,
    required String skills,
    required String phoneNumber,
  }) {
    familyMembers.add(
      FamilyMember(
        id: _uuid.v4(),
        firstName: firstName,
        middleName: middleName,
        lastName: lastName,
        relation: relation,
        dob: dob,
        education: education,
        occupation: occupation,
        isMarried: isMarried,
        bloodGroup: bloodGroup,
        skills: skills,
        phoneNumber: phoneNumber,
        createdAt: DateTime.now(),
      ),
    );
  }

  /// Removes by id — matches the delete button in family_step.dart.
  void removeFamilyMemberDraft(String id) =>
      familyMembers.removeWhere((m) => m.id == id);

  // --- Submit ---
  Future<void> submitRegistration() async {
    isLoading.value = true;

    final payload = <String, dynamic>{
      'firstName': nameController.text.trim(),
      'middleName': fatherNameController.text.trim(),
      'lastName': surnameController.text.trim(),
      'dob': dobController.text.trim(),
      'bloodGroup': bloodGroup.value,
      'education': educationController.text.trim(),
      'isMarried': isMarried.value,
      'profilePhoto': 'null',
      'phoneNumber': phoneController.text.trim(),
      'password': passwordController.text.trim(),
      'isActive': true,
      'nativeVillage': nativeVillageController.text.trim(),
      'nativeTaluka': nativeTalukaController.text.trim(),
      'nativeDistrict': nativeDistrictController.text.trim(),
      'village': villageController.text.trim(),
      'pincode': pincodeController.text.trim(),
      'taluka': talukaController.text.trim(),
      'district': districtController.text.trim(),
      'currentAddress': currentAddressController.text.trim(),
      'currentCity': currentCityController.text.trim(),
      'currentState': currentStateController.text.trim(),
      'houseType': houseType.value,
      'familyMembers': familyMembers.map((m) => m.toJson()).toList(),
      'workDetails': {
        'hasOwnBusiness': occupationType.value == 'Business',
        if (occupationType.value == 'Business')
          'businessDetails': {
            'category': businessCategoryController.text.trim(),
            'subCategory': businessSubCategoryController.text.trim(),
            'businessName': businessNameController.text.trim(),
            'ownerName': businessOwnerNameController.text.trim(),
            'description': businessDescriptionController.text.trim(),
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
          },
        if (occupationType.value == 'Job')
          'jobDetails': {
            'jobCategory': jobCategory.value,
            'jobRole': jobRole.value,
            'companyName': companyNameController.text.trim(),
            'jobLocation': companyAddressController.text.trim(),
          },
      },
    };

    if (mobile2Controller.text.trim().isNotEmpty) {
      payload['phoneNumber2'] = mobile2Controller.text.trim();
    }

    final response = await _authRepo.register(payload: payload);
    isLoading.value = false;

    if (response.success) {
      if (response.data?.token != null) {
        await _storage.saveAuthToken(response.data!.token!);
      }
      Get.snackbar(
        'Success',
        'registration_success'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.offAllNamed(Routes.home);
    } else {
      Get.snackbar(
        'Error',
        response.message ?? 'account_exists'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }
}
