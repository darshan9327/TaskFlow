import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_flow/domain/model/task_model.dart';
import 'package:task_flow/domain/use_cases/task_service_use_case.dart';
import 'package:task_flow/presentation/common_widgets/list_tile.dart';
import 'package:task_flow/presentation/screens/add_new_task/add_task_screen.dart';
import 'package:task_flow/presentation/screens/task_list/task_list_screen.dart';
import 'package:task_flow/presentation/screens/profile/profile_screen.dart';
import '../../../domain/repositories/auth_repository_impl.dart';
import '../../../domain/use_cases/get_user_details_usecase.dart';
import '../../common_widgets/appbar.dart';
import '../../common_widgets/task_tile.dart';
import '../../theme/app_theme.dart';
import '../task_detail_screen/task_detail_screen.dart';
import '../user_details_screen/controller/user_profile_controller.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final ProfileController controller = Get.put(
    ProfileController(
      GetUserDetailsUseCase(UserRepositoryImpl()),
      UpdateUserDetailsUseCase(UserRepositoryImpl()),
    ),
  );

  final TaskService _taskService = TaskService();
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    controller.fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: "🔐 Dashboard",
        actions: [
          InkWell(
              onTap: () => Get.to(ProfileScreen()),
              child: const Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: Icon(Icons.person))),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.secondary,
        onPressed: () => Get.to(() => const AddTaskScreen()),
        child: const Icon(Icons.add, color: AppColors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              CommonListTile(
                title: "Good Morning!",
                subtitle: controller.name.value.isNotEmpty
                    ? controller.name.value
                    : "No Name",
                text: "🔔",
                onTap: () {},
              ),
              const SizedBox(height: 20),
              StreamBuilder<List<TaskModel>>(
                stream: _taskService.getTasks(userId: userId ?? ''),
                builder: (context, snapshot) {
                  final tasks = snapshot.data ?? [];
                  final total = tasks.length;
                  final completed = tasks.where((t) => t.status == 'completed').length;
                  final pending = tasks.where((t) => t.status == 'pending').length;
                  final todaysTasks = tasks.where((t) => isToday(t.dueDate)).toList();

                  return Column(
                    children: [
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        childAspectRatio: 1.5,
                        children: [
                          StatCard(
                              title: "Total Tasks",
                              value: total.toString(),
                              onPressed: () => Get.to(() => TaskListScreen(),
                                  arguments: 0)),
                          StatCard(
                              title: "Completed",
                              value: completed.toString(),
                              onPressed: () => Get.to(() => TaskListScreen(),
                                  arguments: 2)),
                          StatCard(
                              title: "Pending",
                              value: pending.toString(),
                              onPressed: () => Get.to(() => TaskListScreen(),
                                  arguments: 1)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text("Today's Tasks", style: AppTextStyles.body),
                      ),
                      const SizedBox(height: 8),
                      if (todaysTasks.isEmpty)
                        const Text("No tasks for today")
                      else
                        ...todaysTasks.map((task) => TaskCard(
                          title: task.title,
                          time: task.dueDate,
                          color: task.status == 'completed'
                              ? Colors.green
                              : Colors.orange,
                          status: task.status,
                          onTap: () => Get.to(() => TaskDetailScreen(task: task)),
                        )),
                    ],
                  );
                },
              ),

              const  SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback? onPressed;

  const StatCard(
      {super.key, required this.title, required this.value, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xff2575fc), Color(0xff6a11cb)],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(value,
                  style: AppTextStyles.heading1.copyWith(color: AppColors.white)),
              const SizedBox(height: 4),
              Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
bool isToday(String dueDateTime) {
  if (dueDateTime.isEmpty) return false;

  final datePart = dueDateTime.split('•')[0].trim();
  final parts = datePart.split('/');

  if (parts.length != 3) return false;

  final day = int.tryParse(parts[0]) ?? 0;
  final month = int.tryParse(parts[1]) ?? 0;
  final year = int.tryParse(parts[2]) ?? 0;

  final taskDate = DateTime(year, month, day);
  final today = DateTime.now();

  return taskDate.year == today.year &&
      taskDate.month == today.month &&
      taskDate.day == today.day;
}

