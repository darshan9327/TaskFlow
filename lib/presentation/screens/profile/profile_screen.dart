import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_flow/presentation/common_widgets/appbar.dart';
import 'package:task_flow/presentation/screens/login_screen/login_screen.dart';
import 'package:task_flow/presentation/theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "👤 Profile"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            SizedBox(height: Get.height * 0.020),
            Center(
              child: CircleAvatar(
                maxRadius: 40,
                backgroundColor: AppColors.primary,
                child: Text("JD", style: AppTextStyles.heading1.copyWith(color: Colors.white)),
              ),
            ),
            SizedBox(height: Get.height * 0.020),
            Text("John Doe", style: AppTextStyles.heading1),
            SizedBox(height: Get.height * 0.010),
            Text("john.doe@company.com", style: AppTextStyles.caption.copyWith(fontSize: 17)),
            SizedBox(height: Get.height * 0.070),
            Align(
              alignment: Alignment.topLeft,
              child: Text("This Week's Stats", style: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: Get.height * 0.020),
            _buildStatRow("Tasks Completed", "15"),
            _buildStatRow("Productivity Score", "85%", isGreen: true),
            _buildStatRow("Active Days", "5/7"),
            SizedBox(height: Get.height * 0.050),
            _buildMenuItem(text: "⚙️  Settings", onTap: () {}),
            _buildMenuItem(text: "📊  Analytics", onTap: () {}),
            _buildMenuItem(text: "🔔  Notifications", onTap: () {}),
            _buildMenuItem(text: "❓  Help & Support", onTap: () {}),
            _buildMenuItem(
              text: "🚪  Logout",
              onTap: () {
                Get.offAll(LoginScreen());
              },
              showDivider: false,
              color: AppColors.error,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String title, String value, {bool isGreen = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 17, color: Colors.black54)),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: isGreen ? Colors.green : Colors.black)),
        ],
      ),
    );
  }

  Widget _buildMenuItem({required String text, required VoidCallback onTap, Color color = Colors.black, bool showDivider = true}) {
    return Column(
      children: [
        ListTile(title: Text(text, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w500)), onTap: onTap),
        if (showDivider) Divider(thickness: 0.8, color: Colors.grey[300]),
      ],
    );
  }
}
