import 'package:flutter/material.dart';
import 'package:task_flow/presentation/theme/app_theme.dart';

class CommonContainer extends StatelessWidget {
  final String text;
  final Color? color;
  final VoidCallback onPressed;

  const CommonContainer({super.key, required this.text, this.color, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    double fontSize = screenWidth > 800 ? 18 : 16;
    double verticalPadding = screenWidth > 800 ? 16 : 10;
    double horizontalPadding = screenWidth > 800 ? 18 : 13;
    double borderRadius = screenWidth > 800 ? 13 : 8;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
        padding: EdgeInsets.symmetric(vertical: verticalPadding, horizontal: horizontalPadding),
      ),
      onPressed: onPressed,
      child: Center(child: Text(text, style: TextStyle(color: AppColors.white, fontSize: fontSize, fontWeight: FontWeight.w400))),
    );
  }
}
