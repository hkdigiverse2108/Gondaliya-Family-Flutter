import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/services/firebase_notification_service.dart';
import '../../../data/services/socket_service.dart';
import '../../../data/services/storage_service.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final _authRepo = AuthRepository();
  final _storage = Get.find<StorageService>();
  final isDarkTheme = false.obs;

  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;

  @override
  void onClose() {
    // Controllers are cleaned up by GC after route transition completes.
    // Manual dispose here causes "used after being disposed" during animations.
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
    String? fcmToken;
    if (Get.isRegistered<FirebaseNotificationService>() &&
        FirebaseNotificationService.to.isInitialized) {
      try {
        fcmToken = await FirebaseMessaging.instance.getToken();
      } catch (e) {
        debugPrint('Error getting FCM Token during login: $e');
      }
    }

    final response = await _authRepo.login(
      phoneNumber: phone,
      password: password,
      deviceToken: fcmToken,
    );
    isLoading.value = false;

    if (response.success) {
      // Save the token returned by the API
      if (response.data?.token != null) {
        await _storage.saveAuthToken(response.data!.token!);
      }

      if (response.data?.id != null && response.data!.id.isNotEmpty) {
        // Fetch actual user data
        isLoading.value = true;
        final userResponse = await _authRepo.getUserById(response.data!.id);
        isLoading.value = false;

        if (userResponse.success && userResponse.data != null) {
          await _storage.saveUser(userResponse.data!);
        } else {
          Get.snackbar(
            'Error',
            userResponse.message ?? 'Failed to fetch user details',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
          return;
        }
      }

      Get.find<SocketService>().connect();
      if (Get.isRegistered<FirebaseNotificationService>()) {
        FirebaseNotificationService.to.uploadFcmToken();
      }
      Get.offAllNamed(Routes.home);
    } else {
      Get.snackbar(
        'Error',
        response.message ?? 'login_failed'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  void toggleTheme() {
    isDarkTheme.toggle();
    Get.changeThemeMode(isDarkTheme.value ? ThemeMode.dark : ThemeMode.light);
    _storage.saveThemeMode(isDarkTheme.value);
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
