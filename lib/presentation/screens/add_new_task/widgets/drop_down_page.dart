import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

Widget buildDropdown(String label, List<String> items, String selected, Function(String) onChanged) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: AppTextStyles.heading4),
      SizedBox(height: 6),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8), color: Colors.white),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selected,
            isExpanded: true,
            icon: Icon(Icons.keyboard_arrow_down),
            items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
            onChanged: (val) => onChanged(val!),
          ),
        ),
      ),
    ],
  );
}
