import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../../../firebase_options.dart';
import '../repositories/auth_repository.dart';
import 'storage_service.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('Handling a background message: ${message.messageId}');
}

class FirebaseNotificationService extends GetxService {
  static FirebaseNotificationService get to => Get.find();

  final _authRepo = AuthRepository();
  bool _isInitialized = false;

  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
    playSound: true,
  );

  bool get isInitialized => _isInitialized;

  Future<FirebaseNotificationService> init() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _isInitialized = true;
      debugPrint('Firebase Notification Service successfully initialized.');

      // Initialize Flutter Local Notifications
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings initializationSettingsDarwin =
          DarwinInitializationSettings();

      const InitializationSettings initializationSettings =
          InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
          );

      await _localNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse details) {
          debugPrint('Local notification clicked: ${details.payload}');
        },
      );

      // Create high importance channel for Android
      await _localNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(_channel);

      // Presentation options for foreground iOS notifications
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
            alert: true,
            badge: true,
            sound: true,
          );

      // Set the background messaging handler early on, as a named top-level function
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );

      // Request permissions
      await requestPermission();

      // Setup notification handling callbacks
      _setupMessagingCallbacks();
    } catch (e) {
      debugPrint(
        'Firebase failed to initialize. Push notifications will not be active. '
        'Please ensure google-services.json is correctly placed in android/app/. Error: $e',
      );
    }
    return this;
  }

  /// Request permissions for iOS and Android 13+ devices
  Future<void> requestPermission() async {
    if (!_isInitialized) return;

    try {
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      debugPrint('User granted permission: ${settings.authorizationStatus}');
    } catch (e) {
      debugPrint('Failed to request notification permission: $e');
    }
  }

  /// Get and upload FCM token to the server
  Future<void> uploadFcmToken() async {
    if (!_isInitialized) return;

    try {
      // Check if user is logged in
      final storage = Get.find<StorageService>();
      if (storage.authToken == null || storage.authToken!.isEmpty) {
        debugPrint('Skip uploading FCM token: User is not authenticated.');
        return;
      }

      final user = storage.currentUser;
      if (user == null) {
        debugPrint('Skip uploading FCM token: No user data found.');
        return;
      }

      final token = await FirebaseMessaging.instance.getToken();
      if (token == null) {
        debugPrint('FCM Token is null.');
        return;
      }

      debugPrint('FCM Token retrieved: $token');

      // Update backend via user update endpoint (userId is required by validation)
      final response = await _authRepo.updateUser({
        'userId': user.id,
        'deviceToken': token,
      });

      if (response.success) {
        debugPrint('FCM Token successfully synced with backend.');
      } else {
        debugPrint(
          'Failed to sync FCM Token with backend: ${response.message}',
        );
      }
    } catch (e) {
      debugPrint('Error getting or uploading FCM Token: $e');
    }
  }

  /// Configure listeners for message reception
  void _setupMessagingCallbacks() {
    if (!_isInitialized) return;

    // Listen to token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      debugPrint('FCM Token refreshed: $newToken');
      uploadFcmToken();
    });

    // Handle messages when app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Received foreground message: ${message.notification?.title}');

      final notification = message.notification;
      final android = message.notification?.android;

      if (notification != null) {
        _localNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _channel.id,
              _channel.name,
              channelDescription: _channel.description,
              icon: android?.smallIcon ?? '@mipmap/ic_launcher',
              importance: Importance.max,
              priority: Priority.high,
              playSound: true,
            ),
            iOS: const DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          payload: message.data.toString(),
        );
      }

      final title = message.notification?.title ?? 'Notification';
      final body = message.notification?.body ?? '';

      if (Get.context != null) {
        Get.snackbar(
          title,
          body,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Theme.of(
            Get.context!,
          ).colorScheme.primaryContainer.withValues(alpha: 0.9),
          colorText: Theme.of(Get.context!).colorScheme.onPrimaryContainer,
          margin: const EdgeInsets.all(12),
          borderRadius: 16,
          duration: const Duration(seconds: 4),
          icon: Icon(
            Icons.notifications_active,
            color: Theme.of(Get.context!).colorScheme.primary,
          ),
        );
      }
    });

    // Handle user tapping the notification when the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint(
        'Notification clicked (App was in background): ${message.data}',
      );
      _handleNotificationClick(message.data);
    });

    // Check if app was opened from a terminated state via a notification click
    FirebaseMessaging.instance.getInitialMessage().then((
      RemoteMessage? message,
    ) {
      if (message != null) {
        debugPrint(
          'Notification clicked (App was terminated): ${message.data}',
        );
        _handleNotificationClick(message.data);
      }
    });
  }

  /// Route the user or trigger action based on custom payload data
  void _handleNotificationClick(Map<String, dynamic> data) {
    // Implement custom routing if your payloads contain screen/route information.
    // Example:
    // if (data.containsKey('route')) {
    //   Get.toNamed(data['route']);
    // }
  }
}
