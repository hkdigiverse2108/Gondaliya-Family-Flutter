import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/user.dart';
import '../../../data/services/socket_service.dart';
import '../../../data/services/storage_service.dart';
import '../../../routes/app_pages.dart';

class PlaceholderHomeController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();

  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final isDarkTheme = false.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkTheme.value = _storage.isDarkMode;
    _loadUserData();
  }

  void _loadUserData() {
    user.value = _storage.currentUser;
  }

  void logout() {
    Get.find<SocketService>().disconnect();
    _storage.clearAuthToken();
    _storage.clearUser();
    Get.offAllNamed(Routes.login);
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
