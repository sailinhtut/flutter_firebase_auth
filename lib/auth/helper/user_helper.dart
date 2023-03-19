import 'package:flutter_firebase_auth/auth/model/user.dart';
import 'package:flutter_firebase_auth/auth/state/user_controller.dart';
import 'package:flutter_firebase_auth/main.dart';

class UserHelper {
  static Future<void> saveUserData(User user) async {
    pref.setString("uid", UserController.getUserID);

    if (user.name != null) {
      pref.setString("name", user.name!);
    } else {
      pref.remove("name");
    }
    if (user.email != null) {
      pref.setString("email", user.email!);
    } else {
      pref.remove("email");
    }
    if (user.image != null) {
      pref.setString("image", user.image!);
    } else {
      pref.remove("image");
    }
    if (user.phone != null) {
      pref.setString("phone", user.phone!);
    } else {
      pref.remove("phone");
    }
  }

  static Future<User> loadUserData() async {
    final userData = User(
      uid: pref.getString("uid"),
      name: pref.getString("name"),
      email: pref.getString("email"),
      image: pref.getString("image"),
      phone: pref.getString("phone"),
    );

    return userData;
  }

  static Future<void> clearUser() async {
    pref.remove("uid");
    pref.remove("name");
    pref.remove("email");
    pref.remove("image");
    pref.remove("phone");
  }
}
