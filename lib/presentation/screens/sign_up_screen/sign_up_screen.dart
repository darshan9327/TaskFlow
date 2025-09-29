import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_flow/data/user_repository_impl/auth_repository_impl.dart';
import 'package:task_flow/presentation/screens/login_screen/login_screen.dart';

import '../../../domain/use_cases/sign_up_use_case.dart';
import '../../common_widgets/appbar.dart';
import '../../common_widgets/button.dart';
import '../../common_widgets/text_form_field.dart';
import '../../theme/app_theme.dart';
import 'controller/sign_up_controller.dart';

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

  late final SignUpController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(SignUpController(SignUpUseCase(AuthRepositoryImpl())));
  }

  File? profileImage;
  final ImagePicker _picker = ImagePicker();

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
        onTap: () {
          FocusScope.of(context).unfocus();
        },
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

                CommonTextFormField(controller: fullNameController, hintText: "Enter your Full Name"),
                SizedBox(height: Get.height * 0.020),

                Align(alignment: Alignment.topLeft, child: Text("Email", style: AppTextStyles.body)),
                SizedBox(height: Get.height * 0.008),

                CommonTextFormField(controller: emailController, hintText: "Enter your email"),
                SizedBox(height: Get.height * 0.020),

                Align(alignment: Alignment.topLeft, child: Text("Mobile No", style: AppTextStyles.body)),
                SizedBox(height: Get.height * 0.008),

                CommonTextFormField(controller: mobileNoController, hintText: "Enter your Mobile No"),
                SizedBox(height: Get.height * 0.020),

                Align(alignment: Alignment.topLeft, child: Text("Password", style: AppTextStyles.body)),
                SizedBox(height: Get.height * 0.008),

                CommonTextFormField(controller: passwordController, hintText: "Enter your password"),
                SizedBox(height: Get.height * 0.050),

                CommonContainer(
                  text: "Sign up",
                  onPressed: () {
                    if (profileImage != null) {
                      _controller.signUp(
                        fullName: fullNameController.text.trim(),
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                        mobileNo: mobileNoController.text.trim(),
                      );
                    } else {
                      Get.snackbar('Error', 'Please select a profile picture');
                    }
                  },
                ),

                SizedBox(height: Get.height * 0.030),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: "Already have an account? ", style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w300)),
                      TextSpan(
                        text: "Login",
                        style: AppTextStyles.body.copyWith(color: AppColors.primary, fontSize: 14),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                Get.offAll(LoginScreen());
                              },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// import 'dart:io';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:task_flow/presentation/screens/dashboard/dashboard.dart';
//
// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});
//
//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }
//
// class _SignUpScreenState extends State<SignUpScreen> {
//   final TextEditingController fullNameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController mobileNoController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//
//   File? profileImage;
//   final ImagePicker _picker = ImagePicker();
//   RxBool isLoading = false.obs;
//
//   Future<void> pickImage() async {
//     final pickedFile = await _picker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 50,
//     );
//     if (pickedFile != null) {
//       setState(() {
//         profileImage = File(pickedFile.path);
//       });
//     }
//   }
//
//   Future<void> signUp() async {
//     final fullName = fullNameController.text.trim();
//     final email = emailController.text.trim();
//     final mobile = mobileNoController.text.trim();
//     final password = passwordController.text.trim();
//
//     if (fullName.isEmpty || email.isEmpty || mobile.isEmpty || password.isEmpty
//         || profileImage == null
//     ) {
//       Get.snackbar('Error', 'Please fill all fields and select profile picture');
//       return;
//     }
//
//     try {
//       isLoading.value = true;
//
//       // 1. Create user
//       final userCredential = await FirebaseAuth.instance
//           .createUserWithEmailAndPassword(email: email, password: password);
//       final userId = userCredential.user!.uid;
//
//       // 2. Upload profile picture
//       // final ref = FirebaseStorage.instance.ref().child('profile_pics/$userId.jpg');
//       // final uploadTask = ref.putFile(profileImage!);
//       //
//       // final snapshot = await uploadTask.whenComplete(() {});
//       // if (snapshot.state == TaskState.success) {
//       //   final profilePicUrl = await ref.getDownloadURL();
//       //   print("✅ Image uploaded: $profilePicUrl");
//       // } else {
//       //   print("❌ Upload failed");
//       // }
//
//       // 3. Get download URL
//       // final profilePicUrl = await ref.getDownloadURL();
//
//       // 4. Save user data in Firestore
//       await FirebaseFirestore.instance.collection('users').doc(userId).set({
//         'fullName': fullName,
//         'email': email,
//         'mobileNo': mobile,
//         // 'profilePicUrl': profilePicUrl,
//         'createdAt': FieldValue.serverTimestamp(),
//       });
//
//       Get.snackbar('Success', 'Account created successfully',snackPosition: SnackPosition.BOTTOM);
//       Get.offAll(Dashboard());
//     } catch (e) {
//       print("❌ Firestore write failed: $e");
//       Get.snackbar('Error', e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Signup Screen")),
//       body: GestureDetector(
//         onTap: () => FocusScope.of(context).unfocus(),
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(25),
//           child: Column(
//             children: [
//               SizedBox(height: 20),
//               Stack(
//                 children: [
//                   CircleAvatar(
//                     radius: 50,
//
//                     backgroundImage:
//                     profileImage != null ? FileImage(profileImage!) : null,
//                     child: profileImage == null ? Icon(Icons.person, size: 50) : null,
//                   ),
//                   Positioned(
//                     bottom: 0,
//                     right: 0,
//                     child: GestureDetector(
//                       onTap: pickImage,
//                       child: CircleAvatar(
//                         radius: 18,
//                         backgroundColor: Colors.blue,
//                         child: Icon(Icons.edit, size: 18, color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 30),
//               TextField(
//                 controller: fullNameController,
//                 decoration: InputDecoration(labelText: "Full Name"),
//               ),
//               SizedBox(height: 15),
//               TextField(
//                 controller: emailController,
//                 decoration: InputDecoration(labelText: "Email"),
//               ),
//               SizedBox(height: 15),
//               TextField(
//                 controller: mobileNoController,
//                 decoration: InputDecoration(labelText: "Mobile No"),
//               ),
//               SizedBox(height: 15),
//               TextField(
//                 controller: passwordController,
//                 decoration: InputDecoration(labelText: "Password"),
//                 obscureText: true,
//               ),
//               SizedBox(height: 30),
//               Obx(() => isLoading.value
//                   ? CircularProgressIndicator()
//                   : ElevatedButton(
//                 onPressed: signUp,
//                 child: Text("Sign Up"),
//               )),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
