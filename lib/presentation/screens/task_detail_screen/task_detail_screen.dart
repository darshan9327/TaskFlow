import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_flow/domain/model/task_model.dart';
import 'package:task_flow/domain/use_cases/task_service_use_case.dart';
import 'package:task_flow/presentation/common_widgets/button.dart';
import 'package:task_flow/presentation/theme/app_theme.dart';
import '../../common_widgets/appbar.dart';
import '../add_new_task/add_task_screen.dart';

class TaskDetailScreen extends StatefulWidget {
  final TaskModel task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late bool isCompleted;
  final TaskService _taskService = TaskService();

  @override
  void initState() {
    super.initState();
    isCompleted = widget.task.status == 'completed';
  }

  void _updateTaskStatus(bool value) {
    setState(() {
      isCompleted = value;
    });

    _taskService.updateTask(widget.task.copyWith(
      status: isCompleted ? 'completed' : 'pending',
    ));
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.task.title,
                      style: AppTextStyles.heading1.copyWith(
                        decoration: isCompleted ? TextDecoration.lineThrough : null,
                        color: isCompleted ? Colors.grey : Colors.black,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(onPressed: () {
                          Get.to(() => AddTaskScreen(taskToEdit: widget.task));
                        }, icon: Icon(Icons.edit)),
                        IconButton(onPressed: () {
                          Get.defaultDialog(
                            title: "Delete Task",
                            middleText: "Are you sure you want to delete this task?",
                            textCancel: "Cancel",
                            textConfirm: "Delete",
                            confirmTextColor: Colors.white,
                            onConfirm: () async {
                              final userId = FirebaseAuth.instance.currentUser?.uid;
                              if (userId != null) {
                                await _taskService.deleteTask(userId, widget.task.id);
                                Get.back();
                                Get.back();
                                Get.snackbar("Deleted", "Task has been deleted",
                                    snackPosition: SnackPosition.BOTTOM);
                              }
                            },
                          );
                        }, icon: Icon(Icons.delete_forever_outlined)),
                      ],
                    )
                  ],
                ),
                SizedBox(height: Get.height * 0.010),
                Text(
                  widget.task.description,
                  style: AppTextStyles.body.copyWith(fontSize: 16, color: Colors.black87),
                ),
                SizedBox(height: Get.height * 0.020),
                Text("👜  ${widget.task.category}", style: const TextStyle(fontSize: 17)),
                SizedBox(height: Get.height * 0.012),
                Text("🚩  Priority: ${widget.task.priority}", style: const TextStyle(fontSize: 17)),
                SizedBox(height: Get.height * 0.012),
                Text("🗓  ${widget.task.dueDate}", style: const TextStyle(fontSize: 17)),
                SizedBox(height: Get.height * 0.020),
                Row(
                  children: [
                    Checkbox(
                      value: isCompleted,
                      onChanged: (value) => _updateTaskStatus(value ?? false),
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
                CommonContainer(
                  text: isCompleted ? "Done" : "Back to Tasks",
                  color: isCompleted ? AppColors.secondary : AppColors.primary,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
