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

  // Subscribe to socket events
  void on(String event, Function(dynamic) handler) {
    _socket?.on(event, handler);
  }

  // Unsubscribe from socket events
  void off(String event, [Function(dynamic)? handler]) {
    _socket?.off(event, handler);
  }
}
