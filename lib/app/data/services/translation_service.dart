import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/values/languages/en_us.dart';
import '../../../core/values/languages/gu_in.dart';

class TranslationService extends Translations {
  static final TranslationService _instance = TranslationService._();
  factory TranslationService() => _instance;
  TranslationService._();

  static final _box = GetStorage();
  static const String _key = 'language_code';

  static const Locale fallbackLocale = Locale('en', 'US');
  
  static final List<Locale> locales = [
    const Locale('en', 'US'),
    const Locale('gu', 'IN'),
  ];

  /// Get the saved locale or return default based on device or English
  static Locale get locale {
    final String? storedLang = _box.read<String>(_key);
    if (storedLang != null) {
      if (storedLang == 'gu') return const Locale('gu', 'IN');
      return const Locale('en', 'US');
    }
    
    // Default to device locale if it is Gujarati, otherwise default to English
    final Locale? deviceLocale = Get.deviceLocale;
    if (deviceLocale != null && deviceLocale.languageCode == 'gu') {
      return const Locale('gu', 'IN');
    }
    return const Locale('en', 'US');
  }

  /// Change the application locale and save it to local storage
  static void changeLocale(String langCode) {
    final Locale newLocale = langCode == 'gu' ? const Locale('gu', 'IN') : const Locale('en', 'US');
    Get.updateLocale(newLocale);
    _box.write(_key, langCode);
  }

  /// Helper to check if current locale is Gujarati
  static bool get isGujarati {
    return Get.locale?.languageCode == 'gu';
  }

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUs,
        'gu_IN': guIn,
      };
}
