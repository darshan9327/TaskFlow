import 'package:flutter/material.dart';
import 'package:task_flow/presentation/theme/app_theme.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String time;
  final String status;
  final Color? color;
  final bool showCheckbox;
  final ValueChanged<bool?>? onStatusChanged;
  final VoidCallback? onTap;

  const TaskCard({
    super.key,
    required this.title,
    required this.time,
    required this.status,
    this.color,
    this.showCheckbox = false,
    this.onStatusChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = status == "completed";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(color: color ?? AppColors.secondary, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(50),
            spreadRadius: 1,
            blurRadius: 4,
          )
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration: isCompleted ? TextDecoration.lineThrough : null,
            color: isCompleted ? Colors.grey : Colors.black,
          ),
        ),
        subtitle: Text(
          "$time • ${isCompleted ? "Completed" : "Pending"}",
          style: TextStyle(
            decoration: isCompleted ? TextDecoration.lineThrough : null,
            color: isCompleted ? Colors.grey : Colors.black54,
          ),
        ),
        leading: showCheckbox
            ? Checkbox(
          value: isCompleted,
          onChanged: onStatusChanged,
          activeColor: color ?? AppColors.secondary,
        )
            : Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        onTap: onTap,
      ),
    );
  }
}
