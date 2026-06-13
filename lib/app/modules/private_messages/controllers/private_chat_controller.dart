import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../../data/models/private_conversation_model.dart';
import '../../../data/models/private_message_model.dart';
import '../../../data/repositories/private_chat_repository.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/services/socket_service.dart';
import '../../../data/services/storage_service.dart';

class PrivateChatController extends GetxController {
  final _chatRepo = PrivateChatRepository();
  final _socketService = Get.find<SocketService>();
  final _storage = Get.find<StorageService>();

  final messageType = MessageType.text.obs;
  final messages = <PrivateMessage>[].obs;

  // Attachment States
  final pickedFilePath = RxnString();
  final pickedFileType = RxnString(); // 'IMAGE' or 'FILE'
  final pickedFileSize = 0.obs;
  final pickedFileName = RxnString();
  final isUploading = false.obs;

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
    if (otherUser.value == null) return;

    isUploading.value = true;
    String? mediaUrl;

    try {
      if (hasAttachment) {
        final authRepo = AuthRepository();
        final uploadResponse = await authRepo.uploadFile(filePath: pickedFilePath.value!);
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

      // Emit via Socket.IO for real-time delivery
      _socketService.sendPrivateMessage(
        conversationId: conversationId,
        receiverId: otherUser.value!.userId,
        message: text.isNotEmpty ? text : null,
        messageType: messageType.value.name,
        mediaUrl: mediaUrl,
        mediaType: finalType,
        fileSize: finalSize,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send message',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isUploading.value = false;
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
