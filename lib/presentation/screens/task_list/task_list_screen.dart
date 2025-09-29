import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_flow/domain/model/task_model.dart';
import 'package:task_flow/presentation/screens/add_new_task/add_task_screen.dart';
import '../../../domain/use_cases/task_service_use_case.dart';
import '../../common_widgets/appbar.dart';
import '../../common_widgets/task_tile.dart';
import '../../theme/app_theme.dart';
import '../task_detail_screen/task_detail_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TaskService _taskService = TaskService();

  final List<String> tabs = ['All', 'Pending', 'Completed'];
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    final initialIndex = Get.arguments ?? 0;
    _tabController.index = initialIndex;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: "📋 Task List"),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.secondary,
        onPressed: () => Get.to(() => const AddTaskScreen()),
        child: const Icon(Icons.add, color: AppColors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              height: 55,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(22),
              ),
              child: TabBar(
                controller: _tabController,
                tabs: tabs.map((tab) => Tab(text: tab)).toList(),
                indicator: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                overlayColor: WidgetStateColor.transparent,
                dividerColor: Colors.transparent,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<List<TaskModel>>(
                stream: _taskService.getTasks(userId: userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No tasks available"));
                  }

                  final tasks = snapshot.data!;
                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _buildTaskList(tasks),
                      _buildTaskList(tasks.where((t) => t.status == 'pending').toList()),
                      _buildTaskList(tasks.where((t) => t.status == 'completed').toList()),
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
    return ListView.builder(
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        final task = filteredTasks[index];
        return TaskCard(
          title: task.title,
          time: "${task.category} • ${task.priority} Priority",
          status: task.status,
          showCheckbox: true,
          onStatusChanged: (val) {
            _taskService.updateTask(
              task.copyWith(
                status: val! ? 'completed' : 'pending',
              ),
            );
          },
          onTap: () {
            Get.to(() => TaskDetailScreen(task: task));
          },
        );
      },
    );
  }
}
