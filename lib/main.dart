import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app/data/services/storage_service.dart';
import 'app/data/services/auth_service.dart';
import 'app/data/services/translation_service.dart';
import 'app/routes/app_pages.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local storage service
  final storageService = StorageService();
  await storageService.init();
  Get.put<StorageService>(storageService, permanent: true);

  // Initialize authentication service
  final authService = AuthService();
  await authService.init();
  Get.put<AuthService>(authService, permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine initial theme mode based on stored user preference
    final StorageService storage = Get.find<StorageService>();
    final isDark = storage.isDarkMode;

    // Determine initial route based on authentication state
    final AuthService auth = Get.find<AuthService>();
    final String initialRoute = auth.isLoggedIn ? Routes.home : Routes.login;

    return ScreenUtilInit(
      designSize: const Size(375, 812), // Standard design size for scaling UI
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Gondalia Family',
          debugShowCheckedModeBanner: false,

          // Localization settings
          translations: TranslationService(),
          locale: TranslationService.locale,
          fallbackLocale: TranslationService.fallbackLocale,

          // Theme settings
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

          // Routing configuration
          initialRoute: initialRoute,
          getPages: AppPages.routes,
        );
      },
    );
  }
}
