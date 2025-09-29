import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../domain/repositories/auth_repository_impl.dart';
import '../../../domain/use_cases/get_user_details_usecase.dart';
import '../../common_widgets/appbar.dart';
import '../../theme/app_theme.dart';
import '../login_screen/login_screen.dart';
import '../user_details_screen/controller/user_profile_controller.dart';
import '../user_details_screen/user_details_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;

  final ProfileController controller = Get.put(
    ProfileController(
      GetUserDetailsUseCase(UserRepositoryImpl()),
      UpdateUserDetailsUseCase(UserRepositoryImpl()),
    ),
  );

  @override
  void initState() {
    super.initState();
    controller.fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      appBar: CommonAppBar(
        title: "👤 Profile",
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: InkWell(
              onTap: () {
                Get.to(UserDetailsScreen());
              },
              child: const Icon(Icons.edit),
            ),
          ),
        ],
      ),
      body: controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              SizedBox(height: Get.height * 0.020),
              Center(
                child: CircleAvatar(
                  maxRadius: 40,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    _getInitials(controller.name.value),
                    style: AppTextStyles.heading1
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.020),
              Text(
                controller.name.value.isNotEmpty
                    ? controller.name.value
                    : "No Name",
                style: AppTextStyles.heading1,
              ),
              SizedBox(height: Get.height * 0.010),
              Text(
                user?.email ?? "No email found",
                style: AppTextStyles.caption.copyWith(fontSize: 17),
              ),
              SizedBox(height: Get.height * 0.070),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "This Week's Stats",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: Get.height * 0.020),
              _buildStatRow("Tasks Completed", "15"),
              _buildStatRow("Productivity Score", "85%", isGreen: true),
              _buildStatRow("Active Days", "5/7"),
              SizedBox(height: Get.height * 0.050),
              _buildMenuItem(text: "⚙️ Settings", onTap: () {}),
              _buildMenuItem(text: "📊 Analytics", onTap: () {}),
              _buildMenuItem(text: "🔔 Notifications", onTap: () {}),
              _buildMenuItem(text: "❓ Help & Support", onTap: () {}),
              _buildMenuItem(
                text: "🚪 Logout",
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Get.offAll(() => LoginScreen());
                },
                showDivider: false,
                color: AppColors.error,
              ),
            ],
          ),
        ),
      ),
    ));
  }

  String _getInitials(String name) {
    if (name.isEmpty) return "";
    final parts = name.trim().split(" ");
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  Widget _buildStatRow(String title, String value, {bool isGreen = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 17, color: Colors.black54)),
          Text(value,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isGreen ? Colors.green : Colors.black)),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
      {required String text,
        required VoidCallback onTap,
        Color color = Colors.black,
        bool showDivider = true}) {
    return Column(
      children: [
        ListTile(
            title: Text(text,
                style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w500)),
            onTap: onTap),
        if (showDivider) Divider(thickness: 0.8, color: Colors.grey[300]),
      ],
    );
  }
}
