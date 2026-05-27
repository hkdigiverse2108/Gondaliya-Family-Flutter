import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../../data/models/chat.dart';
import '../../../data/repositories/chat_repository.dart';
import '../../../data/repositories/private_chat_repository.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/models/private_conversation_model.dart';
import '../../../data/services/socket_service.dart';
import '../../../data/services/storage_service.dart';

enum ChatMode { give, take }

class ChatController extends GetxController {
  final _chatRepo = ChatRepository();
  final _socketService = Get.find<SocketService>();
  final _storage = Get.find<StorageService>();

  final chatMode = ChatMode.give.obs;
  final remainingMessages = 2.obs;
  final messageType = 'give'.obs;

  final messages = <Chat>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;

  // Pagination
  int _currentPage = 1;
  int _totalPages = 1;
  bool get hasMoreMessages => _currentPage < _totalPages;

  static const int _pageSize = 15;
  final pickedFilePath = RxnString();
  final pickedFileType = RxnString(); // 'IMAGE' or 'FILE'
  final pickedFileSize = 0.obs;
  final pickedFileName = RxnString();
  final isUploading = false.obs;

  final messageController = TextEditingController();
  final scrollController = ScrollController();

  String get currentUserId => _storage.currentUser?.id ?? '';

  @override
  void onInit() {
    super.onInit();
    _updateRemainingMessages();
    // Ensure socket is connected
    _socketService.connect();
    _setupSocketListeners();
    _loadChatMessages();
    // Load more when user scrolls to the very top
    scrollController.addListener(_onScroll);
  }

  void _updateRemainingMessages() {
    final sentToday = _storage.getDailyChatCount(currentUserId);
    remainingMessages.value = (2 - sentToday).clamp(0, 2);
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
              messageType: oldChat.messageType,
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
    _currentPage = 1;
    try {
      final response = await _chatRepo.getChatMessages(
        page: _currentPage,
        limit: _pageSize,
      );
      if (response.success && response.data != null) {
        final (fetchedMsgs, totalPages) = response.data!;
        _totalPages = totalPages;
        final sortedList = List<Chat>.from(fetchedMsgs);
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

  /// Load the next (older) batch of messages when the user scrolls to the top.
  Future<void> loadMoreMessages() async {
    if (isLoadingMore.value || !hasMoreMessages) return;
    isLoadingMore.value = true;

    try {
      final nextPage = _currentPage + 1;
      final response = await _chatRepo.getChatMessages(
        page: nextPage,
        limit: _pageSize,
      );
      if (response.success && response.data != null) {
        final (fetchedMsgs, totalPages) = response.data!;
        _totalPages = totalPages;
        _currentPage = nextPage;

        final sortedList = List<Chat>.from(fetchedMsgs);
        sortedList.sort((a, b) {
          if (a.createdAt == null) return 1;
          if (b.createdAt == null) return -1;
          return a.createdAt!.compareTo(b.createdAt!);
        });

        // Prepend older messages (deduplicate)
        final existingIds = messages.map((m) => m.id).toSet();
        final newMsgs = sortedList
            .where((m) => !existingIds.contains(m.id))
            .toList();

        // Capture both values RIGHT BEFORE the insert (after fetch is done)
        // so they reflect the actual state at insert time, not before the async call.
        final savedOffset = scrollController.hasClients
            ? scrollController.offset
            : 0.0;
        final savedMaxExtent = scrollController.hasClients
            ? scrollController.position.maxScrollExtent
            : 0.0;

        messages.insertAll(0, newMsgs);

        // After the ListView rebuilds with new items prepended, the content
        // height grows at the top.  Jump to savedOffset + growth so the user
        // stays on the same old message they were looking at.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (scrollController.hasClients) {
            final newMaxExtent = scrollController.position.maxScrollExtent;
            final growth = newMaxExtent - savedMaxExtent;
            scrollController.jumpTo(
              (savedOffset + growth).clamp(0.0, newMaxExtent),
            );
          }
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading more chat messages: $e');
      }
    } finally {
      isLoadingMore.value = false;
    }
  }

  void _onScroll() {
    if (scrollController.hasClients &&
        scrollController.position.pixels <= 40 &&
        hasMoreMessages &&
        !isLoadingMore.value) {
      loadMoreMessages();
    }
  }

  Future<void> pickImage() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        final file = File(picked.path);
        final size = await file.length();
        // Image limit: 5MB
        if (size > 5 * 1024 * 1024) {
          Get.snackbar(
            'error'.tr,
            'file_limit_exceeded_image'.tr,
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
        pickedFilePath.value = picked.path;
        pickedFileType.value = 'IMAGE';
        pickedFileSize.value = size;
        pickedFileName.value = picked.name;
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'file_picker_error'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> pickDocument() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null && result.files.single.path != null) {
        final path = result.files.single.path!;
        final file = File(path);
        final size = await file.length();
        // PDF limit: 10MB
        if (size > 10 * 1024 * 1024) {
          Get.snackbar(
            'error'.tr,
            'file_limit_exceeded_pdf'.tr,
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
        pickedFilePath.value = path;
        pickedFileType.value = 'FILE';
        pickedFileSize.value = size;
        pickedFileName.value = result.files.single.name;
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'file_picker_error'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void clearAttachment() {
    pickedFilePath.value = null;
    pickedFileType.value = null;
    pickedFileSize.value = 0;
    pickedFileName.value = null;
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    final hasAttachment = pickedFilePath.value != null;
    if (text.isEmpty && !hasAttachment) return;

    final sentToday = _storage.getDailyChatCount(currentUserId);
    if (sentToday >= 2) {
      Get.snackbar(
        'Limit Reached',
        'You have reached your 2 messages daily limit.',
        snackPosition: SnackPosition.BOTTOM,
      );
      remainingMessages.value = 0;
      return;
    }

    isUploading.value = true;
    String? mediaUrl;

    try {
      if (hasAttachment) {
        final authRepo = AuthRepository();
        final uploadResponse = await authRepo.uploadFile(
          filePath: pickedFilePath.value!,
        );
        if (uploadResponse.success && uploadResponse.data != null) {
          mediaUrl = uploadResponse.data!['url'] as String?;
        } else {
          Get.snackbar(
            'error'.tr,
            uploadResponse.message ?? 'failed_to_upload_photo'.tr,
            snackPosition: SnackPosition.BOTTOM,
          );
          isUploading.value = false;
          return;
        }
      }

      messageController.clear();
      final finalType = pickedFileType.value ?? 'TEXT';
      final finalSize = pickedFileSize.value;
      clearAttachment();

      final response = await _chatRepo.sendChatMessage(
        message: text.isNotEmpty ? text : null,
        mediaUrl: mediaUrl,
        mediaType: finalType,
        fileSize: finalSize,
        messageType: messageType.value,
      );

      if (response.success && response.data != null) {
        await _storage.incrementDailyChatCount(currentUserId);
        _updateRemainingMessages();
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
    } finally {
      isUploading.value = false;
    }
  }

  /// Start a private chat with the sender of a Give/Take bubble
  Future<void> startPrivateChat({
    required String senderId,
    required String senderName,
    String? senderAvatar,
  }) async {
    if (senderId == currentUserId) {
      Get.snackbar(
        'Notice',
        'You cannot message yourself.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    try {
      final privateChatRepo = PrivateChatRepository();
      final response = await privateChatRepo.startConversation(
        receiverId: senderId,
      );

      if (response.success && response.data != null) {
        final conversationId = response.data!;
        Get.toNamed(
          '/private-chat/$conversationId',
          arguments: {
            'otherUser': PrivateChatUser(
              userId: senderId,
              name: senderName,
              avatar: senderAvatar,
            ),
          },
        );
      } else {
        Get.snackbar(
          'Error',
          response.message ?? 'Failed to start private chat',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
