import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_firebase_auth/auth/helper/profile_upload_helper.dart';
import 'package:flutter_firebase_auth/auth/provider/email_provider.dart';
import 'package:flutter_firebase_auth/auth/service/user_service.dart';
import 'package:flutter_firebase_auth/auth/state/user_controller.dart';
import 'package:flutter_firebase_auth/auth/ui/screens/change_password_screen.dart';
import 'package:flutter_firebase_auth/auth/ui/screens/forgot_password.dart';
import 'package:flutter_firebase_auth/auth/ui/screens/log_in_screen.dart';
import 'package:flutter_firebase_auth/auth/ui/screens/verify_email_screen.dart';
import 'package:flutter_firebase_auth/utils/functions.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool numberEdit = false;
  bool nameEdit = false;
  bool phoneEdit = false;
  final numberController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    syncWithServer();
  }

  Future<void> syncWithServer() async {
    await UserServices.getUserData(UserController.getUserID).then((value) async {
      if (value != null) {
        await UserController.setUserData(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(builder: (userState) {
      return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  try {
                    await EmailProvider.logOut();
                    await UserController.clearSession();
                  } catch (e) {
                    toast(e.toString());
                    return;
                  }

                  Get.offAll(() => const LogInScreen());
                },
              )
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  userState.image == null ? const SizedBox() : ProfileUploader.getProfilePicture(context, userState.image!, radius: 80),
                  TextButton(
                      onPressed: () async {
                        final url = await ProfileUploader.upload(filename: "user_${userState.userID}");
                        if (url != null) {
                          await UserController.updateUserData(updateImage: url);
                          toast("Done Upload");
                        }
                      },
                      child: const Text("Upload Photo")),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      nameEdit
                          ? SizedBox(
                              width: 200,
                              child: TextFormField(
                    style: const TextStyle(fontWeight: FontWeight.w400),

                                controller: nameController,
                              ),
                            )
                          : Text(
                              userState.name ?? "No User Name",
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                      const SizedBox(width: 10),
                      GestureDetector(
                          onTap: () async {
                            setState(() {
                              nameEdit = !nameEdit;
                            });

                            if (!nameEdit) {
                              if (nameController.text == userState.name) {
                                return;
                              }
                              await UserController.updateUserData(updateName: nameController.text);
                              toast("Updated Name");
                            } else {
                              nameController.text = userState.name ?? "";
                            }
                          },
                          child: nameEdit
                              ? const Icon(Icons.check, size: 25, color: Colors.green)
                              : const Icon(Icons.edit, size: 20, color: Colors.grey))
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    userState.email ?? "No User Email",
                    style: const TextStyle(fontSize: 17),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      phoneEdit
                          ? SizedBox(
                              width: 200,
                              child: TextFormField(
                    style: const TextStyle(fontWeight: FontWeight.w400),

                                controller: phoneController,
                              ),
                            )
                          : Text(
                              userState.phone ?? "No Phone Number",
                              // style: const TextStyle(),
                            ),
                      const SizedBox(width: 10),
                      GestureDetector(
                          onTap: () async {
                            setState(() {
                              phoneEdit = !phoneEdit;
                            });

                            if (!phoneEdit) {
                              if (phoneController.text == userState.phone) {
                                return;
                              }
                              await UserController.updateUserData(updatePhone: phoneController.text);
                              toast("Updated Phone");
                            } else {
                              phoneController.text = userState.phone ?? "";
                            }
                          },
                          child: phoneEdit
                              ? const Icon(Icons.check, size: 25, color: Colors.green)
                              : const Icon(Icons.edit, size: 20, color: Colors.grey))
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: () {
                        Get.to(() => const ChangePasswordScreen());
                      },
                      child: const Text("Change Password")),
                  ElevatedButton(
                      onPressed: () {
                        Get.to(() => const ForgotPasswordScreen());
                      },
                      child: const Text("Forgot Password")),
                  ElevatedButton(
                      onPressed: () {
                        final currentUser = FirebaseAuth.instance.currentUser!;
                        Get.to(() => VerifyEmailScreen(
                            authorizedUser: currentUser,
                            onVerified: () {
                              toast("Finally Verified");
                            }));
                      },
                      child: const Text("Verify Email")),
                ],
              ),
            ),
          ));
    });
  }
}
