import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/notification_model.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/api_endpoints.dart';

class NotificationsController extends GetxController {
  final DioApiService _apiService = Get.find<DioApiService>();

  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isMarkingAllRead = false.obs;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  Future<void> fetchNotifications() async {
    isLoading.value = true;
    try {
      final response = await _apiService.get<List<NotificationModel>>(
        ApiEndpoints.notificationsAll,
        fromJson: (json) {
          if (json is Map<String, dynamic> && json['data'] is List) {
            return (json['data'] as List)
                .map(
                  (e) => NotificationModel.fromJson(e as Map<String, dynamic>),
                )
                .toList();
          }
          // fallback: if data is directly a list
          if (json is List) {
            return json
                .map(
                  (e) => NotificationModel.fromJson(e as Map<String, dynamic>),
                )
                .toList();
          }
          return [];
        },
      );

      if (response.success && response.data != null) {
        notifications.assignAll(response.data!);
      } else {
        debugPrint('Failed to load notifications: ${response.message}');
      }
    } catch (e) {
      debugPrint('Error loading notifications: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshNotifications() async {
    await fetchNotifications();
  }

  Future<void> markAllAsRead() async {
    if (unreadCount == 0) return;
    isMarkingAllRead.value = true;
    try {
      final response = await _apiService.post<void>(
        ApiEndpoints.notificationsReadAll,
        data: <String, dynamic>{},
        fromJson: (_) {},
      );

      if (response.success) {
        // Optimistically update local list
        final updated = notifications
            .map(
              (n) => NotificationModel(
                id: n.id,
                userId: n.userId,
                title: n.title,
                body: n.body,
                type: n.type,
                refId: n.refId,
                isRead: true,
                createdAt: n.createdAt,
              ),
            )
            .toList();
        notifications.assignAll(updated);
      } else {
        Get.snackbar(
          'Error',
          response.message ?? 'Could not mark notifications as read',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      debugPrint('Error marking all as read: $e');
    } finally {
      isMarkingAllRead.value = false;
    }
  }
}
