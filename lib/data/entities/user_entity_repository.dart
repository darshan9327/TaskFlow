import 'dart:io';

class UserEntity {
  final String uid;
  final String fullName;
  final String email;
  final String mobileNo;
  final String? profilePicUrl;

  UserEntity({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.mobileNo,
    this.profilePicUrl,
  });
}

abstract class AuthRepository {
  Future<UserEntity> signUp({
    required String fullName,
    required String email,
    required String mobileNo,
    required String password,
    File? profileImage,
  });
}
