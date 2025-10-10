import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:app_settings/app_settings.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('📩 Background message received: ${message.notification?.title}');
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  /// Initialize FCM + local notifications
  Future<void> initNotifications() async {
    await Firebase.initializeApp();

    // Background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Request permissions
    await _requestPermission();

    // Init local notifications
    await _initLocalNotifications();

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('📱 Foreground message: ${message.notification?.title}');
      await _showLocalNotification(message);
    });

    // Handle background/tap notifications
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationClick(message.data);
    });

    // Handle app launch via notification
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationClick(initialMessage.data);
    }
  }

  /// Request permission for Android 13+ / iOS
  Future<void> _requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      Get.snackbar(
        'Notifications Disabled',
        'Please enable notifications from settings',
        snackPosition: SnackPosition.BOTTOM,
      );

      Future.delayed(const Duration(seconds: 2), () {
        AppSettings.openAppSettings(type: AppSettingsType.notification);
      });
    } else {
      print('✅ Notification permission granted');
    }
  }

  /// Initialize local notifications plugin
  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
    InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null) {
          final data = Map<String, dynamic>.from(jsonDecode(response.payload!));
          _handleNotificationClick(data);
        }
      },
    );

    // Create notification channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'taskflow_channel',
      'TaskFlow Notifications',
      description: 'TaskFlow notification channel',
      importance: Importance.high,
    );

    final androidPlugin =
    _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(channel);
  }

  /// Show local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'taskflow_channel',
      'TaskFlow Notifications',
      channelDescription: 'TaskFlow Alerts',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails platformDetails =
    NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? 'New Notification',
      message.notification?.body ?? '',
      platformDetails,
      payload: jsonEncode(message.data),
    );
  }

  /// Handle notification click
  void _handleNotificationClick(Map<String, dynamic> data) {
    final taskId = data['taskId'];
    final type = data['type'];

    if (taskId != null) {
      Get.toNamed('/taskDetails', arguments: {'taskId': taskId, 'type': type});
    } else {
      Get.snackbar(
        data['title'] ?? 'Notification',
        data['body'] ?? '',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
