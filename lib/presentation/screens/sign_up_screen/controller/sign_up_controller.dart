import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import '../../../../domain/use_cases/sign_up_use_case.dart';
import '../../login_screen/login_screen.dart';

class SignUpController extends GetxController {
  final SignUpUseCase _signUpUseCase;
  var isLoading = false.obs;
  var isCheckingVerification = false.obs;
  var hasCompletedRegistration = false.obs;

  SignUpController(this._signUpUseCase);

  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
    required String mobileNo,
    required String role,
  }) async {
    final auth = FirebaseAuth.instance;

    try {
      isLoading.value = true;
      hasCompletedRegistration.value = false;

      await _requestNotificationPermission();

      UserCredential userCredential;
      bool isNewUser = true;

      try {
        userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          isNewUser = false;
          userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);

          final user = userCredential.user;
          if (user != null && user.emailVerified) {
            final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

            if (doc.exists) {
              Get.snackbar(
                "Info",
                "Account already verified. Please login.",
                duration: const Duration(seconds: 2),
                snackPosition: SnackPosition.BOTTOM,
              );
              Get.offAll(() => LoginScreen());
              return;
            } else {
              final fcmToken = await FirebaseMessaging.instance.getToken();
              await _saveUserToFirestore(
                user: user,
                fullName: fullName,
                email: email,
                mobileNo: mobileNo,
                role: role,
                userDeviceToken: fcmToken ?? '',
              );
              hasCompletedRegistration.value = true;
              Get.snackbar("Success", "Registration complete!", duration: const Duration(seconds: 2), snackPosition: SnackPosition.BOTTOM);
              Get.offAll(() => LoginScreen());
              return;
            }
          }
        } else {
          rethrow;
        }
      }

      final user = userCredential.user;
      if (user == null) {
        Get.snackbar("Error", "Failed to create user account", duration: const Duration(seconds: 2), snackPosition: SnackPosition.BOTTOM);
        return;
      }

      if (user.emailVerified) {
        final fcmToken = await FirebaseMessaging.instance.getToken();

        await _saveUserToFirestore(user: user, fullName: fullName, email: email, mobileNo: mobileNo, role: role, userDeviceToken: fcmToken ?? '');

        hasCompletedRegistration.value = true;
        Get.snackbar("Success", "Registration complete!", duration: const Duration(seconds: 2), snackPosition: SnackPosition.BOTTOM);
        Get.offAll(() => LoginScreen());
        return;
      }

      await user.sendEmailVerification();
      Get.snackbar("Verify Email", "Verification link sent to $email. Please check your inbox.", duration: const Duration(seconds: 4));
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkVerificationAndComplete({required String fullName, required String email, required String mobileNo, required String role}) async {
    if (hasCompletedRegistration.value) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      isCheckingVerification.value = true;

      await user.reload();
      final refreshedUser = FirebaseAuth.instance.currentUser;

      if (refreshedUser != null && refreshedUser.emailVerified) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(refreshedUser.uid).get();

        if (!doc.exists) {
          final fcmToken = await FirebaseMessaging.instance.getToken();
          await _saveUserToFirestore(
            user: refreshedUser,
            fullName: fullName,
            email: email,
            mobileNo: mobileNo,
            role: role,
            userDeviceToken: fcmToken ?? '',
          );
        }

        await _saveDeviceToken(refreshedUser.uid);

        hasCompletedRegistration.value = true;
        Get.snackbar("Success", "Email verified successfully!", duration: const Duration(seconds: 2), snackPosition: SnackPosition.BOTTOM);
        Get.offAll(() => LoginScreen());
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to check verification: ${e.toString()}",
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isCheckingVerification.value = false;
    }
  }

  Future<void> _saveUserToFirestore({
    required User user,
    required String fullName,
    required String email,
    required String mobileNo,
    required String role,
    required String userDeviceToken,
  }) async {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'fullName': fullName,
      'email': email,
      'mobileNo': mobileNo,
      'role': role,
      'fcmToken': userDeviceToken,
      'emailVerified': true,
      'createdAt': FieldValue.serverTimestamp(),
    });

    try {
      await _signUpUseCase.execute(fullName: fullName, email: email, password: '', mobileNo: mobileNo, role: role);
    } catch (e) {
      print('⚠️ Backend sync error: $e');
    }
  }

  Future<void> _saveDeviceToken(String uid) async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({'fcmToken': token});
        print("✅ FCM Token saved for user: $uid");
      }
    } catch (e) {
      print("⚠️ Failed to save device token: $e");
    }
  }

  Future<void> _requestNotificationPermission() async {
    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(alert: true, badge: true, sound: true, provisional: false);
  }

  @override
  void onClose() {
    super.onClose();
  }
}
