import 'package:app_settings/app_settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('📩 Background message received: ${message.notification?.title}');
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  /// 🔹 Initialize FCM + Local Notifications
  Future<void> initNotifications() async {
    await Firebase.initializeApp();

    // Background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Request permissions
    await _requestPermission();

    // Init local notifications
    await _initLocalNotifications();

    // Get FCM token
    String? token = await _firebaseMessaging.getToken();
    print('🔑 FCM Token: $token');

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('📱 Foreground message: ${message.notification?.title}');
      await _showNotification(message);
    });

    // When user taps a notification (terminated/background)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('🟢 Notification clicked: ${message.notification?.title}');
      _handleNotificationClick(message);
    });
  }

  /// 🔸 Request permission for Android 13+
  Future<void> _requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ Notification permission granted');
    } else {
      Get.snackbar(
        'Notifications Disabled',
        'Please enable notifications from settings',
        snackPosition: SnackPosition.BOTTOM,
      );

      Future.delayed(const Duration(seconds: 2), () {
        AppSettings.openAppSettings(type: AppSettingsType.notification);
      });
    }
  }

  /// 🔸 Initialize local notification plugin
  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher'); // ✅ Use valid icon

    const InitializationSettings initSettings =
    InitializationSettings(android: androidSettings);

    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        print('🧭 Notification tapped: ${response.payload}');
      },
    );

    // ✅ Create Notification Channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'taskflow_channel',
      'TaskFlow Notifications',
      description: 'TaskFlow notification channel',
      importance: Importance.high,
    );

    final androidPlugin =
    _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(channel);
  }

  /// 🔸 Show local notification when app is in foreground
  Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'taskflow_channel',
      'TaskFlow Notifications',
      channelDescription: 'TaskFlow Alerts',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      ticker: 'ticker',
    );

    const NotificationDetails platformDetails =
    NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? 'New Notification',
      message.notification?.body ?? '',
      platformDetails,
      payload: message.data.toString(),
    );
  }

  /// 🔸 Handle notification click
  void _handleNotificationClick(RemoteMessage message) {
    final title = message.notification?.title ?? 'Notification';
    final body = message.notification?.body ?? '';

    Get.snackbar(
      title,
      body,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.blueGrey.shade700,
      colorText: Colors.white,
    );
  }

  /// 🔸 Optional: Get device FCM token
  Future<String?> getDeviceToken() async {
    return await _firebaseMessaging.getToken();
  }
}
