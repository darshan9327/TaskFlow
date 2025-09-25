import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_flow/presentation/screens/login_screen/login_screen.dart';
import 'package:task_flow/presentation/screens/profile/profile_screen.dart';

import 'presentation/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        textTheme: const TextTheme(bodyLarge: TextStyle(color: AppColors.text), bodyMedium: TextStyle(color: AppColors.text)),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          onTertiary: AppColors.third,
          secondary: AppColors.secondary,
          error: AppColors.error,
          surface: AppColors.background,
        ),
      ),
      home: LoginScreen(),
    );
  }
}
