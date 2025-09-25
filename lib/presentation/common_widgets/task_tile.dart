import 'package:flutter/material.dart';
import 'package:task_flow/presentation/theme/app_theme.dart';

class TaskCard extends StatefulWidget {
  final String title;
  final String time;
  final Color? color;
  final bool showCheckbox;

  const TaskCard({super.key, required this.title, required this.time, this.color, this.showCheckbox = false});

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool isChecked = false; // local state for checkbox

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: widget.color ?? AppColors.secondary, width: 4)),
        boxShadow: [BoxShadow(color: Colors.grey.withAlpha(50), spreadRadius: 1, blurRadius: 4)],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          widget.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration: isChecked ? TextDecoration.lineThrough : null,
            color: isChecked ? Colors.grey : Colors.black,
          ),
        ),
        subtitle: Text(
          widget.time,
          style: TextStyle(decoration: isChecked ? TextDecoration.lineThrough : null, color: isChecked ? Colors.grey : Colors.black54),
        ),
        leading:
            widget.showCheckbox
                ? Checkbox(
                  value: isChecked,
                  onChanged: (value) {
                    setState(() {
                      isChecked = value ?? false;
                    });
                  },
                  activeColor: widget.color ?? AppColors.secondary,
                )
                : Container(width: 10, height: 10, decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle)),
      ),
    );
  }
}
