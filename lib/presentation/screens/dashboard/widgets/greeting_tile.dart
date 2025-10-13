import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_flow/presentation/screens/notifications/notification_screen.dart';

import '../../../common_widgets/list_tile.dart';

class GreetingTile extends StatelessWidget {
  final String name;
  final String role;

  const GreetingTile({super.key, required this.name, required this.role});

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return "Good Morning 🌅";
    if (hour >= 12 && hour < 17) return "Good Afternoon ☀️";
    if (hour >= 17 && hour < 21) return "Good Evening 🌇";
    return "Good Night 🌙";
  }

  @override
  Widget build(BuildContext context) {
    return CommonListTile(
      title: getGreeting(),
      subtitle: name.isNotEmpty ? "$name ($role)" : "No Name",
      text: "🔔",
      onTap: () {
        Get.to(NotificationScreen());
      },
    );
  }
}
