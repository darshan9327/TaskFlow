import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_flow/domain/repositories/auth_repository.dart';
import 'package:task_flow/presentation/screens/login_screen/login_screen.dart';
import '../../../domain/use_cases/sign_up_use_case.dart';
import '../../common_widgets/appbar.dart';
import '../../common_widgets/button.dart';
import '../../common_widgets/text_form_field.dart';
import '../../theme/app_theme.dart';
import 'controller/sign_up_controller.dart';
import 'package:task_flow/presentation/screens/sign_up_screen/widgets/drop_down_page.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late final SignUpController _controller;

  final List<String> roles = ['Select Role', 'User', 'Manager', 'Master'];
  String selectedRole = 'Select Role';

  File? profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _controller = Get.put(SignUpController(SignUpUseCase(AuthRepositoryImpl())));
  }

  Future<void> pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "🔐 Signup Screen"),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  SizedBox(height: Get.height * 0.030),
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: profileImage != null ? FileImage(profileImage!) : null,
                        child: profileImage == null ? Icon(Icons.person, size: 40) : null,
                      ),
                      Positioned(
                        bottom: -18,
                        right: -1,
                        child: GestureDetector(
                          onTap: pickImageFromGallery,
                          child: Container(
                            height: Get.height * 0.070,
                            width: Get.width * 0.070,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(width: 2, color: AppColors.white),
                              color: AppColors.primary,
                            ),
                            child: Icon(Icons.edit, size: 17),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Get.height * 0.050),

                  Align(alignment: Alignment.topLeft, child: Text("Full Name", style: AppTextStyles.body)),
                  SizedBox(height: Get.height * 0.008),
                  CommonTextFormField(
                    controller: fullNameController,
                    hintText: "Enter your Full Name",
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return "Full Name is required";
                      return null;
                    },
                  ),
                  SizedBox(height: Get.height * 0.020),

                  Align(alignment: Alignment.topLeft, child: Text("Email", style: AppTextStyles.body)),
                  SizedBox(height: Get.height * 0.008),
                  CommonTextFormField(
                    controller: emailController,
                    hintText: "Enter your email",
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return "Email is required";
                      if (!GetUtils.isEmail(value.trim())) return "Enter a valid email";
                      return null;
                    },
                  ),
                  SizedBox(height: Get.height * 0.020),

                  Align(alignment: Alignment.topLeft, child: Text("Mobile No", style: AppTextStyles.body)),
                  SizedBox(height: Get.height * 0.008),
                  CommonTextFormField(
                    controller: mobileNoController,
                    hintText: "Enter your Mobile No",
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return "Mobile number is required";
                      if (value.trim().length != 10) return "Enter a valid 10-digit mobile number";
                      return null;
                    },
                  ),
                  SizedBox(height: Get.height * 0.020),

                  buildDropdown(
                    "Role",
                    roles,
                    selectedRole,
                        (val) => setState(() => selectedRole = val),
                    "Select your Role",
                  ),
                  SizedBox(height: Get.height * 0.020),

                  Align(alignment: Alignment.topLeft, child: Text("Password", style: AppTextStyles.body)),
                  SizedBox(height: Get.height * 0.008),
                  CommonTextFormField(
                    controller: passwordController,
                    hintText: "Enter your password",
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return "Password is required";
                      if (value.length < 6) return "Password must be at least 6 characters";
                      return null;
                    },
                  ),
                  SizedBox(height: Get.height * 0.050),

                  Obx(
                        () => _controller.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : CommonContainer(
                      text: "Sign up",
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) return;

                        if (profileImage == null) {
                          Get.snackbar('Error', 'Please select a profile picture');
                          return;
                        }

                        if (selectedRole.isEmpty) {
                          Get.snackbar('Error', 'Please select a role');
                          return;
                        }

                        _controller.signUp(
                          fullName: fullNameController.text.trim(),
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                          mobileNo: mobileNoController.text.trim(),
                          profilePic: profileImage,
                          role: selectedRole,
                        );
                      },
                    ),
                  ),

                  SizedBox(height: Get.height * 0.030),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?", style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w300)),
                      TextButton(
                        onPressed: () => Get.offAll(
                          LoginScreen(),
                          transition: Transition.upToDown,
                          duration: const Duration(milliseconds: 500),
                        ),
                        child: Text("Login", style: AppTextStyles.body.copyWith(color: AppColors.primary, fontSize: 14)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
