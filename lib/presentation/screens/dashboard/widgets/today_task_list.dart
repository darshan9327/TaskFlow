import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/model/task_model.dart';
import '../../../common_widgets/task_tile.dart';
import '../../../theme/app_theme.dart';
import '../../task_detail_screen/task_detail_screen.dart';

class TodaysTasksList extends StatelessWidget {
  final List<TaskModel> tasks;
  const TodaysTasksList({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final todaysTasks = tasks.where((t) => isToday(t.dueDate)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(alignment: Alignment.topLeft, child: Text("Today's Tasks", style: AppTextStyles.body)),
        const SizedBox(height: 8),
        if (todaysTasks.isEmpty)
          const Text("No tasks for today")
        else
          ...todaysTasks.map((task) => TaskCard(
            title: task.title,
            time: task.dueDate,
            color: task.status == 'completed' ? Colors.green : Colors.orange,
            status: task.status,
            onTap: () => Get.to(() => TaskDetailScreen(task: task, role: '', currentUserId: '')),
          )),
      ],
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
  return taskDate.year == today.year && taskDate.month == today.month && taskDate.day == today.day;
}

