import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/model/task_model.dart';
import '../../../theme/app_theme.dart';
import '../../task_list/task_list_screen.dart';

class TaskStatsGrid extends StatelessWidget {
  final List<TaskModel> tasks;
  final String userId;
  final String role;

  const TaskStatsGrid({
    super.key,
    required this.tasks,
    required this.userId,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    final userTasks = role == "User"
        ? tasks.where((t) => t.assignedTo == userId).toList()
        : tasks;

    final total = userTasks.length;
    final completed = userTasks.where((t) => t.status == 'completed').length;
    final pending = userTasks.where((t) => t.status == 'pending').length;
    final inProgress = userTasks
        .where((t) => t.status.toLowerCase() == 'in progress')
        .length;
    return GridView.count(
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
          onPressed: () => Get.to(() => TaskListScreen(), arguments: 0),
        ),
        StatCard(
          title: "Pending",
          value: pending.toString(),
          color: Colors.orange,
          onPressed: () => Get.to(() => TaskListScreen(), arguments: 1),
        ),
        StatCard(
          title: "In Progress",
          value: inProgress.toString(),
          color: Colors.blue,
          onPressed: () => Get.to(() => TaskListScreen(), arguments: 2),
        ),
        StatCard(
          title: "Completed",
          value: completed.toString(),
          color: Colors.green,
          onPressed: () => Get.to(() => TaskListScreen(), arguments: 3),
        ),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback? onPressed;
  final Color? color;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: color != null
                ? [color!.withOpacity(0.6), color!]
                : [const Color(0xff2575fc), const Color(0xff6a11cb)],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: AppTextStyles.heading1.copyWith(color: AppColors.white),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
