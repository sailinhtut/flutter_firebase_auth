import "package:firebase_core/firebase_core.dart";
import "package:flutter_firebase_auth/auth/helper/user_helper.dart";
import "package:flutter_firebase_auth/auth/model/user.dart";
import "package:flutter_firebase_auth/auth/service/user_service.dart";
import "package:flutter_firebase_auth/auth/ui/screens/log_in_screen.dart";
import "package:flutter_firebase_auth/utils/functions.dart";
import "package:get/get.dart";

import "package:firebase_auth/firebase_auth.dart" as auth;

class UserController extends GetxController {
  String? _uid;
  String? name;
  String? email;
  String? phone;
  String? image;

  @override
  void onInit() {
    super.onInit();
    auth.FirebaseAuth.instance.userChanges().listen(_handleUserChanges);
  }

  void _handleUserChanges(auth.User? user) {
    if (user == null) Get.offAll(() => const LogInScreen());
  }

  String get userID {
    if (_uid == null) toast("User ID is null");
    return _uid!;
  }

  static String get getUserID {
    return Get.find<UserController>().userID;
  }

  static Future<void> setUserData(User userData) async {
    await Get.find<UserController>()._setUserData(userData);
  }

  static User getUserData() {
    return Get.find<UserController>()._getUserData();
  }

  static Future<void> updateUserData({String? updateEmail, String? updateName, String? updatePhone, String? updateImage}) async {
    await Get.find<UserController>()._updateUserData(
      updateEmail: updateEmail,
      updateName: updateName,
      updatePhone: updatePhone,
      updateImage: updateImage,
    );
  }

  static Future<void> clearSession() async {
    await Get.find<UserController>()._clearSession();
  }

  Future<void> _setUserData(User userData) async {
    if (userData.uid == null) {
      Get.offAll(() => const LogInScreen());
      return;
    }

    name = userData.name ?? name;
    _uid = userData.uid;
    email = userData.email ?? email;
    phone = userData.phone ?? phone;
    image = userData.image ?? image;

    await UserHelper.saveUserData(_getUserData());

    _rebuildChild();
  }

  User _getUserData() {
    return User(uid: userID, name: name, email: email, phone: phone, image: image);
  }

  Future<void> _updateUserData({String? updateEmail, String? updateName, String? updatePhone, String? updateImage}) async {
    name = updateName ?? name;
    email = updateEmail ?? email;
    phone = updatePhone ?? phone;
    image = updateImage ?? image;

    await UserServices.updateUserData(_getUserData());
    await UserHelper.saveUserData(_getUserData());

    _rebuildChild();
  }

  Future<void> _clearSession() async {
    try {
      await UserHelper.clearUser();
      _uid = null;
      name = null;
      email = null;
      image = null;
      phone = null;
    } catch (e) {
      toast(e.toString());
    }
  }

  _rebuildChild() => update();
}
