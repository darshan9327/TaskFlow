import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_flow/presentation/screens/add_new_task/add_task_screen.dart';
import '../../common_widgets/appbar.dart';
import '../../common_widgets/list_tile.dart';
import '../../common_widgets/task_tile.dart';
import '../../theme/app_theme.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> tabs = ['All', 'Pending', 'Completed'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> tasks = [
    {'title': 'Database Schema Design', 'time': 'Work • High Priority'},
    {'title': 'Flutter UI Implementation', 'time': 'Personal • Medium Priority'},
    {'title': 'Setup Firebase Project', 'time': 'Work • Completed'},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "📋 Task List"),
      floatingActionButton: Container(
        decoration: BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            onTap: () {
              Get.to(AddTaskScreen());
            },
            child: Icon(Icons.add, color: AppColors.white),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            CommonListTile(title: "My Tasks", onTap: () {}, text: "🔍"),
            SizedBox(height: Get.height * 0.020),
            Container(
              height: 55,
              decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(22)),
              child: TabBar(
                controller: _tabController,
                tabs: tabs.map((tab) => Tab(text: tab)).toList(),
                indicator: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                overlayColor: WidgetStateColor.transparent,
                dividerColor: Colors.transparent,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  ListView(
                    children:
                        tasks.map((task) {
                          return TaskCard(title: task['title']!, time: task['time']!, showCheckbox: true);
                        }).toList(),
                  ),
                  Center(child: Text("Pending Items")),
                  Center(child: Text("Completed Items")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
