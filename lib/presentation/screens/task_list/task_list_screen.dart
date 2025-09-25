import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_flow/presentation/screens/add_new_task/add_task_screen.dart';
import '../../common_widgets/appbar.dart';
import '../../common_widgets/list_tile.dart';
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

  final List<String> tabs = ['All', 'Pending', 'Completed'];

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

  final List<Map<String, dynamic>> tasks = [
    {
      'title': 'Database Schema Design',
      'time': 'Work • High Priority',
      'description': 'Design relational schema for project database.',
      'category': 'Work',
      'priority': 'High',
      'dueDate': '28-09-2025',
      'status': 'pending',
    },
    {
      'title': 'Flutter UI Implementation',
      'time': 'Personal • Medium Priority',
      'description': 'Implement main dashboard UI in Flutter.',
      'category': 'Personal',
      'priority': 'Medium',
      'dueDate': '30-09-2025',
      'status': 'pending',
    },
    {
      'title': 'Setup Firebase Project',
      'time': 'Work • Completed',
      'description': 'Initialize Firebase project and link with app.',
      'category': 'Work',
      'priority': 'Low',
      'dueDate': '25-09-2025',
      'status': 'completed',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "📋 Task List"),
      floatingActionButton: Container(
        decoration: BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            onTap: () {
              Get.to(const AddTaskScreen());
            },
            child: const Icon(Icons.add, color: AppColors.white),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            CommonListTile(title: "My Tasks", onTap: () {}, text: "🔍"),
            SizedBox(height: Get.height * 0.020),

            Container(
              height: 55,
              decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(22)),
              child: TabBar(
                controller: _tabController,
                tabs: tabs.map((tab) => Tab(text: tab)).toList(),
                indicator: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(20)),
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
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTaskList(tasks),
                  _buildTaskList(tasks.where((t) => t['status'] == 'pending').toList()),
                  _buildTaskList(tasks.where((t) => t['status'] == 'completed').toList()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList(List<Map<String, dynamic>> filteredTasks) {
    if (filteredTasks.isEmpty) {
      return const Center(child: Text("No tasks available"));
    }
    return ListView.builder(
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        final task = filteredTasks[index];
        return TaskCard(
          title: task['title'],
          time: task['time'],
          status: task['status'],
          showCheckbox: true,
          onStatusChanged: (val) {
            setState(() {
              task['status'] = val! ? 'completed' : 'pending';
            });
          },
          onTap: () {
            Get.to(
              TaskDetailScreen(
                title: task['title'],
                description: task['description'],
                category: task['category'],
                priority: task['priority'],
                dueDate: task['dueDate'],
                isCompleted: task['status'] == 'completed',
              ),
            );
          },
        );
      },
    );
  }
}
