import 'dart:io';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepositoryImpl _repository;

  SignUpUseCase(this._repository);

  Future<void> execute({
    required String fullName,
    required String email,
    required String password,
    required String mobileNo,
    File? profileImage,
    String role = "user",
  }) async {
    await _repository.signUp(
      fullName: fullName,
      email: email,
      password: password,
      mobileNo: mobileNo,
      profileImage: profileImage,
      role: role
    );
  }
}

