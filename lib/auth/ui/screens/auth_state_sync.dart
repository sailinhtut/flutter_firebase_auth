import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/auth/ui/screens/log_in_screen.dart';
import 'package:flutter_firebase_auth/main.dart';

class AuthStateStync extends StatelessWidget {
  const AuthStateStync({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (_, AsyncSnapshot<User?> snapshot) {
        if (snapshot.hasData) {
          return const MyHomePage();
        }
        return const LogInScreen();
      },
    );
  }
}
