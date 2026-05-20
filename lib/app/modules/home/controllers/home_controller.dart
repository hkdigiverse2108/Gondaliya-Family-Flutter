import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/family_member.dart';
import '../../../data/models/business.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/translation_service.dart';
import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  final AuthService _authService = Get.find<AuthService>();
  final _uuid = const Uuid();

  // Navigation tab state
  final currentIndex = 0.obs;

  // Theme & Language states
  final isDarkTheme = false.obs;

  // Data lists
  final familyMembers = <FamilyMember>[].obs;
  final businesses = <Business>[].obs;

  // Search queries
  final familySearchQuery = ''.obs;
  final businessSearchQuery = ''.obs;

  // Filter lists based on search queries
  List<FamilyMember> get filteredFamilyMembers {
    if (familySearchQuery.value.trim().isEmpty) {
      return familyMembers;
    }
    final query = familySearchQuery.value.toLowerCase();
    return familyMembers.where((member) {
      return member.name.toLowerCase().contains(query) ||
          member.surname.toLowerCase().contains(query) ||
          member.fatherName.toLowerCase().contains(query) ||
          member.occupation.toLowerCase().contains(query) ||
          member.relationship.toLowerCase().contains(query);
    }).toList();
  }

  List<Business> get filteredBusinesses {
    if (businessSearchQuery.value.trim().isEmpty) {
      return businesses;
    }
    final query = businessSearchQuery.value.toLowerCase();
    return businesses.where((business) {
      return business.name.toLowerCase().contains(query) ||
          business.category.toLowerCase().contains(query) ||
          business.description.toLowerCase().contains(query) ||
          business.address.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    // Load persisted theme and data
    isDarkTheme.value = _storageService.isDarkMode;

    // Load current user's family members
    if (_authService.isLoggedIn) {
      familyMembers.assignAll(_authService.currentUser.value!.familyMembers);
    }

    businesses.assignAll(_storageService.getBusinesses());
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }

  // --- Theme Mode ---
  void toggleTheme() {
    isDarkTheme.toggle();
    Get.changeThemeMode(isDarkTheme.value ? ThemeMode.dark : ThemeMode.light);
    _storageService.saveThemeMode(isDarkTheme.value);
  }

  // --- Language Switch ---
  void changeLanguage(String langCode) {
    TranslationService.changeLocale(langCode);
    update(); // Triggers UI redraw for localized keys
  }

  // --- Logout ---
  Future<void> logout() async {
    await _authService.logout();
    Get.offAllNamed(Routes.LOGIN);
  }

  // --- Family Member CRUD Operations ---

  void addFamilyMember({
    required String name,
    required String surname,
    required String fatherName,
    required int age,
    required String relationship,
    required String phoneNumber,
    required String occupation,
    required String birthDate,
    required String education,
    required bool isMarried,
    required String bloodGroup,
    required String skill,
    required String notes,
  }) {
    final member = FamilyMember(
      id: _uuid.v4(),
      name: name,
      surname: surname,
      fatherName: fatherName,
      age: age,
      relationship: relationship,
      phoneNumber: phoneNumber,
      occupation: occupation,
      birthDate: birthDate,
      education: education,
      isMarried: isMarried,
      bloodGroup: bloodGroup,
      skill: skill,
      notes: notes,
      createdAt: DateTime.now(),
    );
    familyMembers.add(member);

    // Save to user profile
    if (_authService.isLoggedIn) {
      final updatedUser = _authService.currentUser.value!.copyWith(
        familyMembers: List<FamilyMember>.from(familyMembers),
      );
      _authService.updateCurrentUser(updatedUser);
    }
  }

  void updateFamilyMember(FamilyMember updatedMember) {
    final index = familyMembers.indexWhere((m) => m.id == updatedMember.id);
    if (index != -1) {
      familyMembers[index] = updatedMember;

      // Save to user profile
      if (_authService.isLoggedIn) {
        final updatedUser = _authService.currentUser.value!.copyWith(
          familyMembers: List<FamilyMember>.from(familyMembers),
        );
        _authService.updateCurrentUser(updatedUser);
      }
    }
  }

  void deleteFamilyMember(String id) {
    familyMembers.removeWhere((m) => m.id == id);

    // Save to user profile
    if (_authService.isLoggedIn) {
      final updatedUser = _authService.currentUser.value!.copyWith(
        familyMembers: List<FamilyMember>.from(familyMembers),
      );
      _authService.updateCurrentUser(updatedUser);
    }
  }

  // --- Business CRUD Operations ---

  void addBusiness({
    required String name,
    required String category,
    required String address,
    required String contact,
    required String description,
    String? ownerId,
  }) {
    final business = Business(
      id: _uuid.v4(),
      name: name,
      category: category,
      address: address,
      contact: contact,
      description: description,
      ownerId: ownerId ?? _authService.currentUser.value?.id,
      createdAt: DateTime.now(),
    );
    businesses.add(business);
    _storageService.saveBusinesses(businesses);
  }

  void updateBusiness(Business updatedBusiness) {
    final index = businesses.indexWhere((b) => b.id == updatedBusiness.id);
    if (index != -1) {
      businesses[index] = updatedBusiness;
      _storageService.saveBusinesses(businesses);
    }
  }

  void deleteBusiness(String id) {
    businesses.removeWhere((b) => b.id == id);
    _storageService.saveBusinesses(businesses);
  }
}
