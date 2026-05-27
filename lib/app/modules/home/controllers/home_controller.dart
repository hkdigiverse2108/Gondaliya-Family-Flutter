import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/business.dart';
import '../../../data/models/user.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/services/socket_service.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/services/translation_service.dart';
import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  final _storage = Get.find<StorageService>();
  final _authRepo = AuthRepository();

  final isDarkTheme = false.obs;

  final isBusinessesLoading = false.obs;
  final businesses = <Business>[].obs;

  final businessSearchQuery = ''.obs;
  final businessSearchController = TextEditingController();

  final searchBusinessesList = <Business>[].obs;
  final isSearchLoading = false.obs;
  final isLoadMoreLoading = false.obs;
  int _currentPage = 1;
  final int _limit = 10;
  bool _hasMore = true;

  /// When true the search-result list is shown even with an empty query.
  /// Activated by tapping "See All" on the Verified Businesses section.
  final showAllBusinessMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkTheme.value = _storage.isDarkMode;

    fetchBusinesses();

    businessSearchController.addListener(() {
      businessSearchQuery.value = businessSearchController.text;
    });

    // Debounce business search query to hit API
    debounce(businessSearchQuery, (query) {
      if (query.trim().isNotEmpty) {
        // When user types, disable showAllBusinessMode (it was set by See All)
        showAllBusinessMode.value = false;
        searchBusinesses(query);
      } else if (!showAllBusinessMode.value) {
        // Only clear when NOT in showAll mode
        searchBusinessesList.clear();
      }
    }, time: const Duration(milliseconds: 500));
  }

  @override
  void onClose() {
    businessSearchController.dispose();
    super.onClose();
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

  // --- Businesses ---
  Future<void> fetchBusinesses() async {
    isBusinessesLoading.value = true;
    try {
      final response = await _authRepo.getBusinesses();
      if (response.success && response.data != null) {
        final List<Business> list = [];
        for (var item in response.data!) {
          try {
            if (item is Map<String, dynamic> && item.containsKey('business')) {
              final bizJson = item['business'] as Map<String, dynamic>;
              final ownerJson = item['owner'] as Map<String, dynamic>?;
              final ownerId = ownerJson?['userId'] ?? '';

              final locs = bizJson['locations'] as List<dynamic>?;
              final String shopAddress;
              final String city;
              if (locs != null && locs.isNotEmpty) {
                final firstLoc = locs.first as Map<String, dynamic>;
                city = firstLoc['areaCity'] ?? '';
                final addrParts = [
                  firstLoc['shopAddress'] ?? '',
                  firstLoc['areaCity'] ?? '',
                  firstLoc['state'] ?? '',
                  firstLoc['pincode'] ?? '',
                ].where((part) => part.toString().trim().isNotEmpty).toList();
                shopAddress = addrParts.join(', ');
              } else {
                shopAddress = '';
                city = '';
              }

              final contactInfo =
                  bizJson['contactInfo'] as Map<String, dynamic>?;
              final contact =
                  contactInfo?['mobile1'] ?? ownerJson?['phoneNumber'] ?? '';
              final ownerName = (ownerJson != null)
                  ? "${ownerJson['firstName'] ?? ''} ${ownerJson['lastName'] ?? ''}"
                        .trim()
                  : (bizJson['ownerName'] ?? '');

              final businessLogo = bizJson['businessLogo'] as String?;
              final businessBanner = bizJson['businessBanner'] as String?;
              final businessPhotos =
                  (bizJson['businessPhotos'] as List<dynamic>?)
                      ?.map((e) => e.toString())
                      .toList();

              list.add(
                Business(
                  id: ownerId,
                  name: bizJson['businessName'] ?? '',
                  category: bizJson['category'] ?? '',
                  subCategory: bizJson['subCategory'] is List
                      ? (bizJson['subCategory'] as List)
                          .map((e) => e.toString())
                          .toList()
                      : (bizJson['subCategory'] != null &&
                              bizJson['subCategory'].toString().isNotEmpty)
                          ? [bizJson['subCategory'].toString()]
                          : [],
                  address: shopAddress,
                  city: city,
                  contact: contact,
                  description: bizJson['description'] ?? '',
                  ownerId: ownerId,
                  createdAt: DateTime.now(),
                  ownerName: ownerName,
                  businessLogo: businessLogo,
                  businessBanner: businessBanner,
                  businessPhotos: businessPhotos,
                ),
              );
            } else if (item is Map<String, dynamic> &&
                item.containsKey('workDetails')) {
              final user = UserModel.fromJson(item);
              if (user.workDetails?.businessDetails != null) {
                final biz = user.workDetails!.businessDetails!;
                final String shopAddress;
                final String city;
                if (biz.locations.isNotEmpty) {
                  final firstLoc = biz.locations.first;
                  city = firstLoc.areaCity;
                  final addrParts = [
                    firstLoc.shopAddress,
                    firstLoc.areaCity,
                    firstLoc.state,
                    firstLoc.pincode,
                  ].where((part) => part.trim().isNotEmpty).toList();
                  shopAddress = addrParts.join(', ');
                } else {
                  shopAddress = '';
                  city = '';
                }

                list.add(
                  Business(
                    id: user.id,
                    name: biz.businessName,
                    category: biz.category,
                    subCategory: biz.subCategory,
                    address: shopAddress,
                    city: city,
                    contact: biz.contactInfo?.mobile1 ?? user.phoneNumber,
                    description: biz.description,
                    ownerId: user.id,
                    createdAt: user.createdAt ?? DateTime.now(),
                    ownerName: biz.ownerName.isNotEmpty
                        ? biz.ownerName
                        : '${user.firstName} ${user.lastName}'.trim(),
                    businessLogo: biz.businessLogo,
                    businessBanner: biz.businessBanner,
                    businessPhotos: biz.businessPhotos,
                  ),
                );
              }
            } else {
              list.add(Business.fromJson(item as Map<String, dynamic>));
            }
          } catch (e) {
            // Ignore single item errors
          }
        }
        businesses.assignAll(list);
      }
    } catch (e) {
      Get.printError(info: 'fetchBusinesses error: $e');
    } finally {
      isBusinessesLoading.value = false;
    }
  }

  Future<void> searchBusinesses(String query, {bool loadMore = false}) async {
    if (loadMore) {
      if (isLoadMoreLoading.value || !_hasMore) return;
      isLoadMoreLoading.value = true;
    } else {
      if (isSearchLoading.value) return;
      isSearchLoading.value = true;
      _currentPage = 1;
      _hasMore = true;
      searchBusinessesList.clear();
    }

    try {
      final response = await _authRepo.getBusinesses(
        search: query.trim(),
        page: _currentPage,
        limit: _limit,
      );

      if (response.success && response.data != null) {
        final List<Business> list = [];
        for (var item in response.data!) {
          try {
            if (item is Map<String, dynamic> && item.containsKey('business')) {
              final bizJson = item['business'] as Map<String, dynamic>;
              final ownerJson = item['owner'] as Map<String, dynamic>?;
              final ownerId = ownerJson?['userId'] ?? '';

              final locs = bizJson['locations'] as List<dynamic>?;
              final String shopAddress;
              final String city;
              if (locs != null && locs.isNotEmpty) {
                final firstLoc = locs.first as Map<String, dynamic>;
                city = firstLoc['areaCity'] ?? '';
                final addrParts = [
                  firstLoc['shopAddress'] ?? '',
                  firstLoc['areaCity'] ?? '',
                  firstLoc['state'] ?? '',
                  firstLoc['pincode'] ?? '',
                ].where((part) => part.toString().trim().isNotEmpty).toList();
                shopAddress = addrParts.join(', ');
              } else {
                shopAddress = '';
                city = '';
              }

              final contactInfo =
                  bizJson['contactInfo'] as Map<String, dynamic>?;
              final contact =
                  contactInfo?['mobile1'] ?? ownerJson?['phoneNumber'] ?? '';
              final ownerName = (ownerJson != null)
                  ? "${ownerJson['firstName'] ?? ''} ${ownerJson['lastName'] ?? ''}"
                        .trim()
                  : (bizJson['ownerName'] ?? '');

              final businessLogo = bizJson['businessLogo'] as String?;
              final businessBanner = bizJson['businessBanner'] as String?;
              final businessPhotos =
                  (bizJson['businessPhotos'] as List<dynamic>?)
                      ?.map((e) => e.toString())
                      .toList();

              list.add(
                Business(
                  id: ownerId,
                  name: bizJson['businessName'] ?? '',
                  category: bizJson['category'] ?? '',
                  subCategory: bizJson['subCategory'] is List
                      ? (bizJson['subCategory'] as List)
                          .map((e) => e.toString())
                          .toList()
                      : (bizJson['subCategory'] != null &&
                              bizJson['subCategory'].toString().isNotEmpty)
                          ? [bizJson['subCategory'].toString()]
                          : [],
                  address: shopAddress,
                  city: city,
                  contact: contact,
                  description: bizJson['description'] ?? '',
                  ownerId: ownerId,
                  createdAt: DateTime.now(),
                  ownerName: ownerName,
                  businessLogo: businessLogo,
                  businessBanner: businessBanner,
                  businessPhotos: businessPhotos,
                ),
              );
            } else {
              list.add(Business.fromJson(item as Map<String, dynamic>));
            }
          } catch (e) {
            // Ignore single item errors
          }
        }

        if (list.length < _limit) {
          _hasMore = false;
        }

        searchBusinessesList.addAll(list);
        _currentPage++;
      } else {
        _hasMore = false;
      }
    } catch (e) {
      Get.printError(info: 'searchBusinesses error: $e');
    } finally {
      if (loadMore) {
        isLoadMoreLoading.value = false;
      } else {
        isSearchLoading.value = false;
      }
    }
  }

  /// Called when the user taps "See All" on the businesses section.
  /// Loads all businesses with no query and enters search-result display mode.
  Future<void> loadAllBusinesses() async {
    showAllBusinessMode.value = true;
    await searchBusinesses('');
  }

  /// Resets the "See All" businesses mode back to the normal home view.
  void resetBusinessMode() {
    showAllBusinessMode.value = false;
    searchBusinessesList.clear();
    _currentPage = 1;
    _hasMore = true;
  }
}
