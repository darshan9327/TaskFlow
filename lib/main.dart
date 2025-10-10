import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:task_flow/domain/services/notification_service.dart';
import 'package:task_flow/domain/services/fcm_service.dart';
import 'package:task_flow/firebase_options.dart';
import 'package:task_flow/presentation/theme/theme_controller.dart';
import 'package:task_flow/presentation/theme/app_theme.dart';
import 'data/wrapper/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final currentUserId = FirebaseAuth.instance.currentUser?.uid;
  if (currentUserId != null) {
    final fcmService = FcmTokenService();
    await fcmService.saveTokenToFirestore(currentUserId);
    // fcmService.handleTokenRefresh(currentUserId);
  }

  // Initialize notifications
  final notificationService = NotificationService();
  await notificationService.initNotifications();

  final themeController = Get.put(ThemeController());
  runApp(MyApp(themeController: themeController));
}

class MyApp extends StatelessWidget {
  final ThemeController? themeController;
  const MyApp({super.key, this.themeController});

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Task Flow',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeController!.isDarkMode.value
            ? ThemeMode.dark
            : ThemeMode.light,
        home: const Wrapper(),
      ),
    );
  }
}
