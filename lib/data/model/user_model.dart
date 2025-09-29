import '../entities/user_entity_repository.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.uid,
    required super.fullName,
    required super.email,
    required super.mobileNo,
    super.profilePicUrl,
    this.bio = '', // add bio
  });

  final String bio;

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'mobileNo': mobileNo,
      'profilePicUrl': profilePicUrl,
      'bio': bio, // include bio
      'createdAt': DateTime.now(),
    };
  }

  factory UserModel.fromMap(String uid, Map<String, dynamic> map) {
    return UserModel(
      uid: uid,
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      mobileNo: map['mobileNo'] ?? '',
      profilePicUrl: map['profilePicUrl'],
      bio: map['bio'] ?? '',
    );
  }
}
