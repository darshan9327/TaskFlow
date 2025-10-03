import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../domain/repositories/auth_repository.dart';
import '../../../../domain/use_cases/get_user_details_use_case.dart';
import '../controller/user_profile_controller.dart';

mixin UserDetailsMixin<T extends StatefulWidget> on State<T> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late final ProfileController controller;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeController();
    _populateFields();
    _fetchDataIfEmpty();
    _setupReactiveUpdates();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _initializeController() {
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
  }
  void _populateFields() {
    emailController.text = controller.email.value;
    nameController.text = controller.name.value;
    phoneController.text = controller.phone.value.isEmpty
        ? '+91'
        : controller.phone.value;
    bioController.text = controller.bio.value;
  }

  void _fetchDataIfEmpty() {
    if (controller.email.value.isEmpty) {
      controller.fetchUser().then((_) => _populateFields());
    }
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
      String phoneValue = controller.phone.value.isEmpty
          ? '+91'
          : controller.phone.value;
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

  void _disposeControllers() {
    emailController.dispose();
    nameController.dispose();
    phoneController.dispose();
    bioController.dispose();
  }

  void saveChanges() {
    if (formKey.currentState!.validate()) {
      controller.name.value = nameController.text.trim();
      controller.phone.value = phoneController.text.trim();
      controller.bio.value = bioController.text.trim();
      controller.updateUser();
    }
  }
}