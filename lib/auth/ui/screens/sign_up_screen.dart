// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/auth/provider/email_provider.dart';
import 'package:flutter_firebase_auth/auth/service/user_service.dart';
import 'package:flutter_firebase_auth/auth/state/user_controller.dart';
import 'package:flutter_firebase_auth/auth/ui/screens/log_in_screen.dart';
import 'package:flutter_firebase_auth/utils/functions.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isLoading = false;
  bool invisiblePassword = true;

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> submit() async {
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      // action
      final credential = await EmailProvider.register(emailController.text, passwordController.text);
      final userData = credential == null
          ? null
          : await UserServices.createUserData(credential.user!.uid, newEmail: emailController.text, newName: nameController.text);
      if (userData != null) {
        UserController.setUserData(userData);
        toast("Created Account");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LogInScreen()));
      }
    } else {
      toast("Invalid Form");
    }

    setState(() {
      isLoading = false;
    });
  }

  InputDecoration getInputDecoration(String hintText, {bool? useObsecure}) {
    final border = OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black12));
    final eye = GestureDetector(
      onTap: () {
        setState(() {
          invisiblePassword = !invisiblePassword;
        });
      },
      child: Icon(invisiblePassword ? Icons.visibility_off : Icons.visibility),
    );
    return InputDecoration(
        suffixIcon: useObsecure != null ? eye : null,
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        hintText: hintText,
        filled: true,
        fillColor: const Color(0xfff1f1f1),
        contentPadding: const EdgeInsets.all(10));
  }

  ButtonStyle getSubmitButtonStyle() {
    return ElevatedButton.styleFrom(
        minimumSize: const Size(double.maxFinite, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    style: const TextStyle(fontWeight: FontWeight.w400),
                    controller: nameController,
                    decoration: getInputDecoration("Name"),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    autofillHints: const [AutofillHints.name],
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return "Name is required";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    style: const TextStyle(fontWeight: FontWeight.w400),
                    controller: emailController,
                    decoration: getInputDecoration("Email"),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return "Email is required";
                      } else if (!value!.contains("@gmail.com")) {
                        return "Invalid Email";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    style: const TextStyle(fontWeight: FontWeight.w400),
                    controller: passwordController,
                    decoration: getInputDecoration("Password", useObsecure: true),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.visiblePassword,
                    autofillHints: const [AutofillHints.password],
                    obscureText: invisiblePassword,
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return "Password is required";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 50),
                  isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          style: getSubmitButtonStyle(),
                          onPressed: submit,
                          child: const Text("Create Account"),
                        ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have account ?"),
                      const SizedBox(width: 5),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LogInScreen()));
                          },
                          child: const Text("Log In"))
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
