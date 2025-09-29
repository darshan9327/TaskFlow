import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/user_repository_impl/auth_repository_impl.dart';
import '../../../domain/use_cases/get_user_details_usecase.dart';
import '../../theme/app_theme.dart';
import '../../common_widgets/text_form_field.dart';
import '../../common_widgets/appbar.dart';
import 'controller/user_profile_controller.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  // Use Get.find() if controller already exists, otherwise put it
  late final ProfileController controller;

  // TextEditingControllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    try {
      controller = Get.find<ProfileController>();
    } catch (e) {
      controller = Get.put(
        ProfileController(
          GetUserDetailsUseCase(UserRepositoryImpl()),
          UpdateUserDetailsUseCase(UserRepositoryImpl()),
        ),
        permanent: true,
      );
    }
    _populateFields();
    if (controller.email.value.isEmpty) {
      controller.fetchUser().then((_) => _populateFields());
    }
    _setupReactiveUpdates();
  }

  void _populateFields() {
    emailController.text = controller.email.value;
    nameController.text = controller.name.value;
    phoneController.text =
    controller.phone.value.isEmpty ? '+91' : controller.phone.value;
    bioController.text = controller.bio.value;
  }

  void _setupReactiveUpdates() {
    ever(controller.email, (_) {
      if (emailController.text != controller.email.value) {
        emailController.text = controller.email.value;
      }
    });

    ever(controller.name, (_) {
      if (nameController.text != controller.name.value) {
        nameController.text = controller.name.value;
      }
    });

    ever(controller.phone, (_) {
      String phoneValue = controller.phone.value.isEmpty ? '+91' : controller.phone.value;
      if (phoneController.text != phoneValue) {
        phoneController.text = phoneValue;
      }
    });

    ever(controller.bio, (_) {
      if (bioController.text != controller.bio.value) {
        bioController.text = controller.bio.value;
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    phoneController.dispose();
    bioController.dispose();
    super.dispose();
  }

  void saveChanges() {
    if (_formKey.currentState!.validate()) {
      controller.name.value = nameController.text.trim();
      controller.phone.value = phoneController.text.trim();
      controller.bio.value = bioController.text.trim();
      controller.updateUser();
    }
  }

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
            key: _formKey,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: const AssetImage(
                      "assets/images/profile_placeholder.png"),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit),
                  label: const Text("Change Picture"),
                ),
                const SizedBox(height: 30),
                _buildEditableField("Full Name", nameController),
                const SizedBox(height: 20),
                _buildReadOnlyField("Email", controller.email.value),
                const SizedBox(height: 20),
                _buildEditableField("Phone Number", phoneController, maxLength: 14, keyboardType: TextInputType.number),
                const SizedBox(height: 20),
                _buildEditableField("Bio", bioController, maxLines: 3),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      "Save Changes",
                      style: AppTextStyles.heading3.copyWith(color: AppColors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller,
      {int maxLines = 1, int? maxLength, bool isPhone = false, TextInputType? keyboardType}) {
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
          keyboardType: keyboardType
        ),
      ],
    );
  }

  Widget _buildReadOnlyField(String label, String name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.body),
        const SizedBox(height: 5),
        CommonTextFormField(
            controller: TextEditingController(text: name),
            readonly: true
        ),
      ],
    );
  }
}