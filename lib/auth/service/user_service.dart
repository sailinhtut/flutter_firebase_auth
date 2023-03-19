import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_auth/auth/model/user.dart';
import 'package:flutter_firebase_auth/auth/state/user_controller.dart';

class UserServices {
  static final _firestore = FirebaseFirestore.instance.collection("app-users");

  static Future<User?> createUserData(String uid, {required String newEmail, String? newName, String? newPhone, String? newImage}) async {
    User userData = User(uid: uid, email: newEmail, name: newName, phone: newPhone, image: newImage);
    try {
      return await _firestore.doc(uid).set(userData.toJson()).then((docRef) {
        return userData;
      });
    } catch (e) {
      return null;
    }
  }

  static Future<bool> updateUserData(User updateUserData) async {
    try {
      await _firestore.doc(UserController.getUserID).update(updateUserData.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<User?> getUserData(String userId) async {
    try {
      return await _firestore.doc(userId).get().then((docSnap) {
        if (docSnap.exists) {
          final userData = User.fromJson(docSnap.data()!);
          return userData;
        }

        return null;
      });
    } catch (e) {
      print(">>> Getting Userdata Error : $e");
      return null;
    }
  }
}
