import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

Widget buildDropdown(
    String label,
    List<String> items,
    String selected,
    Function(String) onChanged,
    String hint,
    ) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: AppTextStyles.body),
      const SizedBox(height: 6),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selected.isEmpty ? null : selected,
            hint: Text(hint),
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down),
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: (val) => onChanged(val!),
          ),
        ),
      ),
    ],
  );
}
