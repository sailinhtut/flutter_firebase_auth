import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_auth/auth/provider/email_provider.dart';
import 'package:flutter_firebase_auth/utils/functions.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  bool isLoading = false;

  final Color textColor = Colors.black;
  final Color fieldTextColor = Colors.black;
 

  Future<void> submit() async {
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      // action
      if (await EmailProvider.forgotPassword(emailController.text)) {
        toast("Reset Password Password Email Sent");
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  InputDecoration getInputDecoration(String hintText, {bool? useObsecure}) {
    final border = OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black12));

    return InputDecoration(
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
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.17),
                  Text(
                    "Forgot Password ?",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: textColor),
                  ),
                  Text(
                    "Eu do in commodo irure excepteur occaecat in duis dolor fugiat nulla labore laboris ea.",
                    style: TextStyle(color: textColor),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return "Email is required";
                      }
                      return null;
                    },
                    decoration: getInputDecoration("Forgot Email Address"),
                    style: TextStyle(color: fieldTextColor, fontWeight: FontWeight.w400),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                  ),
                  const SizedBox(height: 100),
                  isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          style: getSubmitButtonStyle(),
                          onPressed: submit,
                          child: const Text("Send Reset Email"),
                        ),
                ],
              ),
            ),
          ),
        ));
  }
}
