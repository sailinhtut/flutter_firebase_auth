import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_auth/utils/functions.dart';

class EmailProvider {
  static final firebaseAuth = FirebaseAuth.instance;
  static Future<UserCredential?> register(String email, String password) async {
    try {
      return await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password).then((credential) => credential);
    } on FirebaseAuthException catch (e) {
      toast(e.message!);
    } catch (e) {
      toast(e.toString());
    }

    return null;
  }

  static Future<UserCredential?> logIn(String email, String password) async {
    try {
      return await firebaseAuth.signInWithEmailAndPassword(email: email, password: password).then((credential) => credential);
    } on FirebaseAuthException catch (e) {
      toast(e.message!);
    } catch (e) {
      toast(e.toString());
    }
    return null;
  }

  static Future<bool> logOut() async {
    try {
      await firebaseAuth.signOut();
      return true;
    } on FirebaseAuthException catch (e) {
      toast(e.message!);
    } catch (e) {
      toast(e.toString());
    }
    return false;
  }

  static Future<bool> forgotPassword(String email) async {
    try {
      return await firebaseAuth.sendPasswordResetEmail(email: email).then((_) => true);
    } on FirebaseAuthException catch (e) {
      toast(e.message!);
    } catch (e) {
      toast(e.toString());
    }
    return false;
  }

  static Future<bool> changePassword(String email, String password, String newPassword) async {
    try {
      // if (firebaseAuth.currentUser != null) {
      //   return await firebaseAuth.currentUser!.updatePassword(newPassword).then((value) => true);
      // } else {
      final credential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        return credential.user!.updatePassword(newPassword).then((value) => true);
        // }
      }
    } on FirebaseAuthException catch (e) {
      toast(e.message!);
    } catch (e) {
      toast("$e");
    }

    return false;
  }

  static Future<bool> changeEmail(String email, String password, String newPassword) async {
    try {
      // if (firebaseAuth.currentUser != null) {
      //   return await firebaseAuth.currentUser!.updateEmail(newPassword).then((value) => true);
      // } else {
      final credential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        return credential.user!.updateEmail(newPassword).then((value) => true);
        // }
      }
    } catch (e) {
      toast("$e");
    }

    return false;
  }
}
