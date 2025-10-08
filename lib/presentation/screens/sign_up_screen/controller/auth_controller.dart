import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var isEmailVerified = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkEmailVerification();
  }

  Future<void> checkEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
      isEmailVerified.value = user.emailVerified;
    }
  }
}
