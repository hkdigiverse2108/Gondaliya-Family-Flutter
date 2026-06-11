import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/announcement.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/api_endpoints.dart';

class AnnouncementsController extends GetxController {
  final DioApiService _apiService = Get.find<DioApiService>();

  final RxList<Announcement> announcements = <Announcement>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isLoadMore = false.obs;
  final RxBool hasMore = true.obs;

  final ScrollController scrollController = ScrollController();

  int _currentPage = 1;
  final int _limit = 10;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);
    fetchAnnouncements();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        !isLoading.value &&
        !isLoadMore.value &&
        hasMore.value) {
      fetchAnnouncements(loadMore: true);
    }
  }

  Future<void> fetchAnnouncements({bool loadMore = false}) async {
    if (loadMore) {
      isLoadMore.value = true;
      _currentPage++;
    } else {
      isLoading.value = true;
      _currentPage = 1;
      announcements.clear();
      hasMore.value = true;
    }

    try {
      final response = await _apiService.get<List<Announcement>>(
        ApiEndpoints.getAnnouncements,
        queryParams: {'page': _currentPage, 'limit': _limit},
        fromJson: (json) {
          if (json is Map<String, dynamic> && json['data'] is List) {
            return (json['data'] as List)
                .map((e) => Announcement.fromJson(e as Map<String, dynamic>))
                .toList();
          }
          return [];
        },
      );

      if (response.success && response.data != null) {
        if (loadMore) {
          announcements.addAll(response.data!);
        } else {
          announcements.assignAll(response.data!);
        }

        // If we received fewer items than the limit, we've reached the end
        if (response.data!.length < _limit) {
          hasMore.value = false;
        }
      } else {
        Get.snackbar(
          'Error',
          response.message ?? 'Failed to load announcements',
          snackPosition: SnackPosition.BOTTOM,
        );
        hasMore.value = false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred while loading announcements',
        snackPosition: SnackPosition.BOTTOM,
      );
      hasMore.value = false;
    } finally {
      isLoading.value = false;
      isLoadMore.value = false;
    }
  }

  Future<void> refreshAnnouncements() async {
    await fetchAnnouncements();
  }
}
