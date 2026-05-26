import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/private_conversation_model.dart';
import '../../../data/repositories/private_chat_repository.dart';
import '../../../data/services/storage_service.dart';
import '../../home/home_repository.dart';
import '../../../../core/network/api_service.dart';

class SelectableUser {
  final String userId;
  final String name;
  final String? avatar;
  final String village;
  final String relation;

  const SelectableUser({
    required this.userId,
    required this.name,
    this.avatar,
    required this.village,
    required this.relation,
  });
}

class PrivateMessagesController extends GetxController {
  final _chatRepo = PrivateChatRepository();
  final _storage = Get.find<StorageService>();

  final conversations = <PrivateConversation>[].obs;
  final isLoading = false.obs;
  final isDeleting = false.obs;

  // User picker state
  final isUsersLoading = false.obs;
  final allSelectableUsers = <SelectableUser>[].obs;
  final filteredUsers = <SelectableUser>[].obs;
  final userSearchController = TextEditingController();

  String get currentUserId => _storage.currentUser?.id ?? '';

  @override
  void onInit() {
    super.onInit();
    fetchConversations();
  }

  @override
  void onClose() {
    userSearchController.dispose();
    super.onClose();
  }

  /// Load all active conversations
  Future<void> fetchConversations() async {
    isLoading.value = true;
    try {
      final response = await _chatRepo.getConversations();
      if (response.success && response.data != null) {
        conversations.assignAll(response.data!);
        _sortConversations();
      } else {
        Get.snackbar(
          'Error',
          response.message ?? 'Failed to load conversations',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      if (kDebugMode) print('Error fetching conversations: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Soft delete a conversation
  Future<void> deleteConversation(String conversationId) async {
    isDeleting.value = true;
    try {
      final response = await _chatRepo.deleteConversation(
        conversationId: conversationId,
      );
      if (response.success) {
        conversations.removeWhere((c) => c.conversationId == conversationId);
        Get.snackbar(
          'Success',
          'Conversation deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          response.message ?? 'Failed to delete conversation',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      if (kDebugMode) print('Error deleting conversation: $e');
    } finally {
      isDeleting.value = false;
    }
  }

  /// Start a new chat conversation
  Future<void> startNewChat(SelectableUser user) async {
    isLoading.value = true;
    try {
      final response = await _chatRepo.startConversation(
        receiverId: user.userId,
      );
      if (response.success && response.data != null) {
        final conversationId = response.data!;
        // Go to private chat view and pass the selected user as argument
        Get.toNamed(
          '/private-chat/$conversationId',
          arguments: {
            'otherUser': PrivateChatUser(
              userId: user.userId,
              name: user.name,
              avatar: user.avatar,
            ),
          },
        );
        // Refresh conversations list in background
        fetchConversations();
      } else {
        Get.snackbar(
          'Error',
          response.message ?? 'Failed to start conversation',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not start conversation',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Load and parse parivar directory to build list of selectable users for picker
  Future<void> loadSelectableUsers() async {
    isUsersLoading.value = true;
    allSelectableUsers.clear();
    filteredUsers.clear();
    userSearchController.clear();

    try {
      final homeRepo = HomeRepository(Get.find<DioApiService>());
      final directory = await homeRepo.getParivarDirectory();
      if (directory != null) {
        final list = <SelectableUser>[];

        for (final fam in directory) {
          // 1. Add head of family (if registered and not current user)
          if (fam.id.isNotEmpty && fam.id != currentUserId) {
            list.add(SelectableUser(
              userId: fam.id,
              name: '${fam.head.firstName} ${fam.head.lastName}'.trim(),
              avatar: null, // Initial name-based avatar will be shown in UI
              village: fam.head.village,
              relation: 'Head of Family',
            ));
          }

          // 2. Add family members who have a linked user account
          for (final mem in fam.familyMembers) {
            if (mem.linkedUserId != null &&
                mem.linkedUserId!.isNotEmpty &&
                mem.linkedUserId != currentUserId) {
              list.add(SelectableUser(
                userId: mem.linkedUserId!,
                name: '${mem.firstName} ${mem.lastName}'.trim(),
                avatar: null,
                village: fam.head.village,
                relation: mem.relation,
              ));
            }
          }
        }

        allSelectableUsers.assignAll(list);
        filteredUsers.assignAll(list);
      }
    } catch (e) {
      if (kDebugMode) print('Error loading selectable users: $e');
    } finally {
      isUsersLoading.value = false;
    }
  }

  /// Filter selectable users based on search text
  void filterUsers(String query) {
    if (query.trim().isEmpty) {
      filteredUsers.assignAll(allSelectableUsers);
      return;
    }

    final q = query.toLowerCase();
    filteredUsers.assignAll(
      allSelectableUsers.where((u) {
        return u.name.toLowerCase().contains(q) ||
            u.village.toLowerCase().contains(q) ||
            u.relation.toLowerCase().contains(q);
      }).toList(),
    );
  }

  void _sortConversations() {
    conversations.sort((a, b) {
      if (a.lastMessageAt == null) return 1;
      if (b.lastMessageAt == null) return -1;
      return b.lastMessageAt!.compareTo(a.lastMessageAt!);
    });
  }
}
