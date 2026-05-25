import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/socket_service.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/services/translation_service.dart';
import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  final _storage = Get.find<StorageService>();

  final isDarkTheme = false.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkTheme.value = _storage.isDarkMode;
  }

  // --- Theme ---
  void toggleTheme() {
    isDarkTheme.toggle();
    Get.changeThemeMode(isDarkTheme.value ? ThemeMode.dark : ThemeMode.light);
    _storage.saveThemeMode(isDarkTheme.value);
  }

  // --- Language ---
  void changeLanguage(String langCode) {
    TranslationService.changeLocale(langCode);
    update();
  }

  // --- Logout ---
  Future<void> logout() async {
    Get.find<SocketService>().disconnect();
    await _storage.clearAuthToken();
    Get.offAllNamed(Routes.login);
  }
}
