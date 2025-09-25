import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/app_theme.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool centerTitle;
  final Color backgroundColor;
  final Color titleColor;
  final bool leading;

  const CommonAppBar({
    super.key,
    required this.title,
    this.actions,
    this.centerTitle = true,
    this.backgroundColor = AppColors.background,
    this.titleColor = AppColors.white,
    this.leading = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: AppTextStyles.heading2),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      elevation: 0,
      actions: actions,
      // leading: leading ? InkWell(onTap: () => Get.back(), child: Icon(Icons.arrow_back, color: AppColors.white)) : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
