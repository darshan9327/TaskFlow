import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_flow/presentation/common_widgets/list_tile.dart';
import 'package:task_flow/presentation/screens/add_new_task/add_task_screen.dart';
import 'package:task_flow/presentation/screens/profile/profile_screen.dart';
import 'package:task_flow/presentation/screens/task_detail_screen/task_detail_screen.dart';
import 'package:task_flow/presentation/screens/task_list/task_list_screen.dart';

import '../../common_widgets/appbar.dart';
import '../../common_widgets/task_tile.dart';
import '../../theme/app_theme.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List<Map<String, dynamic>> tasks = [
    {'title': 'Complete API Integration', 'time': 'Due: 2:00 PM', 'color': Colors.red},
    {'title': 'Review Code Changes', 'time': 'Due: 5:00 PM', 'color': Colors.orange},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: "🔐 Dashboard",
        actions: [
          InkWell(onTap: () => Get.to(ProfileScreen()), child: Padding(padding: const EdgeInsets.only(right: 20.0), child: Icon(Icons.person))),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            onTap: () {
              Get.to(AddTaskScreen());
            },
            child: Icon(Icons.add, color: AppColors.white),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              CommonListTile(title: "Good Morning!", onTap: () {}, text: "🔔", subtitle: "John Doe"),
              SizedBox(height: Get.height * 0.020),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.5,
                children: [
                  StatCard(title: "Total Tasks", value: "12", onPressed: () => Get.to(() => TaskListScreen(), arguments: 0)),
                  StatCard(title: "Completed", value: "8",onPressed: () => Get.to(() => TaskListScreen(), arguments: 2)),
                  StatCard(title: "Pending", value: "4", onPressed: () => Get.to(() => TaskListScreen(), arguments: 1)),
                ],
              ),
              SizedBox(height: Get.height * 0.020),
              Align(alignment: Alignment.topLeft, child: Text("Today's Tasks", style: AppTextStyles.body)),
              SizedBox(height: Get.height * 0.008),
              ...tasks.map((task) {
                return TaskCard(title: task['title']!, time: task['time']!, color: task['color']!,onTap: (){
                  Get.to(TaskDetailScreen(title: task['title'], description: "ABC", category: "Work", priority: "High", dueDate: task['time']));
                }, status: '',);
              }),
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

  const StatCard({super.key, required this.title, required this.value, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xff2575fc), Color(0xff6a11cb)], begin: Alignment.bottomLeft, end: Alignment.topRight),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(value, style: AppTextStyles.heading1.copyWith(color: AppColors.white)),
              SizedBox(height: Get.height * 0.004),
              Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
