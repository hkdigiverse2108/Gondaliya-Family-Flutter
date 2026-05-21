import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/family_member.dart';
import '../../../data/models/business.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/services/translation_service.dart';
import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  final _storage = Get.find<StorageService>();
  final _uuid = const Uuid();

  final currentIndex = 0.obs;
  final isDarkTheme = false.obs;

  // Data lists — populated from API in a later task
  final familyMembers = <FamilyMember>[].obs;
  final businesses = <Business>[].obs;

  // Search queries
  final familySearchQuery = ''.obs;
  final businessSearchQuery = ''.obs;

  List<FamilyMember> get filteredFamilyMembers {
    if (familySearchQuery.value.trim().isEmpty) return familyMembers;
    final q = familySearchQuery.value.toLowerCase();
    return familyMembers
        .where(
          (m) =>
              m.firstName.toLowerCase().contains(q) ||
              m.middleName.toLowerCase().contains(q) ||
              m.lastName.toLowerCase().contains(q) ||
              (m.occupation?.toLowerCase().contains(q) ?? false) ||
              m.relation.toLowerCase().contains(q),
        )
        .toList();
  }

  List<Business> get filteredBusinesses {
    if (businessSearchQuery.value.trim().isEmpty) return businesses;
    final q = businessSearchQuery.value.toLowerCase();
    return businesses
        .where(
          (b) =>
              b.name.toLowerCase().contains(q) ||
              b.category.toLowerCase().contains(q) ||
              b.description.toLowerCase().contains(q) ||
              b.address.toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    isDarkTheme.value = _storage.isDarkMode;
    // TODO: fetch family & business data from API
  }

  void changeTab(int index) => currentIndex.value = index;

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
    await _storage.clearAuthToken();
    Get.offAllNamed(Routes.login);
  }

  // --- Family Member stubs (local-only until API is wired) ---
  void addFamilyMember({
    required String firstName,
    required String middleName,
    required String lastName,
    required String dob,
    required String relation,
    required String phoneNumber,
    required String occupation,
    required String education,
    required String isMarried,
    required String bloodGroup,
    required String skills,
  }) {
    familyMembers.add(
      FamilyMember(
        id: _uuid.v4(),
        firstName: firstName,
        middleName: middleName,
        lastName: lastName,
        dob: dob,
        relation: relation,
        phoneNumber: phoneNumber,
        occupation: occupation,
        education: education,
        isMarried: isMarried,
        bloodGroup: bloodGroup,
        skills: skills,
        createdAt: DateTime.now(),
      ),
    );
    // TODO: persist via API
  }

  void updateFamilyMember(FamilyMember updated) {
    final i = familyMembers.indexWhere((m) => m.id == updated.id);
    if (i != -1) {
      familyMembers[i] = updated;
      // TODO: persist via API
    }
  }

  void deleteFamilyMember(String id) {
    familyMembers.removeWhere((m) => m.id == id);
    // TODO: persist via API
  }

  // --- Business stubs (local-only until API is wired) ---
  void addBusiness({
    required String name,
    required String category,
    required String address,
    required String contact,
    required String description,
    String? ownerId,
  }) {
    businesses.add(
      Business(
        id: _uuid.v4(),
        name: name,
        category: category,
        address: address,
        contact: contact,
        description: description,
        ownerId: ownerId,
        createdAt: DateTime.now(),
      ),
    );
    // TODO: persist via API
  }

  void updateBusiness(Business updated) {
    final i = businesses.indexWhere((b) => b.id == updated.id);
    if (i != -1) {
      businesses[i] = updated;
      // TODO: persist via API
    }
  }

  void deleteBusiness(String id) {
    businesses.removeWhere((b) => b.id == id);
    // TODO: persist via API
  }
}
