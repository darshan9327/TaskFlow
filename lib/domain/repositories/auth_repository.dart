import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../data/entities/user_entity_repository.dart';
import '../../data/model/user_model.dart';

// ======================= SignUp =======================//

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<UserEntity> signUp({
    required String fullName,
    required String email,
    required String mobileNo,
    required String password,
    File? profileImage,
    String role = "user",
  }) async {
    final userCredential =
    await _auth.createUserWithEmailAndPassword(email: email, password: password);
    final uid = userCredential.user!.uid;

    String? profilePicUrl;

    final userModel = UserModel(
      uid: uid,
      fullName: fullName,
      email: email,
      mobileNo: mobileNo,
      profilePicUrl: profilePicUrl,
      role: role,
    );

    await _firestore.collection('users').doc(uid).set(userModel.toMap());
    return userModel;
  }
}

// ======================= GetUserDetails =======================//

abstract class UserRepository {
  Future<Map<String, dynamic>> getUserDetails(String uid);
  Future<void> updateUserDetails(String uid, Map<String, dynamic> data);
}
class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Map<String, dynamic>> getUserDetails(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return doc.data()!;
    } else {
      throw Exception("User not found");
    }
  }

  @override
  Future<void> updateUserDetails(String uid, Map<String, dynamic> data) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .set(data, SetOptions(merge: true));
  }
}
