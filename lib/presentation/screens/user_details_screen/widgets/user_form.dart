import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../common_widgets/text_form_field.dart';

class UserForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController bioController;
  final String email;

  const UserForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.bioController,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildEditableField("Full Name", nameController),
        const SizedBox(height: 20),
        _buildReadOnlyField("Email", email),
        const SizedBox(height: 20),
        _buildEditableField(
          "Phone Number",
          phoneController,
          maxLength: 14,
          keyboardType: TextInputType.number,
          isPhone: true,
        ),
        const SizedBox(height: 20),
        _buildEditableField("Bio", bioController, maxLines: 3),
      ],
    );
  }

  Widget _buildEditableField(
      String label,
      TextEditingController controller, {
        int maxLines = 1,
        int? maxLength,
        bool isPhone = false,
        TextInputType? keyboardType,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.body),
        const SizedBox(height: 5),
        CommonTextFormField(
          controller: controller,
          maxLines: maxLines,
          maxLength: maxLength,
          prefixText: isPhone ? '+91 ' : null,
          keyboardType: keyboardType,
        ),
      ],
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.body),
        const SizedBox(height: 5),
        CommonTextFormField(
          controller: TextEditingController(text: value),
          readonly: true,
        ),
      ],
    );
  }
}