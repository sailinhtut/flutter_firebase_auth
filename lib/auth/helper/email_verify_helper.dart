import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_auth/utils/functions.dart';

class EmailVerifyer {
  static final firebaseAuth = FirebaseAuth.instance;
  static Future<bool> sendVerifyEmail(String email) async {
    try {
      if (firebaseAuth.currentUser == null) {
        toast("You need to log in again");
        return false;
      }
      return await firebaseAuth.currentUser!.sendEmailVerification().then((_) => true);
    } on FirebaseAuthException catch (e) {
      toast(e.message!);
    } catch (e) {
      toast(e.toString());
    }
    return false;
  }
}
