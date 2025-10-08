import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_flow/domain/services/fcm_service.dart';
import 'package:task_flow/domain/services/notification_service.dart';

import '../../../data/model/task_model.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/use_cases/get_user_details_use_case.dart';
import '../../common_widgets/appbar.dart';
import '../../theme/app_theme.dart';
import '../add_new_task/add_task_screen.dart';
import '../add_new_task/controller/task_service_controller.dart';
import '../profile/profile_screen.dart';
import '../user_details_screen/controller/user_profile_controller.dart';
import 'widgets/greeting_tile.dart';
import 'widgets/task_stats_grid.dart';
import 'widgets/today_task_list.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final ProfileController controller = Get.put(
    ProfileController(GetUserDetailsUseCase(UserRepositoryImpl()), UpdateUserDetailsUseCase(UserRepositoryImpl())),
  );
  final TaskService _taskService = TaskService();
  final String? userId = FirebaseAuth.instance.currentUser?.uid;
  NotificationService notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    controller.fetchUser();
    notificationService.initNotifications();
    notificationService.getDeviceToken();
    FcmService.firebaseInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: "🔐 Dashboard",
        actions: [IconButton(icon: Icon(Icons.person), onPressed: () => Get.to(ProfileScreen()))],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.secondary,
        onPressed: () => Get.to(() => AddTaskScreen(userRole: controller.role.value)),
        child: const Icon(Icons.add, color: AppColors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            Obx(() => GreetingTile(name: controller.name.value, role: controller.role.value)),
            const SizedBox(height: 20),
            StreamBuilder<List<TaskModel>>(
              stream: _taskService.getTasksForAnyRole(userId ?? ''),
              builder: (context, snapshot) {
                final tasks = snapshot.data ?? [];
                return Column(
                  children: [
                    TaskStatsGrid(tasks: tasks, userId: userId ?? '', role: controller.role.value),
                    const SizedBox(height: 20),
                    TodaysTasksList(tasks: tasks),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
