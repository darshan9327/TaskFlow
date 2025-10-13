import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final String? taskId;

  const TaskDetailScreen({
    super.key,
    required this.task,
    required this.role,
    required this.currentUserId,
    this.taskId,
  });

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late String currentStatus;
  late String tempStatus;
  bool hasChanged = false;

  final TaskService _taskService = TaskService();
  String assignedUserName = "";
  String createdByName = "";
  String reviewerName = "";

  @override
  void initState() {
    super.initState();
    currentStatus = widget.task.status;
    tempStatus = currentStatus;
    fetchAssignedUserName();
    fetchCreatorName();
    fetchReviewerName();
  }

  Future<void> fetchAssignedUserName() async {
    if (widget.task.assignedTo.isNotEmpty) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.task.assignedTo)
          .get();
      setState(() {
        assignedUserName = doc.data()?['fullName'] ?? "Unknown";
      });
    }
  }

  Future<void> fetchCreatorName() async {
    if (widget.task.userId.isNotEmpty) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.task.userId)
          .get();
      setState(() {
        createdByName = doc.data()?['fullName'] ?? "Unknown";
      });
    }
  }

  Future<void> fetchReviewerName() async {
    if (widget.task.reviewerId.isNotEmpty) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.task.reviewerId)
          .get();
      setState(() {
        reviewerName = doc.data()?['fullName'] ?? "Unknown";
      });
    }
  }

  void _updateTaskStatus(String newStatus) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (widget.task.assignedTo != currentUserId) {
      Get.snackbar(
        "Error",
        "Only the assigned user can update this task status",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1),
      );
      return;
    }

    setState(() => currentStatus = newStatus);

    String currentUserName = "Someone";
    if (currentUserId.isNotEmpty) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .get();
      if (doc.exists) {
        currentUserName = doc.data()?['fullName'] ?? "Someone";
      }
    }

    final updatedTask = widget.task.copyWith(status: newStatus);

    await _taskService.updateTask(
      updatedTask,
      currentUserId,
      currentUserName,
    );

    Get.snackbar(
      "Success",
      "Task status updated to ${_getStatusLabel(newStatus)}",
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
      backgroundColor: AppColors.getStatusColor(newStatus),
      colorText: Colors.white,
    );
  }


  String _getStatusLabel(String status) {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'in progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      default:
        return status;
    }
  }


  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.pending_outlined;
      case 'in Progress':
        return Icons.play_circle_outline;
      case 'completed':
        return Icons.check_circle_outline;
      default:
        return Icons.help_outline;
    }
  }

  Widget _buildStatusButton(String status, String label, Color color) {
    final isSelected = tempStatus == status;
    final isAssignedUser = widget.task.assignedTo == FirebaseAuth.instance.currentUser?.uid;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (!isAssignedUser) {
            Get.snackbar(
              "Error",
              "Only the assigned user can change this status",
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 1)
            );
            return;
          }
          setState(() {
            tempStatus = status;
            hasChanged = tempStatus != currentStatus;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color : Colors.grey[300]!,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Icon(
                _getStatusIcon(status),
                color: isSelected ? Colors.white : Colors.grey[600],
                size: 28,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[600],
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Task Details"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
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
                          decoration: currentStatus == 'completed'
                              ? TextDecoration.lineThrough
                              : null,
                          color: currentStatus == 'completed'
                              ? Colors.grey
                              : Colors.black,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Get.to(() => AddTaskScreen(
                              taskToEdit: widget.task,
                              userRole: widget.role)),
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () => Get.defaultDialog(
                            title: "Delete Task",
                            middleText:
                            "Are you sure you want to delete this task?",
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
                Text(
                  widget.task.description,
                  style: AppTextStyles.body.copyWith(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                Text("👜 Category: ${widget.task.category}",
                    style: const TextStyle(fontSize: 16)),
                Text("🚩 Priority: ${widget.task.priority}",
                    style: const TextStyle(fontSize: 16)),
                Text("🗓 Due: ${widget.task.dueDate}",
                    style: const TextStyle(fontSize: 16)),
                if (assignedUserName.isNotEmpty)
                  Text("👤 Assigned To: $assignedUserName",
                      style: const TextStyle(fontSize: 16)),
                Text("📝 Created By: $createdByName",
                    style: const TextStyle(fontSize: 16)),
                Text("📝 Reviewer: $reviewerName",
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 30),

                // Status Selection
                Text(
                  "Task Status",
                  style: AppTextStyles.heading1.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildStatusButton('pending', 'Pending', Colors.orange),
                    const SizedBox(width: 8),
                    _buildStatusButton('In Progress','in Progress', Colors.blue),
                    const SizedBox(width: 8),
                    _buildStatusButton('completed', 'Completed', Colors.green),
                  ],
                ),

                const Spacer(),

                CommonContainer(
                  text: hasChanged ? "Update Status" : "Back to Tasks",
                  color: hasChanged
                      ? AppColors.getStatusColor(tempStatus)
                      : AppColors.primary,
                  onPressed: () async {
                    if (hasChanged) {
                      _updateTaskStatus(tempStatus);
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
