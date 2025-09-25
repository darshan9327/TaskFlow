import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_flow/presentation/common_widgets/button.dart';

import '../../common_widgets/appbar.dart';
import '../../common_widgets/list_tile.dart';
import '../../common_widgets/text_form_field.dart';
import '../../theme/app_theme.dart';
import 'widgets/drop_down_page.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController taskTileController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  String selectedCategory = 'Work';
  String selectedPriority = 'High';

  final List<String> categories = ['Work', 'Personal', 'Learning'];
  final List<String> priorities = ['High', 'Medium', 'Low'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "➕  Add New Task"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              CommonListTile(title: "Create Task", onTap: () {}, text: "✕"),
              SizedBox(height: Get.height * 0.020),
              Align(alignment: Alignment.topLeft, child: Text("Task Title", style: AppTextStyles.body)),
              SizedBox(height: Get.height * 0.008),

              CommonTextFormField(controller: taskTileController, hintText: "Enter task title"),
              SizedBox(height: Get.height * 0.020),

              Align(alignment: Alignment.topLeft, child: Text("Description", style: AppTextStyles.body)),
              SizedBox(height: Get.height * 0.008),

              CommonTextFormField(controller: descriptionController, hintText: "Add task Description...", maxLines: 3, maxLength: 50),
              SizedBox(height: Get.height * 0.020),

              Row(
                children: [
                  Expanded(child: buildDropdown("Category", categories, selectedCategory, (val) => setState(() => selectedCategory = val))),
                  SizedBox(width: Get.width * 0.012),

                  Expanded(child: buildDropdown("Priority", priorities, selectedPriority, (val) => setState(() => selectedPriority = val))),
                ],
              ),
              SizedBox(height: Get.height * 0.020),

              Align(alignment: Alignment.topLeft, child: Text("Due Date", style: AppTextStyles.body)),
              SizedBox(height: Get.height * 0.008),

              CommonTextFormField(
                controller: dateController,
                hintText: "dd-mm-yyyy",
                readonly: true,
                suffix: InkWell(
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() {
                        dateController.text = "${picked.day} / ${picked.month} / ${picked.year}";
                      });
                    }
                  },
                  overlayColor: WidgetStateColor.transparent,
                  child: const Icon(Icons.calendar_month),
                ),
              ),
              SizedBox(height: Get.height * 0.050),
              Row(
                children: [
                  Expanded(child: CommonContainer(text: "Cancel", onPressed: (){Get.back();},color: AppColors.third,)),
                  SizedBox(width: Get.width * 0.050),
                  Expanded(child: CommonContainer(text: "Create Task", onPressed: (){}, color: AppColors.primary,)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
