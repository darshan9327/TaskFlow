
import 'dart:io';

import '../../data/entities/user_entity_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<UserEntity> execute({
    required String fullName,
    required String email,
    required String mobileNo,
    required String password,
    File? profileImage,
  }) {
    return repository.signUp(
      fullName: fullName,
      email: email,
      mobileNo: mobileNo,
      password: password,
      profileImage: profileImage,
    );
  }
}
