import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class CommonTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? hintText;
  final int? maxLines;
  final int? maxLength;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;
  final Widget? prefix;
  final Widget? suffix;
  final bool? readonly;
  final Color? hintColor;
  final bool obscureText;

  const CommonTextFormField({
    super.key,
    required this.controller,
    this.keyboardType,
    this.hintText,
    this.maxLines = 1,
    this.maxLength,
    this.validator,
    this.focusNode,
    this.prefix,
    this.readonly,
    this.hintColor,
    this.suffix,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: obscureText ? 1 : maxLines,
      maxLength: maxLength,
      cursorColor: AppColors.black,
      readOnly: readonly ?? false,
      obscureText: obscureText,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      buildCounter: (_, {required int currentLength, required bool isFocused, int? maxLength}) => null,

      decoration: InputDecoration(
        prefixIcon: prefix,
        suffixIcon: suffix,
        isDense: true,
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 11, horizontal: 15),
        hintText: hintText,
        hintStyle: TextStyle(color: hintColor ?? Colors.grey.shade500, fontSize: 16),

        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300, width: 1)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300, width: 1)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColors.error, width: 1)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColors.error, width: 1)),
        errorMaxLines: 2,
      ),
    );
  }
}
