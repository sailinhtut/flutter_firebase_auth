import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_auth/auth/provider/email_provider.dart';
import 'package:flutter_firebase_auth/auth/state/user_controller.dart';
import 'package:flutter_firebase_auth/utils/functions.dart';
import 'package:get/get.dart';


class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  bool isLoading = false;
  bool invisibleCurrentPassword = true;
  bool invisibleNewPassword = true;

  final Color textColor = Colors.black;
  final Color fieldTextColor = Colors.black;

  Future<void> submit() async {
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      final email = UserController.getUserData().email;
      // action
      if (email != null) {
        if (await EmailProvider.changePassword(email, currentPasswordController.text, newPasswordController.text)) {
          toast("Successfully Updated Your Password");
        }
      }
    } else {
      toast("Invalid Form");
    }

    setState(() {
      isLoading = false;
    });
  }

  InputDecoration getInputDecoration(String hintText, bool isObsecure, {bool? useObsecure, Function(bool isObsecure)? onTapEye}) {
    final border = OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black12));
    final eye = GestureDetector(
      onTap: () {
        if (onTapEye != null) onTapEye(!isObsecure);
      },
      child: Icon(isObsecure ? Icons.visibility_off : Icons.visibility),
    );
    return InputDecoration(
        suffixIcon: useObsecure != null ? eye : null,
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        hintText: hintText,
        hintStyle: const TextStyle(fontWeight: FontWeight.w400),
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    Text(
                      "Change Password",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: textColor),
                    ),
                    Text(
                      "Eu do in commodo irure excepteur occaecat in duis dolor fugiat nulla labore laboris ea.",
                      style: TextStyle(color: textColor),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: currentPasswordController,
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return "Current password is required";
                        }
                        return null;
                      },
                      obscureText: invisibleCurrentPassword,
                      decoration: getInputDecoration("Current Password", invisibleCurrentPassword, useObsecure: true, onTapEye: (value) {
                        setState(() {
                          invisibleCurrentPassword = value;
                        });
                      }),
                      style: TextStyle(color: fieldTextColor, fontWeight: FontWeight.w400),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: newPasswordController,
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return "New password is required";
                        }
                        return null;
                      },
                      obscureText: invisibleNewPassword,
                      decoration: getInputDecoration("New Password", invisibleNewPassword, useObsecure: true, onTapEye: (value) {
                        setState(() {
                          invisibleNewPassword = value;
                        });
                      }),
                      style: TextStyle(color: fieldTextColor, fontWeight: FontWeight.w400),
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 100),
                    isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            style: getSubmitButtonStyle(),
                            onPressed: submit,
                            child: const Text("Change Password"),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
