import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:task_flow/presentation/screens/add_new_task/add_task_screen.dart';
import '../../../data/model/task_model.dart';
import '../add_new_task/controller/task_service_controller.dart';
import '../../common_widgets/appbar.dart';
import '../../common_widgets/task_tile.dart';
import '../../theme/app_theme.dart';
import '../task_detail_screen/task_detail_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TaskService _taskService = TaskService();

  final List<String> tabs = ['All', 'Pending', 'In Progress', 'Completed'];
  final String? userId = FirebaseAuth.instance.currentUser?.uid;
  final currentUser = FirebaseAuth.instance.currentUser;
  late final currentUserId = currentUser?.uid ?? '';
  late final currentUserName = currentUser?.displayName ?? 'Someone';

  String? userRole;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    final initialIndex = Get.arguments ?? 0;
    _tabController.index = initialIndex;
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    if (userId == null) return;
    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .get();

    if (snapshot.exists) {
      setState(() {
        userRole = snapshot.data()?["role"] ?? "User";
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (userRole == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: CommonAppBar(
        title: userRole == "Manager"
            ? "📋 All Tasks"
            : userRole == "Master"
            ? "📋 Master Panel"
            : "📋 My Tasks",
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.secondary,
        onPressed: () => Get.to(() => AddTaskScreen(userRole: userRole!)),
        child: const Icon(Icons.add, color: AppColors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25),
              ),
              child: TabBar(
                controller: _tabController,
                tabs: tabs.map((tab) => Tab(text: tab)).toList(),
                indicator: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(25),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black87,
                indicatorSize: TabBarIndicatorSize.tab,
                overlayColor: WidgetStateColor.transparent,
                dividerColor: Colors.transparent,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<List<TaskModel>>(
                stream: _taskService.getTasksForAnyRole(userId ?? ''),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No tasks available"));
                  }

                  final tasks = snapshot.data!;

                  List<TaskModel> normalize(List<TaskModel> list) => list
                      .map((t) => t.copyWith(
                      status: t.status.trim().toLowerCase()))
                      .toList();

                  final allTasks = normalize(tasks);
                  final pendingTasks =
                  allTasks.where((t) => t.status == 'pending').toList();
                  final inProgressTasks = allTasks
                      .where((t) =>
                  t.status == 'in progress')
                      .toList();
                  final completedTasks =
                  allTasks.where((t) => t.status == 'completed').toList();

                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _buildTaskList(allTasks),
                      _buildTaskList(pendingTasks),
                      _buildTaskList(inProgressTasks),
                      _buildTaskList(completedTasks),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList(List<TaskModel> filteredTasks) {
    if (filteredTasks.isEmpty) {
      return const Center(
        child: Text(
          "No tasks available",
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      );
    }

    return ListView.separated(
      itemCount: filteredTasks.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final task = filteredTasks[index];
        final statusColor = AppColors.getStatusColor(task.status);

        return TaskCard(
          title: task.title,
          time: "${task.category} • ${task.priority} Priority",
          color: statusColor,
          status: _capitalize(task.status),
          onTap: () {
            Get.to(() => TaskDetailScreen(
              task: task,
              role: userRole ?? '',
              currentUserId: userId ?? '',
            ));
          },
        );
      },
    );
  }
  String _capitalize(String text) =>
      text.isEmpty ? '' : text[0].toUpperCase() + text.substring(1);
}
