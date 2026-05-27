import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;
import '../../../core/config/app_config.dart';
import 'storage_service.dart';

class SocketService extends GetxService {
  socket_io.Socket? _socket;
  final RxBool connected = false.obs;

  socket_io.Socket? get socket => _socket;

  Future<SocketService> init() async {
    if (kDebugMode) {
      print('SocketService initialized');
    }
    return this;
  }

  void connect() {
    if (_socket != null && _socket!.connected) {
      if (kDebugMode) print('Socket already connected');
      return;
    }

    final storage = Get.find<StorageService>();
    final token = storage.authToken;

    if (token == null || token.isEmpty) {
      if (kDebugMode) {
        print('Socket: Cannot connect, authToken is null or empty');
      }
      return;
    }

    if (kDebugMode) {
      print('Socket: Connecting to ${AppConfig.baseUrl}...');
    }

    // Configure and create socket connection
    _socket = socket_io.io(
      AppConfig.baseUrl,
      socket_io.OptionBuilder()
          .setTransports(['websocket', 'polling'])
          .disableAutoConnect()
          .setAuth({'token': 'Bearer $token'})
          .build(),
    );

    // Event Bindings
    _socket!.onConnect((_) {
      connected.value = true;
      if (kDebugMode) {
        print('Socket: Connected successfully');
      }
    });

    _socket!.onDisconnect((_) {
      connected.value = false;
      if (kDebugMode) {
        print('Socket: Disconnected');
      }
    });

    _socket!.onConnectError((data) {
      if (kDebugMode) {
        print('Socket: Connection error - $data');
      }
    });

    _socket!.onError((data) {
      if (kDebugMode) {
        print('Socket: Error - $data');
      }
    });

    // In-app notifications listener for private messages
    _socket!.on('private_message_notification', (data) {
      if (kDebugMode) {
        print('Socket: private_message_notification received - $data');
      }
      try {
        if (data is Map<String, dynamic>) {
          final conversationId = data['conversationId'] as String?;
          final senderData = data['sender'] as Map<String, dynamic>?;
          final senderName = data['senderName'] as String? ?? 
              (senderData != null ? senderData['name'] as String? : null) ?? 
              'New Message';
          final message = data['message'] as String? ?? '';
          final messageType = data['messageType'] as String? ?? 'text';

          // Show in-app banner if user is not looking at this conversation
          final currentRoute = Get.currentRoute;
          final isInThisPrivateChat = currentRoute.contains('/private-chat/') && 
              currentRoute.endsWith(conversationId ?? '');

          if (!isInThisPrivateChat) {
            Get.snackbar(
              senderName,
              messageType == 'give'
                  ? '🎁 GIVE: $message'
                  : messageType == 'take'
                      ? '🤝 TAKE: $message'
                      : message,
              snackPosition: SnackPosition.TOP,
              backgroundColor: Get.theme.cardColor.withValues(alpha: 0.95),
              colorText: Get.theme.textTheme.bodyLarge?.color,
              margin: const EdgeInsets.all(12),
              borderRadius: 16,
              duration: const Duration(seconds: 4),
              mainButton: TextButton(
                onPressed: () {
                  Get.back(); // Dismiss snackbar
                  if (conversationId != null) {
                    Get.toNamed('/private-chat/$conversationId');
                  }
                },
                child: const Text('Reply'),
              ),
              icon: Icon(
                Icons.chat_bubble_outline_rounded,
                color: Get.theme.primaryColor,
              ),
            );
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error handling private message notification: $e');
        }
      }
    });

    _socket!.connect();
  }

  void disconnect() {
    if (_socket != null) {
      if (kDebugMode) {
        print('Socket: Disconnecting manually...');
      }
      _socket!.disconnect();
      _socket = null;
    }
    connected.value = false;
  }

  // Private Chat Rooms
  void joinPrivateRoom(String conversationId) {
    if (_socket != null && _socket!.connected) {
      _socket!.emit('join_private_room', {'conversationId': conversationId});
    }
  }

  // Send Private Message
  void sendPrivateMessage({
    required String conversationId,
    required String receiverId,
    String? message,
    required String messageType,
    String? mediaUrl,
    String? mediaType,
    int? fileSize,
  }) {
    if (_socket != null && _socket!.connected) {
      _socket!.emit('send_private_message', {
        'conversationId': conversationId,
        'receiverId': receiverId,
        'message': message,
        'messageType': messageType,
        'mediaUrl': mediaUrl,
        'mediaType': mediaType,
        'fileSize': fileSize,
      });
    }
  }

  // Subscribe to socket events
  void on(String event, Function(dynamic) handler) {
    _socket?.on(event, handler);
  }

  // Unsubscribe from socket events
  void off(String event, [Function(dynamic)? handler]) {
    _socket?.off(event, handler);
  }
}
