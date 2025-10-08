import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> logIn() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = userCredential.user;
      if (user != null && mounted) {
        final token = await FirebaseMessaging.instance.getToken();

        if (token != null) {
          await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
            'fcmToken': token,
          });
          print("✅ FCM token updated on login for ${user.email}");
        }

        Get.snackbar(
          "Success",
          "Welcome ${user.email}",
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offAll(() => const Dashboard());
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
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
      if (!mounted) return;
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "🔐 Login Screen"),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Form(
          key: _formKey,
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

                  CommonTextFormField(
                    controller: emailController,
                    hintText: "Enter your email",
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Email is required";
                      } else if (!GetUtils.isEmail(value.trim())) {
                        return "Enter a valid email";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: Get.height * 0.020),

                  Align(alignment: Alignment.topLeft, child: Text("Password", style: AppTextStyles.body)),
                  SizedBox(height: Get.height * 0.008),

                  CommonTextFormField(
                    controller: passwordController,
                    hintText: "Enter your password",
                    obscureText: _obscurePassword,
                    suffix: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Password is required";
                      } else if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: Get.height * 0.050),

                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : CommonContainer(text: "Login",onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      logIn();
                    }
                  }),

                  SizedBox(height: Get.height * 0.020),
                  CommonContainer(text: "Sign in with Google", color: AppColors.third, onPressed: () {}),
                  SizedBox(height: Get.height * 0.030),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? ", style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w300)),
                      TextButton(
                        onPressed: () => Get.offAll(SignUpScreen(), transition: Transition.downToUp, duration: const Duration(milliseconds: 500)),
                        child: Text("Sign Up", style: AppTextStyles.body.copyWith(color: AppColors.primary, fontSize: 14)),
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
