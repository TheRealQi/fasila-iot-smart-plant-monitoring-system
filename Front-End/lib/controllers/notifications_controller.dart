import 'dart:convert';
import 'package:fasila/mixins/auth_mixin.dart';
import 'package:fasila/shared_pref.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class NotificationController extends GetxController with AuthMixin {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final Rx<String?> _currentToken = Rx<String?>(null);
  final RxBool _isTokenSynced = RxBool(false);
  final RxList<RemoteMessage> _receivedMessages = RxList<RemoteMessage>();

  String? get currentToken => _currentToken.value;

  bool get isTokenSynced => _isTokenSynced.value;

  List<RemoteMessage> get receivedMessages => _receivedMessages;
  final String url = dotenv.env['API_URL']!;

  @override
  void onInit() {
    super.onInit();
    _initTokenHandling();
    _initNotificationHandling();
  }

  Future<void> _initTokenHandling() async {
    try {
      final lastToken =
          CacheHelper.getDataFromSharedPrefrence('last_fcm_token');
      final token = await _firebaseMessaging.getToken();
      if (token != null && token != lastToken) {
        await _handleTokenRefresh(token);
      }
      _firebaseMessaging.onTokenRefresh.listen((newToken) async {
        if (newToken != lastToken) {
          await _handleTokenRefresh(newToken);
        } else {}
      });
      if (!_isTokenSynced.value) {
        _sendTokenToServer(token!);
      }
    } catch (e) {}
  }

  Future<void> _initNotificationHandling() async {
    // Request permission with provisional authorization for iOS
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: true, // Enable provisional authorization on iOS
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      // Configure foreground notification presentation options
      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // Android initialization settings with high importance channel
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        importance: Importance.max,
        enableVibration: true,
        showBadge: true,
        enableLights: true,
      );

      // Create the Android notification channel
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      final InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
      );

      await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _handleNotificationTap,
      );

      // Listen for foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      // Handle initial message if app was terminated
      final initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        _handleInitialMessage(initialMessage);
      }
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    _receivedMessages.add(message);

    final notification = message.notification;
    final android = message.notification?.android;
    final apple = message.notification?.apple;

    if (notification != null) {
      _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title ?? '',
        notification.body ?? '',
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription: 'This channel is used for important notifications',
            importance: Importance.max,
            priority: Priority.max,
            showWhen: true,
            enableVibration: true,
            enableLights: true,
            playSound: true,
            icon: android?.smallIcon ?? '@mipmap/ic_launcher',
            channelShowBadge: true,
            largeIcon: android?.smallIcon != null ? FilePathAndroidBitmap(android!.smallIcon!) : null,
            sound: android?.sound != null ? RawResourceAndroidNotificationSound(android!.sound!) : null,
          ),
        ),
        payload: jsonEncode(message.data),
      );
    }
  }

  void _showLocalNotification(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    _flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription: 'This channel is used for important notifications',
          importance: Importance.max,
          priority: Priority.max,
          enableVibration: true,
          playSound: true,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }

  void _handleNotificationTap(NotificationResponse details) {
    if (details.payload != null) {
      final payload = jsonDecode(details.payload!);
      print("Notification tapped with payload: $payload");
      if (details.notificationResponseType ==
          NotificationResponseType.selectedNotification) {
        _processNotification(payload);
      }
    }
  }

  void _handleInitialMessage(RemoteMessage message) {
    if (message != null) {
      _processNotification(message.data);
    }
  }

  void _processNotification(Map<String, dynamic> data) {
    if (data['type'] == 'device_alert') {
      print("Device Alert: ${data['device_id']}");
    } else {
      print("Other Notification: ${data}");
    }
  }

  void _navigateBasedOnNotification(Map<String, dynamic> data) {
    switch (data['type']) {
      case 'device_alert':
        Get.toNamed('/device-details', arguments: data['device_id']);
        break;
      case 'system_update':
        Get.toNamed('/system-updates');
        break;
      default:
        Get.toNamed('/notifications');
    }
  }

  Future<void> _handleTokenRefresh(String token) async {
    try {
      _currentToken.value = token;
      await CacheHelper.saveDataToSharedPrefrence('last_fcm_token', token);
      await _sendTokenToServer(token);
    } catch (e) {}
  }

  Future<void> _sendTokenToServer(String token) async {
    try {
      final response = await http.post(
        Uri.parse("$url/users/fcm/add-token/"),
        headers: {
          'Authorization': 'Bearer ${await getToken()}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'user_id': CacheHelper.getDataFromSharedPrefrence('user_id'),
          'fcm_token': token,
        }),
      );
      if (response.statusCode == 200) {
        _isTokenSynced.value = true;
      } else {
        _isTokenSynced.value = false;
      }
    } catch (e) {
      _isTokenSynced.value = false;
    }
  }

  Future<void> _deleteTokenFromServer(String token) async {
    try {
      final response = await http.delete(
        Uri.parse("$url/users/fcm/delete-token/"),
        headers: {
          'Authorization': 'Bearer ${await getToken()}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'user_id': CacheHelper.getDataFromSharedPrefrence('user_id'),
          'fcm_token': token,
        }),
      );

      if (response.statusCode == 200) {
      } else {
        print(
            'Failed to delete token from server. Status code: ${response.statusCode}');
      }
    } catch (e) {}
  }

  Future<void> deleteCurrentToken() async {
    if (_currentToken.value != null) {
      await _deleteTokenFromServer(_currentToken.value!);
      await CacheHelper.removeData(key: 'last_fcm_token');
      _currentToken.value = null;
      _isTokenSynced.value = false;
    }
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {}
}
