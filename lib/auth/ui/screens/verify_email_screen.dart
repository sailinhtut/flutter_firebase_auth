import "dart:async";

import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart" as auth;
import "package:flutter_firebase_auth/utils/functions.dart";

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key, required this.authorizedUser, required this.onVerified});

  final auth.User authorizedUser;
  final VoidCallback onVerified;

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final Color textColor = Colors.black;

  Timer? updateListenTimer;

  Future<void> sendVerifyEmail() async {
    try {
      await widget.authorizedUser.sendEmailVerification();
    } on auth.FirebaseAuthException catch (e) {
      toast(e.message!);
    } catch (e) {
      toast(e.toString());
    }
  }

  Future<void> listenVerifyUpdates() async {
    updateListenTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      final currentUser = auth.FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        timer.cancel();
      }
      currentUser!.reload();
      if (currentUser.emailVerified) {
        widget.onVerified();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    sendVerifyEmail();
    listenVerifyUpdates();
  }

  @override
  void dispose() {
    if (updateListenTimer != null) {
      updateListenTimer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Verify Email",
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 25),
            ),
            const SizedBox(height: 20),
            Text(
              "Incididunt nisi nulla elit qui elit mollit et minim dolor esse cupidatat occaecat voluptate mollit. Fugiat quis irure eu esse. ",
              style: TextStyle(color: textColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            TextButton(
                onPressed: () async {
                  await sendVerifyEmail();
                },
                child: const Text("Resend"))
          ],
        ),
      ),
    ));
  }
}
