import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/family_member.dart';
import '../../../data/models/business.dart';
import '../../../data/models/announcement.dart';
import '../../../data/models/listing.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/services/translation_service.dart';
import '../../../routes/app_pages.dart';
import '../home_repository.dart';

class HomeController extends GetxController {
  final _storage = Get.find<StorageService>();
  final _homeRepo = Get.find<HomeRepository>();
  final _uuid = const Uuid();

  final currentIndex = 0.obs;
  final isDarkTheme = false.obs;

  // Data lists
  final familyMembers = <FamilyMember>[].obs;
  final businesses = <Business>[].obs;

  // Feed Data
  final announcements = <Announcement>[].obs;
  final listings = <Listing>[].obs;
  final isFeedLoading = false.obs;

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

  List<dynamic> get combinedFeed {
    final list = <dynamic>[...announcements, ...listings];
    list.sort((a, b) {
      final aDate =
          (a.createdAt as DateTime?) ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bDate =
          (b.createdAt as DateTime?) ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bDate.compareTo(aDate);
    });
    return list;
  }

  @override
  void onInit() {
    super.onInit();
    isDarkTheme.value = _storage.isDarkMode;
    fetchFeedData();
  }

  Future<void> fetchFeedData() async {
    isFeedLoading.value = true;
    try {
      final fetchedAnnouncements = await _homeRepo.getAnnouncements();
      final fetchedListings = await _homeRepo.getListings();

      if (fetchedAnnouncements.isEmpty && fetchedListings.isEmpty) {
        // Inject Dummy Data for testing since API might not be ready
        _injectDummyData();
      } else {
        announcements.assignAll(fetchedAnnouncements);
        listings.assignAll(fetchedListings);
      }
    } catch (e) {
      _injectDummyData();
    } finally {
      isFeedLoading.value = false;
    }
  }

  void _injectDummyData() {
    announcements.assignAll([
      Announcement(
        id: '1',
        title: 'Samast Patidar Samaj Meeting',
        description:
            'Monthly gathering to discuss community developments and upcoming events. Dinner will be served.',
        createdBy: 'Admin',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Announcement(
        id: '2',
        title: 'Education Scholarship 2026',
        description:
            'Applications are now open for the Gondaliya Family Education Trust scholarship for university students.',
        createdBy: 'Admin',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ]);

    listings.assignAll([
      Listing(
        id: '1',
        title: 'Shop for Rent in Varachha',
        description:
            'Prime location shop available for rent on the main road. Suitable for clothing or electronics store.',
        type: 'Rent',
        price: 25000,
        priceUnit: 'Month',
        postedBy: 'User1',
        availableFrom: DateTime.now(),
        location: const ListingLocation(city: 'Surat', pincode: '395006'),
        contactPhone: '9876543210',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      Listing(
        id: '2',
        title: 'Used Honda City 2021',
        description:
            'Well-maintained Honda City ZX, 1st owner, 30,000 km driven. Excellent condition.',
        type: '2nd Hand',
        price: 950000,
        priceUnit: 'FIXED',
        postedBy: 'User2',
        availableFrom: DateTime.now(),
        location: const ListingLocation(city: 'Surat', pincode: '395004'),
        contactPhone: '9876543211',
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      Listing(
        id: '3',
        title: 'Mangoes (Kesar) Box',
        description:
            'Fresh organic Kesar mangoes directly from our farm in Junagadh. 10kg box.',
        type: 'Seasonal',
        price: 1200,
        priceUnit: 'Box',
        postedBy: 'User3',
        availableFrom: DateTime.now(),
        location: const ListingLocation(city: 'Junagadh', pincode: '362001'),
        contactPhone: '9876543212',
        createdAt: DateTime.now().subtract(const Duration(hours: 24)),
      ),
    ]);
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
