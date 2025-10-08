import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_flow/presentation/screens/user_details_screen/user_details_screen.dart';
import 'package:task_flow/presentation/theme/theme_controller.dart';
import '../../common_widgets/appbar.dart';
import '../../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  Rx isDarkMode = false.obs;
  bool autoSync = true;
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: "⚙️ Settings"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: ListView(
          children: [
            _buildSectionTitle("Account"),
            _buildTile(
              icon: Icons.person_outline,
              title: "Edit Profile",
              subtitle: "Update your name or details",
              onTap: () => Get.to(UserDetailsScreen()),
            ),
            _buildTile(
              icon: Icons.lock_outline,
              title: "Change Password",
              subtitle: "Reset or update your password",
              onTap: () => Get.snackbar("Change Password", "Feature under development"),
            ),
            const Divider(),

            _buildSectionTitle("Preferences"),
            _buildSwitchTile(
              icon: Icons.notifications_outlined,
              title: "Enable Notifications",
              value: notificationsEnabled,
              onChanged: (v) => setState(() => notificationsEnabled = v),
            ),

            Obx(
              () => SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Dark Mode"),
                value: themeController.isDarkMode.value,
                onChanged: (val) => themeController.toggleTheme(),
                secondary: const Icon(Icons.dark_mode),
              ),
            ),
            _buildSwitchTile(icon: Icons.sync_outlined, title: "Auto Sync Data", value: autoSync, onChanged: (v) => setState(() => autoSync = v)),
            const Divider(),

            _buildSectionTitle("About"),
            _buildTile(icon: Icons.info_outline, title: "App Version", subtitle: "v1.0.0", onTap: () {}),
            _buildTile(
              icon: Icons.privacy_tip_outlined,
              title: "Privacy Policy",
              subtitle: "Read how we protect your data",
              onTap: () => Get.snackbar("Privacy Policy", "Feature under development",duration: Duration(seconds: 1)),
            ),
            _buildTile(
              icon: Icons.description_outlined,
              title: "Terms & Conditions",
              subtitle: "View usage policies",
              onTap: () => Get.snackbar("Terms & Conditions", "Feature under development",duration: Duration(seconds: 1)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(title, style: AppTextStyles.body.copyWith(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
    );
  }

  Widget _buildTile({required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({required IconData icon, required String title, required bool value, required ValueChanged<bool> onChanged}) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      secondary: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      value: value,
      onChanged: onChanged,
    );
  }
}
