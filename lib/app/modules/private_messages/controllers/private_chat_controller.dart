import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/private_conversation_model.dart';
import '../../../data/models/private_message_model.dart';
import '../../../data/repositories/private_chat_repository.dart';
import '../../../data/services/socket_service.dart';
import '../../../data/services/storage_service.dart';

class PrivateChatController extends GetxController {
  final _chatRepo = PrivateChatRepository();
  final _socketService = Get.find<SocketService>();
  final _storage = Get.find<StorageService>();

  final messageType = MessageType.text.obs;
  final messages = <PrivateMessage>[].obs;

  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final hasMore = true.obs;
  int _currentPage = 1;
  static const int _pageSize = 20;

  final messageController = TextEditingController();
  final scrollController = ScrollController();

  String conversationId = '';
  final otherUser = Rxn<PrivateChatUser>();

  String get currentUserId => _storage.currentUser?.id ?? '';

  @override
  void onInit() {
    super.onInit();
    // Parse conversation ID from parameters
    conversationId = Get.parameters['conversationId'] ?? '';

    // Retrieve otherUser details if passed as Get arguments
    final args = Get.arguments;
    if (args is Map<String, dynamic> && args.containsKey('otherUser')) {
      otherUser.value = args['otherUser'] as PrivateChatUser;
    }

    if (conversationId.isNotEmpty) {
      _socketService.connect();
      _socketService.joinPrivateRoom(conversationId);
      _setupSocketListeners();
      _loadMessages(page: 1);
      _markAsRead();
    }

    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    _removeSocketListeners();
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void _setupSocketListeners() {
    _socketService.on('receive_private_message', _onMessageReceived);
  }

  void _removeSocketListeners() {
    _socketService.off('receive_private_message', _onMessageReceived);
  }

  void _onMessageReceived(dynamic data) {
    if (kDebugMode) print('Socket: receive_private_message received - $data');
    try {
      if (data is Map<String, dynamic>) {
        final newMsg = PrivateMessage.fromJson(data);
        if (newMsg.conversationId == conversationId) {
          // Prepend to reactive messages list since UI is reversed
          if (!messages.any((m) => m.messageId == newMsg.messageId)) {
            messages.insert(0, newMsg);
            // Mark as read in DB if user is currently looking at this screen
            _markAsRead();
          }
        }
      }
    } catch (e) {
      if (kDebugMode) print('Error parsing received private message: $e');
    }
  }

  Future<void> _loadMessages({required int page}) async {
    if (page == 1) {
      isLoading.value = true;
    } else {
      isLoadingMore.value = true;
    }

    try {
      final response = await _chatRepo.getMessages(
        conversationId: conversationId,
        page: page,
        limit: _pageSize,
      );

      if (response.success && response.data != null) {
        final newMessages = response.data!;
        
        // If otherUser is not set yet, extract details from messages
        if (otherUser.value == null && newMessages.isNotEmpty) {
          final firstMsg = newMessages.first;
          final isMe = firstMsg.senderId == currentUserId;
          final otherId = isMe ? firstMsg.receiverId : firstMsg.senderId;
          final otherName = isMe ? null : firstMsg.senderName;
          final otherPhoto = isMe ? null : firstMsg.senderPhoto;
          
          otherUser.value = PrivateChatUser(
            userId: otherId,
            name: otherName ?? 'Member',
            avatar: otherPhoto,
          );
        }

        // The API returns messages oldest first, so we reverse it for the reversed ListView
        final reversed = newMessages.reversed.toList();

        if (page == 1) {
          messages.assignAll(reversed);
          hasMore.value = newMessages.length >= _pageSize;
          _currentPage = 1;
        } else {
          messages.addAll(reversed);
          hasMore.value = newMessages.length >= _pageSize;
          _currentPage = page;
        }
      }
    } catch (e) {
      if (kDebugMode) print('Error loading messages: $e');
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMoreMessages() async {
    if (!hasMore.value || isLoadingMore.value) return;
    await _loadMessages(page: _currentPage + 1);
  }

  void _onScroll() {
    if (scrollController.hasClients) {
      // Since ListView is reversed, bottom scroll is 0, top scroll is maxScrollExtent
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        loadMoreMessages();
      }
    }
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;
    if (otherUser.value == null) return;

    messageController.clear();

    try {
      // Emit via Socket.IO for real-time delivery
      _socketService.sendPrivateMessage(
        conversationId: conversationId,
        receiverId: otherUser.value!.userId,
        message: text,
        messageType: messageType.value.name,
      );

      // Add temporary local message placeholder for immediate visual feedback (optional)
      // Since Socket.IO emits receive_private_message back to the sender,
      // it will be added to the list shortly. No placeholder needed to avoid duplication.
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send message',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _markAsRead() async {
    try {
      await _chatRepo.markAsRead(conversationId: conversationId);
    } catch (e) {
      if (kDebugMode) print('Error marking messages as read: $e');
    }
  }
}
