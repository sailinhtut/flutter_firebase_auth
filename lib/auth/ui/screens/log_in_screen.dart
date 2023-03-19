import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/auth/provider/email_provider.dart';
import 'package:flutter_firebase_auth/auth/service/user_service.dart';
import 'package:flutter_firebase_auth/auth/state/user_controller.dart';
import 'package:flutter_firebase_auth/auth/ui/screens/forgot_password.dart';
import 'package:flutter_firebase_auth/auth/ui/screens/sign_up_screen.dart';
import 'package:flutter_firebase_auth/main.dart';
import 'package:flutter_firebase_auth/utils/functions.dart';
import 'package:get/get.dart';


class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  bool isLoading = false;
  bool invisiblePassword = true;

  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> submit() async {
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      // action
      final credential = await EmailProvider.logIn(emailController.text, passwordController.text);
      final userData = credential == null ? null : await UserServices.getUserData(credential.user!.uid);
      if (userData != null) {
        await UserController.setUserData(userData);
        Get.offAll(() => const MyHomePage());
        toast("Logged In");
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
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      child: const Text(
                        "Forgot Password ?",
                        style: TextStyle(color: Colors.blue, fontSize: 12),
                      ),
                      onTap: () {
                        Get.to(() => const ForgotPasswordScreen());
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          style: getSubmitButtonStyle(),
                          onPressed: submit,
                          child: const Text("Log In"),
                        ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Do not have account ?"),
                      const SizedBox(width: 5),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SignUpScreen()));
                          },
                          child: const Text("Sign Up"))
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
