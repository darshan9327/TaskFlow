import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_flow/presentation/screens/user_details_screen/user_detail_mixin/user_detail_mixin.dart';
import '../../theme/app_theme.dart';
import '../../common_widgets/appbar.dart';
import 'widgets/profile_header.dart';
import 'widgets/user_form.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen>
    with UserDetailsMixin {

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Scaffold(
        appBar: CommonAppBar(title: "👤 User Details"),
        body: controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                ProfileHeader(),
                const SizedBox(height: 30),
                UserForm(
                  nameController: nameController,
                  emailController: emailController,
                  phoneController: phoneController,
                  bioController: bioController,
                  email: controller.email.value,
                ),
                const SizedBox(height: 30),
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: saveChanges,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
          ),
        ),
        child: Text(
          "Save Changes",
          style: AppTextStyles.heading3.copyWith(color: AppColors.white),
        ),
      ),
    );
  }
}