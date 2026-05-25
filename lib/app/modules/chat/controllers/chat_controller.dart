import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/chat.dart';
import '../../../data/repositories/chat_repository.dart';
import '../../../data/services/socket_service.dart';
import '../../../data/services/storage_service.dart';

enum ChatMode { give, take }

class ChatController extends GetxController {
  final _chatRepo = ChatRepository();
  final _socketService = Get.find<SocketService>();
  final _storage = Get.find<StorageService>();

  final chatMode = ChatMode.give.obs;
  final remainingMessages = 32.obs;

  final messages = <Chat>[].obs;
  final isLoading = false.obs;

  final messageController = TextEditingController();
  final scrollController = ScrollController();

  String get currentUserId => _storage.currentUser?.id ?? '';

  @override
  void onInit() {
    super.onInit();
    // Ensure socket is connected
    _socketService.connect();
    _setupSocketListeners();
    _loadChatMessages();
  }

  @override
  void onClose() {
    _removeSocketListeners();
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void _setupSocketListeners() {
    _socketService.on('chat:connected', _onChatConnected);
    _socketService.on('chat:message', _onChatMessageReceived);
    _socketService.on('chat:removed', _onChatMessageRemoved);
    _socketService.on('chat:blocked', _onChatMessageBlocked);
  }

  void _removeSocketListeners() {
    _socketService.off('chat:connected', _onChatConnected);
    _socketService.off('chat:message', _onChatMessageReceived);
    _socketService.off('chat:removed', _onChatMessageRemoved);
    _socketService.off('chat:blocked', _onChatMessageBlocked);
  }

  void _onChatConnected(dynamic data) {
    if (kDebugMode) {
      print('Socket: chat:connected received - $data');
    }
  }

  void _onChatMessageReceived(dynamic data) {
    if (kDebugMode) {
      print('Socket: chat:message received - $data');
    }
    try {
      if (data is Map<String, dynamic>) {
        final newChat = Chat.fromJson(data);
        _addMessageToList(newChat);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing received chat message: $e');
      }
    }
  }

  void _onChatMessageRemoved(dynamic data) {
    if (kDebugMode) {
      print('Socket: chat:removed received - $data');
    }
    try {
      if (data is Map<String, dynamic>) {
        final id = data['id'] as String?;
        if (id != null) {
          messages.removeWhere((msg) => msg.id == id);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error processing chat message removal: $e');
      }
    }
  }

  void _onChatMessageBlocked(dynamic data) {
    if (kDebugMode) {
      print('Socket: chat:blocked received - $data');
    }
    try {
      if (data is Map<String, dynamic>) {
        final id = data['id'] as String?;
        if (id != null) {
          final index = messages.indexWhere((msg) => msg.id == id);
          if (index != -1) {
            final oldChat = messages[index];
            final updatedChat = Chat(
              id: oldChat.id,
              senderId: oldChat.senderId,
              message: oldChat.message,
              mediaUrl: oldChat.mediaUrl,
              mediaType: oldChat.mediaType,
              fileSize: oldChat.fileSize,
              isDeleted: oldChat.isDeleted,
              isBlocked: true,
              deletedBy: oldChat.deletedBy,
              createdAt: oldChat.createdAt,
              updatedAt: oldChat.updatedAt,
            );
            messages[index] = updatedChat;
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error processing chat message block: $e');
      }
    }
  }

  void _addMessageToList(Chat chat) {
    // Prevent duplicate messages
    if (!messages.any((msg) => msg.id == chat.id)) {
      messages.add(chat);
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _loadChatMessages() async {
    isLoading.value = true;
    try {
      final response = await _chatRepo.getChatMessages(limit: 15);
      if (response.success && response.data != null) {
        final sortedList = List<Chat>.from(response.data!);
        sortedList.sort((a, b) {
          if (a.createdAt == null) return 1;
          if (b.createdAt == null) return -1;
          return a.createdAt!.compareTo(b.createdAt!);
        });
        messages.assignAll(sortedList);
        _scrollToBottom();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading chat messages: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    if (remainingMessages.value <= 0) {
      Get.snackbar(
        'Limit Reached',
        'You have reached your 32 message daily limit.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    messageController.clear();

    try {
      final response = await _chatRepo.sendChatMessage(message: text);

      if (response.success && response.data != null) {
        remainingMessages.value--;
        _addMessageToList(response.data!);
      } else {
        Get.snackbar(
          'Error',
          response.message ?? 'Failed to send message',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred while sending message',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
