import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_flow/presentation/common_widgets/button.dart';
import 'package:task_flow/presentation/theme/app_theme.dart';
import '../../../data/model/task_model.dart';
import '../../common_widgets/appbar.dart';
import '../add_new_task/add_task_screen.dart';
import '../add_new_task/controller/task_service_controller.dart';

class TaskDetailScreen extends StatefulWidget {
  final TaskModel task;
  final String role;
  final String currentUserId;

  const TaskDetailScreen({super.key, required this.task, required this.role, required this.currentUserId});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late bool isCompleted;
  late bool tempCompleted;
  bool hasChanged = false;


  final TaskService _taskService = TaskService();
  String assignedUserName = "";
  String createdByName = "";
  String reviewerName = "";

  @override
  void initState() {
    super.initState();
    isCompleted = widget.task.status == 'completed';
    tempCompleted = isCompleted;
    fetchAssignedUserName();
    fetchCreatorName();
    fetchReviewerName();
  }

  Future<void> fetchAssignedUserName() async {
    if (widget.task.assignedTo.isNotEmpty) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(widget.task.assignedTo).get();
      setState(() {
        assignedUserName = doc.data()?['fullName'] ?? "Unknown";
      });
    }
  }

  Future<void> fetchCreatorName() async {
    if (widget.task.userId.isNotEmpty) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(widget.task.userId).get();
      setState(() {
        createdByName = doc.data()?['fullName'] ?? "Unknown";
      });
    }
  }

  Future<void> fetchReviewerName() async {
    if (widget.task.reviewerId.isNotEmpty) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(widget.task.reviewerId).get();
      setState(() {
        reviewerName = doc.data()?['fullName'] ?? "Unknown";
      });
    }
  }

  void _updateTaskStatus(bool value) async {
    if (widget.role == "User" && widget.task.assignedTo != widget.currentUserId) {
      Get.snackbar("Error", "You are not assigned to this task", snackPosition: SnackPosition.BOTTOM,duration: Duration(seconds: 1));
      return;
    }

    setState(() => isCompleted = value);

    final updatedTask = widget.task.copyWith(status: isCompleted ? 'completed' : 'pending');

    await _taskService.updateTask(updatedTask);
    Get.snackbar("Success", "Task status updated", snackPosition: SnackPosition.BOTTOM,duration: Duration(seconds: 1));
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
                    Expanded(
                      child: Text(
                        widget.task.title,
                        style: AppTextStyles.heading1.copyWith(
                          decoration: isCompleted ? TextDecoration.lineThrough : null,
                          color: isCompleted ? Colors.grey : Colors.black,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Get.to(() => AddTaskScreen(taskToEdit: widget.task, userRole: widget.role)),
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed:
                              () => Get.defaultDialog(
                                title: "Delete Task",
                                middleText: "Are you sure you want to delete this task?",
                                textCancel: "Cancel",
                                textConfirm: "Delete",
                                confirmTextColor: Colors.white,
                                onConfirm: () async {
                                  await _taskService.deleteTask(widget.task.id);
                                  Get.back();
                                  Get.back();
                                  Get.snackbar(
                                    "Deleted",
                                    "Task has been deleted",
                                    snackPosition: SnackPosition.BOTTOM,
                                    duration: const Duration(seconds: 1),
                                  );
                                },
                              ),
                          icon: const Icon(Icons.delete_forever_outlined),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                Text(widget.task.description, style: AppTextStyles.body.copyWith(fontSize: 16, color: Colors.black87)),
                const SizedBox(height: 20),

                Text("👜 Category: ${widget.task.category}", style: const TextStyle(fontSize: 16)),
                Text("🚩 Priority: ${widget.task.priority}", style: const TextStyle(fontSize: 16)),
                Text("🗓 Due: ${widget.task.dueDate}", style: const TextStyle(fontSize: 16)),
                if (assignedUserName.isNotEmpty) Text("👤 Assigned To: $assignedUserName", style: const TextStyle(fontSize: 16)),
                Text("📝 Created By: $createdByName", style: const TextStyle(fontSize: 16)),
                Text("📝 Reviewer: $reviewerName", style: const TextStyle(fontSize: 16)),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Checkbox(
                      value: tempCompleted,
                      onChanged: (value) {
                        setState(() {
                          tempCompleted = value ?? false;
                          hasChanged = tempCompleted != isCompleted;
                        });
                      },
                      activeColor: AppColors.secondary,
                    ),
                    Text(
                      tempCompleted ? "Completed" : "Pending",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: tempCompleted ? AppColors.secondary : AppColors.accent,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                CommonContainer(
                  text: hasChanged ? "Done" : "Back to Tasks",
                  color: hasChanged
                      ? (tempCompleted ? AppColors.secondary : AppColors.accent)
                      : AppColors.primary,
                  onPressed: () async {
                    if (hasChanged) {
                      _updateTaskStatus(tempCompleted);
                    } else {
                      Get.back();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
