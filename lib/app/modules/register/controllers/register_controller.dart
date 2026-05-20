import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/family_member.dart';
import '../../../data/models/user.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final _uuid = const Uuid();

  // Stepper State
  final currentStep = 0.obs;

  // Step 1: Account & Contacts
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final mobile1Controller = TextEditingController();
  final mobile2Controller = TextEditingController();

  // Step 2: Personal & Native Info
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final fatherNameController = TextEditingController();
  final currentAddressController = TextEditingController();
  final houseType = 'Owned'.obs; // 'Owned' or 'Rented'
  final villageController = TextEditingController();
  final pincodeController = TextEditingController();
  final talukaController = TextEditingController();
  final districtController = TextEditingController();

  // Step 3: Occupation Info
  final occupationType = 'None'.obs; // 'Business', 'Job', 'None'
  final occupationFormKey = GlobalKey<FormState>();

  // Business fields
  final businessNameController = TextEditingController();
  final businessCategoryController = TextEditingController();
  final businessAddressController = TextEditingController();

  // Job fields
  final companyNameController = TextEditingController();
  final jobRoleController = TextEditingController();
  final companyAddressController = TextEditingController();

  // Step 4: Family Members List (Draft)
  final familyMembers = <FamilyMember>[].obs;

  // Form Keys for validation per step
  final accountFormKey = GlobalKey<FormState>();
  final profileFormKey = GlobalKey<FormState>();

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Default mobile 1 to phone number input automatically
    phoneController.addListener(() {
      mobile1Controller.text = phoneController.text;
    });
  }

  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    mobile1Controller.dispose();
    mobile2Controller.dispose();
    nameController.dispose();
    surnameController.dispose();
    fatherNameController.dispose();
    currentAddressController.dispose();
    villageController.dispose();
    pincodeController.dispose();
    talukaController.dispose();
    districtController.dispose();
    businessNameController.dispose();
    businessCategoryController.dispose();
    businessAddressController.dispose();
    companyNameController.dispose();
    jobRoleController.dispose();
    companyAddressController.dispose();
    super.onClose();
  }

  // --- Stepper Navigation ---

  void nextStep() {
    if (currentStep.value == 0) {
      if (accountFormKey.currentState!.validate()) {
        currentStep.value++;
      }
    } else if (currentStep.value == 1) {
      if (profileFormKey.currentState!.validate()) {
        currentStep.value++;
      }
    } else if (currentStep.value == 2) {
      if (occupationType.value == 'None' ||
          (occupationFormKey.currentState?.validate() ?? true)) {
        currentStep.value++;
      }
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  // --- Family Member Management (Draft list) ---

  void addFamilyMemberDraft({
    required String name,
    required String fatherName,
    required String surname,
    required int age,
    required String relationship,
    required String phoneNumber,
    required String occupation,
    required String birthDate,
    required String education,
    required bool isMarried,
    required String bloodGroup,
    required String skill,
  }) {
    final newMember = FamilyMember(
      id: _uuid.v4(),
      name: name,
      fatherName: fatherName,
      surname: surname,
      age: age,
      relationship: relationship,
      phoneNumber: phoneNumber,
      occupation: occupation,
      birthDate: birthDate,
      education: education,
      isMarried: isMarried,
      bloodGroup: bloodGroup,
      skill: skill,
      createdAt: DateTime.now(),
    );
    familyMembers.add(newMember);
  }

  void removeFamilyMemberDraft(String id) {
    familyMembers.removeWhere((element) => element.id == id);
  }

  // --- Submit Registration ---

  Future<void> submitRegistration() async {
    isLoading.value = true;

    // Simulate slight network delay
    await Future.delayed(const Duration(milliseconds: 800));

    final newUser = UserModel(
      id: _uuid.v4(),
      phoneNumber: phoneController.text.trim(),
      password: passwordController.text.trim(),
      name: nameController.text.trim(),
      surname: surnameController.text.trim(),
      fatherName: fatherNameController.text.trim(),
      village: villageController.text.trim(),
      pincode: pincodeController.text.trim(),
      taluka: talukaController.text.trim(),
      district: districtController.text.trim(),
      currentAddress: currentAddressController.text.trim(),
      houseType: houseType.value,
      mobile1: mobile1Controller.text.trim(),
      mobile2: mobile2Controller.text.trim(),
      occupationType: occupationType.value,
      businessName: occupationType.value == 'Business' ? businessNameController.text.trim() : null,
      businessCategory: occupationType.value == 'Business' ? businessCategoryController.text.trim() : null,
      businessAddress: occupationType.value == 'Business' ? businessAddressController.text.trim() : null,
      companyName: occupationType.value == 'Job' ? companyNameController.text.trim() : null,
      jobRole: occupationType.value == 'Job' ? jobRoleController.text.trim() : null,
      companyAddress: occupationType.value == 'Job' ? companyAddressController.text.trim() : null,
      familyMembers: List<FamilyMember>.from(familyMembers),
      createdAt: DateTime.now(),
    );

    final success = await _authService.register(newUser);
    isLoading.value = false;

    if (success) {
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
        'account_exists'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }
}
