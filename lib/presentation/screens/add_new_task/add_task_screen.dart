import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../domain/model/task_model.dart';
import '../../../domain/use_cases/task_service_use_case.dart';
import '../../common_widgets/appbar.dart';
import '../../common_widgets/list_tile.dart';
import '../../common_widgets/text_form_field.dart';
import '../../common_widgets/button.dart';
import '../../theme/app_theme.dart';
import 'widgets/drop_down_page.dart';

class AddTaskScreen extends StatefulWidget {
  final TaskModel? taskToEdit;
  const AddTaskScreen({super.key, this.taskToEdit});

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

  final List<String> categories = ['', 'Work', 'Personal', 'Learning'];
  final List<String> priorities = ['', 'High', 'Medium', 'Low'];

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
      dueTime = task.dueDate.split("•").length > 1
          ? task.dueDate.split("•")[1].trim()
          : '';
    }
  }

  void _addOrUpdateTask() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedCategory.isEmpty) {
      Get.snackbar("Error", "Please select a category",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (selectedPriority.isEmpty) {
      Get.snackbar("Error", "Please select a priority",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      Get.snackbar("Error", "User not logged in",
          snackPosition: SnackPosition.BOTTOM);
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
      userId: userId,
    );

    try {
      if (widget.taskToEdit != null) {
        await _taskService.updateTask(task);
        Get.back(result: task); // return updated task
        Get.snackbar("Updated", "Task updated successfully",
            snackPosition: SnackPosition.BOTTOM);
      } else {
        await _taskService.addTask(task, userId);
        Get.back(result: task); // return new task
        Get.snackbar("Success", "Task added successfully",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.taskToEdit != null;

    return Scaffold(
      appBar: CommonAppBar(
          title: isEditing ? "✏️  Edit Task" : "➕  Add New Task"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CommonListTile(
                    title: isEditing ? "Edit Task" : "Create Task",
                    onTap: () {},
                    text: "✕"),
                SizedBox(height: Get.height * 0.020),

                Align(
                    alignment: Alignment.topLeft,
                    child: Text("Task Title", style: AppTextStyles.body)),
                SizedBox(height: Get.height * 0.008),
                CommonTextFormField(
                  controller: taskTitleController,
                  hintText: "Enter task title",
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Task title is required";
                    }
                    return null;
                  },
                ),
                SizedBox(height: Get.height * 0.020),

                Align(
                    alignment: Alignment.topLeft,
                    child: Text("Description", style: AppTextStyles.body)),
                SizedBox(height: Get.height * 0.008),
                CommonTextFormField(
                  controller: descriptionController,
                  hintText: "Add task Description...",
                  maxLines: 3,
                  maxLength: 150,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Description is required";
                    }
                    return null;
                  },
                ),
                SizedBox(height: Get.height * 0.020),

                Row(
                  children: [
                    Expanded(
                        child: buildDropdown(
                            "Category",
                            categories,
                            selectedCategory,
                                (val) => setState(() => selectedCategory = val))),
                    SizedBox(width: Get.width * 0.012),
                    Expanded(
                        child: buildDropdown(
                            "Priority",
                            priorities,
                            selectedPriority,
                                (val) => setState(() => selectedPriority = val))),
                  ],
                ),
                SizedBox(height: Get.height * 0.020),

                Align(
                    alignment: Alignment.topLeft,
                    child: Text("Due Date", style: AppTextStyles.body)),
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
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (pickedTime != null) {
                          setState(() {
                            dueDate =
                            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                            dueTime =
                            "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
                            dateController.text = "$dueDate • $dueTime";
                          });
                        }
                      }
                    },
                    overlayColor: WidgetStateColor.transparent,
                    child: const Icon(Icons.calendar_month),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Due date & time is required";
                    }
                    return null;
                  },
                ),
                SizedBox(height: Get.height * 0.050),
                Row(
                  children: [
                    Expanded(
                        child: CommonContainer(
                          text: "Cancel",
                          onPressed: () {
                            Get.back();
                          },
                          color: AppColors.third,
                        )),
                    SizedBox(width: Get.width * 0.050),
                    Expanded(
                        child: CommonContainer(
                          text: isEditing ? "Update Task" : "Create Task",
                          onPressed: _addOrUpdateTask,
                          color: AppColors.primary,
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
