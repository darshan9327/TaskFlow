import 'package:flutter/material.dart';
import 'package:task_flow/presentation/theme/app_theme.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String time;
  final String status;
  final Color? color;
  // final bool showCheckbox;
  // final ValueChanged<bool?>? onStatusChanged;
  final VoidCallback? onTap;

  TaskCard({
    super.key,
    required this.title,
    required this.time,
    required this.status,
    this.color,
    // this.showCheckbox = false,
    // this.onStatusChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusLower = status.toLowerCase();
    final isCompleted = statusLower == "completed";

    final Color statusColor = AppColors.getStatusColor(statusLower);
    final String displayStatus = _capitalize(statusLower);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border(
            left: BorderSide(color: statusColor, width: 4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: ListTile(
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          // leading: showCheckbox
          //     ? Transform.scale(
          //   scale: 1.1,
          //   child: Checkbox(
          //     value: isCompleted,
          //     onChanged: onStatusChanged,
          //     activeColor: statusColor,
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(4),
          //     ),
          //   ),
          // )
          //     : Container(
          //   width: 12,
          //   height: 12,
          //   decoration: BoxDecoration(
          //     color: statusColor,
          //     shape: BoxShape.circle,
          //   ),
          // ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isCompleted ? Colors.grey : Colors.black,
              decoration: isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    time,
                    style: TextStyle(
                      fontSize: 13,
                      color: isCompleted ? Colors.grey : Colors.black54,
                      decoration:
                      isCompleted ? TextDecoration.lineThrough : null,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6),
                _buildStatusChip(displayStatus, statusColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }


  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}
