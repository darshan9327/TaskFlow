import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../domain/use_cases/get_user_details_use_case.dart';

class ProfileController extends GetxController {
  final GetUserDetailsUseCase getUserUseCase;
  final UpdateUserDetailsUseCase updateUserUseCase;

  ProfileController(this.getUserUseCase, this.updateUserUseCase);

  RxBool isLoading = false.obs;
  RxString name = ''.obs;
  RxString email = ''.obs;
  RxString phone = ''.obs;
  RxString bio = ''.obs;
  RxString role = ''.obs;

  Future<void> fetchUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      isLoading.value = true;
      final data = await getUserUseCase.execute(user.uid);
      name.value = data['fullName'] ?? '';
      email.value = data['email'] ?? '';
      phone.value = data['mobileNo'] ?? '';
      bio.value = data['bio'] ?? '';
      role.value = data['role'] ?? 'User';
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch user data: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      isLoading.value = true;

      await updateUserUseCase.execute(user.uid, {
        'fullName': name.value,
        'mobileNo': phone.value,
        'bio': bio.value,
        'role': role.value,
      });
      phone.value = phone.value;

      Get.snackbar(
        'Success',
        'User details updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update user data: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
