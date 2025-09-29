import 'package:flutter/material.dart';
import 'package:task_flow/presentation/theme/app_theme.dart';

class CommonListTile extends StatelessWidget {
  final String text;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const CommonListTile({super.key, required this.text, required this.title, this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(title, style: AppTextStyles.heading3.copyWith(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w400)),
        subtitle:
            subtitle == null
                ? null
                : Text(subtitle!, style: AppTextStyles.body.copyWith(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400)),
        trailing: SizedBox(
          width: 30,
          height: 30,
          child: InkWell(onTap: onTap, overlayColor: WidgetStateColor.transparent, child: Center(child: Text(text, style: TextStyle(fontSize: 20)))),
        ),
      ),
    );
  }
}
