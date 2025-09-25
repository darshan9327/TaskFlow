import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      appBar: CommonAppBar(title: "📋 Task List"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              CommonListTile(title: "My Tasks", onTap: () {}, text: "🔍"),
              Align(alignment: Alignment.topLeft, child: Text("Task Tile", style: AppTextStyles.heading4)),
              SizedBox(height: Get.height * 0.008),

              CommonTextFormField(controller: taskTileController, hintText: "Enter task tile"),
              SizedBox(height: Get.height * 0.020),

              Align(alignment: Alignment.topLeft, child: Text("Description", style: AppTextStyles.heading4)),
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

              Align(alignment: Alignment.topLeft, child: Text("Description", style: AppTextStyles.heading4)),
              SizedBox(height: Get.height * 0.008),

              CommonTextFormField(
                controller: dateController,
                hintText: "dd-mm-yyyy",
                readonly: true,
                suffix: InkWell(onTap: () {}, overlayColor: WidgetStateColor.transparent, child: Icon(Icons.calendar_month)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
