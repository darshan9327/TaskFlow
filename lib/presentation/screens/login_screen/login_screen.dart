import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_flow/presentation/common_widgets/button.dart';
import 'package:task_flow/presentation/common_widgets/text_form_field.dart';
import 'package:task_flow/presentation/screens/dashboard/dashboard.dart';
import 'package:task_flow/presentation/screens/sign_up_screen/sign_up_screen.dart';
import 'package:task_flow/presentation/theme/app_theme.dart';
import 'package:task_flow/presentation/common_widgets/appbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> logIn() async {
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = userCredential.user;
      if (user != null) {
        Get.snackbar("Success", "Welcome ${user.email}",
            snackPosition: SnackPosition.BOTTOM);
        Get.offAll(() => const Dashboard());
      }
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        message = "Wrong password provided.";
      } else {
        message = e.message ?? "Login failed";
      }
      Get.snackbar("Error", message, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "🔐 Login Screen"),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                SizedBox(height: Get.height * 0.030),

                Text("📋", style: TextStyle(fontSize: 28)),
                SizedBox(height: Get.height * 0.020),

                Text("TaskFlow", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary)),
                SizedBox(height: Get.height * 0.010),

                Divider(color: AppColors.primary, thickness: 2),
                SizedBox(height: Get.height * 0.010),

                Text("Streamline Your Productivity", style: AppTextStyles.body),
                SizedBox(height: Get.height * 0.060),

                Align(alignment: Alignment.topLeft, child: Text("Email", style: AppTextStyles.body)),
                SizedBox(height: Get.height * 0.008),

                CommonTextFormField(controller: emailController,hintText: "Enter your email",),
                SizedBox(height: Get.height * 0.020),

                Align(alignment: Alignment.topLeft, child: Text("Password", style: AppTextStyles.body)),
                SizedBox(height: Get.height * 0.008),

                CommonTextFormField(controller: passwordController,hintText: "Enter your password",keyboardType: TextInputType.visiblePassword),
                SizedBox(height: Get.height * 0.050),

                CommonContainer(
                  text: "Login",
                  onPressed: () => logIn(),
                ),
                SizedBox(height: Get.height * 0.020),
                CommonContainer(text: "Sign in with Google", color: AppColors.third, onPressed: () {}),
                SizedBox(height: Get.height * 0.030),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: "Don't have an account? ", style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w300)),
                      TextSpan(text: "Sign Up", style: AppTextStyles.body.copyWith(color: AppColors.primary, fontSize: 14), recognizer:
                      TapGestureRecognizer() ..onTap = (){
                        Get.offAll(SignUpScreen());
                      }),
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
