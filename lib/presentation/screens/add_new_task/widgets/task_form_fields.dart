import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/model/task_model.dart';
import '../../../common_widgets/button.dart';
import '../../../common_widgets/text_form_field.dart';
import '../../../theme/app_theme.dart';

class TaskFormField extends StatefulWidget {
  final TaskModel? taskToEdit;
  final String? userRole;
  final List<Map<String, dynamic>> allUsers;
  final Function(TaskModel) onSubmit;
  final VoidCallback onCancel;

  const TaskFormField({
    super.key,
    this.taskToEdit,
    this.userRole,
    required this.allUsers,
    required this.onSubmit,
    required this.onCancel,
  });

  @override
  State<TaskFormField> createState() => _TaskFormFieldState();
}

class _TaskFormFieldState extends State<TaskFormField> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController taskTitleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  String selectedCategory = '';
  String selectedPriority = '';
  String dueDate = '';
  String dueTime = '';
  String selectedAssignedUserId = '';
  String selectedAssignedUserName = '';

  final List<String> categories = ['Work', 'Personal', 'Learning'];
  final List<String> priorities = ['High', 'Medium', 'Low'];

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
      if (widget.allUsers.isNotEmpty) {
        final user = widget.allUsers.firstWhere(
                (u) => u['uid'] == task.assignedTo,
            orElse: () => widget.allUsers.first);
        selectedAssignedUserName = user['fullName'];
      }
    } else if (widget.allUsers.isNotEmpty) {
      selectedAssignedUserId = widget.allUsers.first['uid'];
      selectedAssignedUserName = widget.allUsers.first['fullName'];
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

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final task = TaskModel(
      id: widget.taskToEdit?.id ?? '',
      title: taskTitleController.text.trim(),
      description: descriptionController.text.trim(),
      category: selectedCategory,
      priority: selectedPriority,
      dueDate: dateController.text.trim(),
      status: widget.taskToEdit?.status ?? 'pending',
      userId: widget.taskToEdit?.userId ?? '',
      assignedTo: selectedAssignedUserId,
      reviewerId: '',
    );

    widget.onSubmit(task);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.taskToEdit != null;

    return Form(
      key: _formKey,
      child: Column(
        children: [
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
                  child: buildDropdown("Category", categories, selectedCategory, (val) => setState(() => selectedCategory = val), "Select Category")
              ),
              SizedBox(width: Get.width * 0.012),
              Expanded(
                  child: buildDropdown("Priority", priorities, selectedPriority, (val) => setState(() => selectedPriority = val), "Select Priority")
              ),
            ],
          ),
          SizedBox(height: Get.height * 0.020),

          if (widget.userRole != null && widget.userRole != 'User')
            buildDropdown(
              "Assign To",
              widget.allUsers.map((u) => u['fullName'].toString()).toList(),
              selectedAssignedUserName,
                  (val) {
                setState(() {
                  selectedAssignedUserName = val;
                  selectedAssignedUserId = widget.allUsers.firstWhere((u) => u['fullName'] == val)['uid'];
                });
              },
              "Select User",
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
              child: const Icon(Icons.calendar_month),
            ),
            validator: (value) => (value == null || value.trim().isEmpty) ? "Due date & time is required" : null,
          ),
          SizedBox(height: Get.height * 0.050),

          Row(
            children: [
              Expanded(child: CommonContainer(text: "Cancel", onPressed: widget.onCancel, color: AppColors.third)),
              SizedBox(width: Get.width * 0.050),
              Expanded(
                child: CommonContainer(text: isEditing ? "Update Task" : "Create Task", onPressed: _submit, color: AppColors.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


