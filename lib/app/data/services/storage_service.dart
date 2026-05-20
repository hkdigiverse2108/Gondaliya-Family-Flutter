import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/family_member.dart';
import '../models/business.dart';

class StorageService extends GetxService {
  late GetStorage _box;

  static const String _familyKey = 'family_members';
  static const String _businessKey = 'businesses';
  static const String _themeKey = 'is_dark_mode';

  /// Initialize GetStorage database
  Future<StorageService> init() async {
    await GetStorage.init();
    _box = GetStorage();
    return this;
  }

  // --- Theme Mode ---
  
  /// Read theme mode preference
  bool get isDarkMode => _box.read<bool>(_themeKey) ?? false;
  
  /// Save theme mode preference
  void saveThemeMode(bool isDark) {
    _box.write(_themeKey, isDark);
  }

  // --- Family Members ---

  /// Retrieve all family members from storage
  List<FamilyMember> getFamilyMembers() {
    final rawData = _box.read<List<dynamic>>(_familyKey);
    if (rawData == null) return [];
    return rawData
        .map((e) => FamilyMember.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  /// Save all family members to storage
  void saveFamilyMembers(List<FamilyMember> members) {
    final rawData = members.map((e) => e.toJson()).toList();
    _box.write(_familyKey, rawData);
  }

  // --- Businesses ---

  /// Retrieve all businesses from storage
  List<Business> getBusinesses() {
    final rawData = _box.read<List<dynamic>>(_businessKey);
    if (rawData == null) return [];
    return rawData
        .map((e) => Business.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  /// Save all businesses to storage
  void saveBusinesses(List<Business> businesses) {
    final rawData = businesses.map((e) => e.toJson()).toList();
    _box.write(_businessKey, rawData);
  }
}
