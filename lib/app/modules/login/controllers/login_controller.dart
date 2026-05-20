import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;

  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();

    if (phone.isEmpty || password.isEmpty) {
      Get.snackbar(
        'field_required'.tr,
        'login_failed'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    
    // Simulate slight network delay for better UX feel
    await Future.delayed(const Duration(milliseconds: 600));

    final success = await _authService.login(phone, password);
    isLoading.value = false;

    if (success) {
      Get.offAllNamed(Routes.HOME);
    } else {
      Get.snackbar(
        'Error',
        'login_failed'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  void toggleLanguage() {
    final currentLocale = Get.locale;
    if (currentLocale?.languageCode == 'gu') {
      Get.updateLocale(const Locale('en', 'US'));
    } else {
      Get.updateLocale(const Locale('gu', 'IN'));
    }
  }
}
