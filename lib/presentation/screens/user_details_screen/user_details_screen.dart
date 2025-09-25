import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_flow/presentation/common_widgets/text_form_field.dart';
import '../../common_widgets/appbar.dart';
import '../../theme/app_theme.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  String name = "John Doe";
  String email = "johndoe@example.com";
  String phone = "+91 9876543210";
  String bio = "I love managing my tasks efficiently!";

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController bioController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: name);
    phoneController = TextEditingController(text: "+91 ");
    bioController = TextEditingController(text: bio);
    emailController = TextEditingController(text: email);
    phoneController.addListener(() {
      if (!phoneController.text.startsWith("+91 ")) {
        phoneController.text = "+91 ";
        phoneController.selection = TextSelection.fromPosition(TextPosition(offset: phoneController.text.length));
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    bioController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void saveUserDetails() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        name = nameController.text;
        phone = phoneController.text;
        bio = bioController.text;
      });

      Get.snackbar("Success", "User details updated successfully", snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CommonAppBar(title: "👤  User Details"),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(radius: 50, backgroundImage: const AssetImage("assets/images/profile_placeholder.png")),
                TextButton.icon(onPressed: () {}, icon: const Icon(Icons.edit), label: const Text("Change Picture")),
                const SizedBox(height: 30),
                _buildEditableField(
                  "Full Name",
                  nameController,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return "Name cannot be empty";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildReadOnlyField("Email", emailController.text),
                const SizedBox(height: 20),
                _buildEditableField(
                  "Phone Number",
                  phoneController,
                  keyboardType: TextInputType.phone,
                  maxLength: 14,
                  validator: (val) {
                    if (val == null || val.trim().length < 13) {
                      return "Enter a valid phone number";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildEditableField(
                  "Bio",
                  bioController,
                  maxLines: 3,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return "Bio cannot be empty";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: saveUserDetails,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Save Changes", style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    int maxLength = 50,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.body),
        const SizedBox(height: 5),
        CommonTextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          maxLength: maxLength,
          readonly: false,
          validator: validator,
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
        CommonTextFormField(controller: TextEditingController(text: value), readonly: true, keyboardType: TextInputType.text),
      ],
    );
  }
}
