import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2196F3);
  static const Color secondary = Color(0xFF4CAF50);
  static const Color third = Color(0xFF6f7b85);
  static const Color accent = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color background = Color(0xFFF5F5F5);
  static const Color text = Color(0xFF212121);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
}

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.text);

  static const TextStyle heading2 = TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.text);

  static const TextStyle heading3 = TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.text);

  static const TextStyle heading4 = TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.text);

  static const TextStyle body = TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: AppColors.text);

  static const TextStyle caption = TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: AppColors.text);

  static const TextStyle small = TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: AppColors.text);
}
