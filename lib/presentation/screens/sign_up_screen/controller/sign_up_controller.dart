import 'dart:io';
import 'package:get/get.dart';
import '../../../../domain/use_cases/sign_up_use_case.dart';
import '../../dashboard/dashboard.dart';

class SignUpController extends GetxController {
  final SignUpUseCase _signUpUseCase;

  SignUpController(this._signUpUseCase);

  RxBool isLoading = false.obs;

  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
    required String mobileNo,
    File? profilePic,
  }) async {
    try {
      isLoading.value = true;

      await _signUpUseCase.execute(
        fullName: fullName,
        email: email,
        password: password,
        mobileNo: mobileNo,
        profileImage: profilePic,
      );

      Get.snackbar(
        'Success',
        'Account created successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

      Get.offAll(() => Dashboard());
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
