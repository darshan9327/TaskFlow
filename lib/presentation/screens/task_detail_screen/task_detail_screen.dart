import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_flow/presentation/common_widgets/button.dart';
import 'package:task_flow/presentation/theme/app_theme.dart';

import '../../common_widgets/appbar.dart';

class TaskDetailScreen extends StatefulWidget {
  final String title;
  final String description;
  final String category;
  final String priority;
  final String dueDate;
  final bool isCompleted;

  const TaskDetailScreen({
    super.key,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.dueDate,
    this.isCompleted = false,
  });

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late bool isCompleted;

  @override
  void initState() {
    super.initState();
    isCompleted = widget.isCompleted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Task Details"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: AppTextStyles.heading1.copyWith(
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                    color: isCompleted ? Colors.grey : Colors.black,
                  ),
                ),
                SizedBox(height: Get.height * 0.010),
                Text(
                  widget.description,
                  style: AppTextStyles.body.copyWith(fontSize: 16, color: Colors.black87),
                ),
                SizedBox(height: Get.height * 0.020),
                Text("👜  ${widget.category}", style: const TextStyle(fontSize: 17)),
                SizedBox(height: Get.height * 0.012),
                Text("🚩  Priority: ${widget.priority}", style: const TextStyle(fontSize: 17)),
                SizedBox(height: Get.height * 0.012),
                Text("🗓  ${widget.dueDate}", style: const TextStyle(fontSize: 17)),
                SizedBox(height: Get.height * 0.020),

                Row(
                  children: [
                    Checkbox(
                      value: isCompleted,
                      onChanged: (value) {
                        setState(() {
                          isCompleted = value ?? false;
                        });
                      },
                      activeColor: AppColors.secondary,
                    ),
                    Text(
                      isCompleted ? "Completed" : "Pending",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isCompleted ? AppColors.secondary : AppColors.accent,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                CommonContainer(text: isCompleted ? "Done" : "Back to Tasks",
                  color: isCompleted ? AppColors.secondary : AppColors.primary,
                  onPressed: () {
                  Navigator.pop(context, isCompleted);
                },)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
