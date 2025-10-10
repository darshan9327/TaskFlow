import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_flow/domain/services/get_server_key.dart';
import '../../../data/model/task_model.dart';
import 'controller/task_service_controller.dart';
import '../../common_widgets/appbar.dart';
import '../../common_widgets/list_tile.dart';
import '../../common_widgets/text_form_field.dart';
import '../../common_widgets/button.dart';
import '../../theme/app_theme.dart';

class AddTaskScreen extends StatefulWidget {
  final TaskModel? taskToEdit;
  final String? userRole;
  const AddTaskScreen({super.key, this.taskToEdit, this.userRole});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final TaskService _taskService = TaskService();

  final TextEditingController taskTitleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  String selectedCategory = '';
  String selectedPriority = '';
  String dueDate = '';
  String dueTime = '';

  final List<String> categories = ['Work', 'Personal', 'Learning'];
  final List<String> priorities = ['High', 'Medium', 'Low'];

  List<Map<String, dynamic>> allUsers = [];
  String selectedAssignedUserId = '';
  String selectedAssignedUserName = '';
  String selectedReviewerName = '';
  String selectedReviewerUserId = '';

  @override
  void initState() {
    super.initState();
    if (widget.taskToEdit != null) {
      final task = widget.taskToEdit!;
      taskTitleController.text = task.title;
      descriptionController.text = task.description;
      selectedCategory = task.category;
      selectedPriority = task.priority;
      dateController.text = task.dueDate;
      dueDate = task.dueDate.split("•").first.trim();
      dueTime = task.dueDate.split("•").length > 1 ? task.dueDate.split("•")[1].trim() : '';

      selectedAssignedUserId = task.assignedTo;
      selectedAssignedUserName = allUsers.firstWhere((u) => u['uid'] == task.assignedTo, orElse: () => {'fullName': '', 'uid': ''})['fullName'] ?? '';

      selectedReviewerUserId = task.reviewerId;
      selectedReviewerName = allUsers.firstWhere((u) => u['uid'] == task.reviewerId, orElse: () => {'fullName': '', 'uid': ''})['fullName'] ?? '';
    }
    fetchAllUsers();
  }

  @override
  void dispose() {
    taskTitleController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    super.dispose();
  }

  Future<void> fetchAllUsers() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    allUsers = snapshot.docs.map((doc) => doc.data()).toList();

    allUsers = allUsers.fold<List<Map<String, dynamic>>>([], (acc, u) {
      if (!acc.any((x) => x['fullName'] == u['fullName'])) acc.add(u);
      return acc;
    });

    if (widget.taskToEdit != null) {
      final task = widget.taskToEdit!;
      final assignedUser = allUsers.firstWhere((u) => u['uid'] == task.assignedTo, orElse: () => allUsers.first);
      selectedAssignedUserId = assignedUser['uid'];
      selectedAssignedUserName = assignedUser['fullName'];

      final reviewerUser = allUsers.firstWhere((u) => u['uid'] == task.reviewerId, orElse: () => allUsers.first);
      selectedReviewerUserId = reviewerUser['uid'];
      selectedReviewerName = reviewerUser['fullName'];
    } else if (allUsers.isNotEmpty) {
      selectedAssignedUserId = allUsers.first['uid'];
      selectedAssignedUserName = allUsers.first['fullName'];
      selectedReviewerUserId = allUsers.first['uid'];
      selectedReviewerName = allUsers.first['fullName'];
    }
    setState(() {});
  }

  void _addOrUpdateTask() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedCategory.isEmpty) {
      Get.snackbar("Error", "Please select a category", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (selectedPriority.isEmpty) {
      Get.snackbar("Error", "Please select a priority", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final currentUser = FirebaseAuth.instance.currentUser;
    final currentUserId = currentUser?.uid;
    final currentUserName = currentUser?.displayName ?? "Someone";

    if (currentUserId == null) {
      Get.snackbar("Error", "User not logged in", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final task = TaskModel(
      id: widget.taskToEdit?.id ?? '',
      title: taskTitleController.text.trim(),
      description: descriptionController.text.trim(),
      category: selectedCategory,
      priority: selectedPriority,
      dueDate: dateController.text.trim(),
      status: widget.taskToEdit?.status ?? 'pending',
      userId: currentUserId,
      assignedTo: selectedAssignedUserId,
      reviewerId: selectedReviewerUserId,
    );

    try {
      if (widget.taskToEdit != null) {
        await _taskService.updateTask(task, currentUserId, currentUserName);
        Get.back(result: task);
        Get.snackbar("Updated", "Task updated successfully", snackPosition: SnackPosition.BOTTOM);
      } else {
        await _taskService.addTask(task, currentUserId);
        Get.back(result: task);
        Get.snackbar("Success", "Task added successfully", snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }


  void _clearForm() {
    setState(() {
      taskTitleController.clear();
      descriptionController.clear();
      dateController.clear();
      selectedCategory = '';
      selectedPriority = '';
      dueDate = '';
      dueTime = '';
      selectedAssignedUserId = allUsers.isNotEmpty ? allUsers.first['uid'] : '';
      selectedAssignedUserName = allUsers.isNotEmpty ? allUsers.first['fullName'] : '';
    });
    Get.snackbar("Cleared", "All fields have been reset", snackPosition: SnackPosition.BOTTOM);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.taskToEdit != null;

    return Scaffold(
      appBar: CommonAppBar(title: isEditing ? "✏️  Edit Task" : "➕  Add New Task"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CommonListTile(title: isEditing ? "Edit Task" : "Create Task", onTap: _clearForm, text: "✕"),
                SizedBox(height: Get.height * 0.020),
                Align(alignment: Alignment.topLeft, child: Text("Task Title", style: AppTextStyles.body)),
                SizedBox(height: Get.height * 0.008),
                CommonTextFormField(
                  controller: taskTitleController,
                  hintText: "Enter task title",
                  validator: (value) => (value == null || value.trim().isEmpty) ? "Task title is required" : null,
                ),
                SizedBox(height: Get.height * 0.020),
                Align(alignment: Alignment.topLeft, child: Text("Description", style: AppTextStyles.body)),
                SizedBox(height: Get.height * 0.008),
                CommonTextFormField(
                  controller: descriptionController,
                  hintText: "Add task Description...",
                  maxLines: 3,
                  maxLength: 150,
                  validator: (value) => (value == null || value.trim().isEmpty) ? "Description is required" : null,
                ),
                SizedBox(height: Get.height * 0.020),
                Row(
                  children: [
                    Expanded(
                      child: buildDropdown(
                        "Category",
                        categories,
                        selectedCategory,
                        (val) => setState(() => selectedCategory = val),
                        "Select Category",
                      ),
                    ),
                    SizedBox(width: Get.width * 0.012),
                    Expanded(
                      child: buildDropdown(
                        "Priority",
                        priorities,
                        selectedPriority,
                        (val) => setState(() => selectedPriority = val),
                        "Select Priority",
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Get.height * 0.020),
                buildDropdown(
                  "Assign To",
                  allUsers.map((u) => u['fullName'].toString()).toList(),
                  widget.taskToEdit != null ? selectedAssignedUserName : '',
                  (val) {
                    setState(() {
                      selectedAssignedUserName = val;
                      selectedAssignedUserId = allUsers.firstWhere((u) => u['fullName'] == val)['uid'];
                    });
                  },
                  "Select User",
                ),
                SizedBox(height: Get.height * 0.020),
                buildDropdown(
                  "Reviewer",
                  allUsers.map((u) => u['fullName'].toString()).toList(),
                  widget.taskToEdit != null ? selectedReviewerName : '',
                  (val) {
                    setState(() {
                      selectedReviewerName = val;
                      selectedReviewerUserId = allUsers.firstWhere((u) => u['fullName'] == val)['uid'];
                    });
                  },
                  "Select Reviewer",
                ),
                SizedBox(height: Get.height * 0.020),
                Align(alignment: Alignment.topLeft, child: Text("Due Date", style: AppTextStyles.body)),
                SizedBox(height: Get.height * 0.008),
                CommonTextFormField(
                  controller: dateController,
                  hintText: "Select Due Date & Time",
                  readonly: true,
                  suffix: InkWell(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                        if (pickedTime != null) {
                          setState(() {
                            dueDate = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                            dueTime = "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
                            dateController.text = "$dueDate • $dueTime";
                          });
                        }
                      }
                    },
                    overlayColor: WidgetStateColor.transparent,
                    child: const Icon(Icons.calendar_month),
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty) ? "Due date & time is required" : null,
                ),
                SizedBox(height: Get.height * 0.050),
                Row(
                  children: [
                    Expanded(child: CommonContainer(text: "Cancel", onPressed: () => Get.back(), color: AppColors.third)),
                    SizedBox(width: Get.width * 0.050),
                    Expanded(
                      child: CommonContainer(text: isEditing ? "Update Task" : "Create Task", onPressed: _addOrUpdateTask, color: AppColors.primary),
                    ),
                    // Expanded(
                    //   child: CommonContainer(text: "Update Task", onPressed: () async{
                    //     GetServerKey getServerKey = GetServerKey();
                    //     String accessToken = await getServerKey.getServerKeyToken();
                    //     print(accessToken);
                    //   }, color: AppColors.primary),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildDropdown(String label, List<String> items, String selected, Function(String) onChanged, String hint) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: AppTextStyles.body),
      SizedBox(height: Get.height * 0.008),
      DropdownButtonFormField<String>(
        value: selected.isEmpty ? null : selected,
        hint: Text(hint),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (val) => onChanged(val!),
        validator: (val) => val == null || val.isEmpty ? "$label is required" : null,
      ),
    ],
  );
}
