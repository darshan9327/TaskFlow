import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FcmTokenService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  /// Get the current device token
  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  /// Save or update token in Firestore for the current user
  Future<void> saveTokenToFirestore(String userId) async {
    final token = await getToken();
    if (token != null) {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({'fcmToken': token});
      print('✅ FCM token saved for user $userId');
    }
  }

  /// Listen for token refresh and update Firestore automatically
  // void handleTokenRefresh(String userId) {
  //   _firebaseMessaging.onTokenRefresh.listen((newToken) async {
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(userId)
  //         .update({'fcmToken': newToken});
  //     print('🔁 FCM token refreshed for user $userId');
  //   });
  // }
}
