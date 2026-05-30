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

  static const Locale fallbackLocale = Locale('gu', 'IN');

  static final List<Locale> locales = [
    const Locale('gu', 'IN'),
    const Locale('en', 'US'),
  ];

  /// Get the saved locale or return default to Gujarati
  static Locale get locale {
    final String? storedLang = _box.read<String>(_key);
    if (storedLang != null) {
      if (storedLang == 'en') return const Locale('en', 'US');
      return const Locale('gu', 'IN');
    }
    return const Locale('gu', 'IN');
  }

  /// Change the application locale and save it to local storage
  static void changeLocale(String langCode) {
    final Locale newLocale = langCode == 'gu'
        ? const Locale('gu', 'IN')
        : const Locale('en', 'US');
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
    'en': enUs,
    'gu_IN': guIn,
    'gu': guIn,
  };
}
