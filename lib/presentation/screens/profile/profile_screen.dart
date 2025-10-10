import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_flow/presentation/screens/notification_screen/notification_screen.dart';
import 'package:task_flow/presentation/screens/setttings/settings_screen.dart';
import '../../../data/model/task_model.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/use_cases/get_user_details_use_case.dart';
import '../add_new_task/controller/task_service_controller.dart';
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
  final String? userId = FirebaseAuth.instance.currentUser?.uid;
  final TaskService _taskService = TaskService();

  final ProfileController controller = Get.put(
    ProfileController(GetUserDetailsUseCase(UserRepositoryImpl()), UpdateUserDetailsUseCase(UserRepositoryImpl())),
    permanent: true,
  );

  @override
  void initState() {
    super.initState();
    controller.fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: CommonAppBar(
          title: "👤 Profile",
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Get.to(UserDetailsScreen());
                },
              ),
            ),
          ],
        ),
        body:
            controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: StreamBuilder<List<TaskModel>>(
                      stream: _taskService.getTasksForUser(""),
                      builder: (context, snapshot) {
                        final tasks = snapshot.data ?? [];
                        final total = tasks.length;
                        final completed = tasks.where((t) => t.status == 'completed').length;
                        final productivityScore = total > 0 ? ((completed / total) * 100).round() : 0;

                        return Column(
                          children: [
                            SizedBox(height: Get.height * 0.020),
                            Center(
                              child: CircleAvatar(
                                maxRadius: 40,
                                backgroundColor: AppColors.primary,
                                child: Text(_getInitials(controller.name.value), style: AppTextStyles.heading1.copyWith(color: Colors.white)),
                              ),
                            ),
                            SizedBox(height: Get.height * 0.020),
                            Text(controller.name.value.isNotEmpty ? controller.name.value : "No Name", style: AppTextStyles.heading1),
                            SizedBox(height: Get.height * 0.010),
                            Text(user?.email ?? "No email found", style: AppTextStyles.caption.copyWith(fontSize: 17)),
                            SizedBox(height: Get.height * 0.070),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text("This Week's Stats", style: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(height: Get.height * 0.020),
                            _buildStatRow("Tasks Completed", completed.toString()),
                            _buildStatRow("Productivity Score", "$productivityScore%", isGreen: true),
                            _buildStatRow("Active Days", "5/7"),
                            SizedBox(height: Get.height * 0.050),
                            _buildMenuItem(
                              text: "⚙️ Settings",
                              onTap: () {
                                Get.to(SettingsScreen());
                              },
                            ),
                            _buildMenuItem(text: "📊 Analytics", onTap: () {}),
                            _buildMenuItem(
                              text: "🔔 Notifications",
                              onTap: () {
                                Get.to(NotificationScreen());
                              },
                            ),
                            _buildMenuItem(text: "❓ Help & Support", onTap: () {}),
                            _buildMenuItem(
                              text: "🚪 Logout",
                              onTap: () async {
                                if (userId != null) {
                                  await FirebaseFirestore.instance.collection('users').doc(userId).update({'fcmToken': FieldValue.delete()});
                                }

                                await FirebaseMessaging.instance.deleteToken();
                                await FirebaseAuth.instance.signOut();
                                Get.offAll(() => LoginScreen());
                              },

                              showDivider: false,
                              color: AppColors.error,
                            ),
                            SizedBox(height: Get.height * 0.10),
                          ],
                        );
                      },
                    ),
                  ),
                ),
      ),
    );
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
