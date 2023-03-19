import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/auth/helper/user_helper.dart';
import 'package:flutter_firebase_auth/auth/state/user_controller.dart';
import 'package:flutter_firebase_auth/auth/ui/screens/auth_state_sync.dart';
import 'package:flutter_firebase_auth/auth/ui/screens/profile_screen.dart';
import 'package:flutter_firebase_auth/firebase_options.dart';

import 'package:flutter_firebase_auth/utils/functions.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences pref;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);

  Get.put(UserController());

  pref = await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(builder: (context) {
      return GetMaterialApp(
        title: 'Juzgo Stripe Pay',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            useMaterial3: true,
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black45,
              ),
            ),
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.amber,
              accentColor: Colors.amber,
              backgroundColor: Colors.white,
            )),
        home: const AuthStateStync(),
      );
    });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isReadyForPay = false;

  String? imageLink;

  double uploadProgress = 0.0;

  @override
  void initState() {
    loadUserData();
    super.initState();
  }

  Future<void> loadUserData() async {
    await UserHelper.loadUserData().then((userData) {
      UserController.setUserData(userData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await pref.clear();
                toast("Session Clear");
              },
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                final user = UserController.getUserData();
                print(">>> User Phone : ${user.phone}");
                print(">>> User Image : ${user.image} ");
                print(">>> User Email : ${user.email} ");
                print(">>> User Name : ${user.name} ");
              },
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Get.to(() => const ProfileScreen());
              },
            )
          ],
        ),
        body: const Center(
          child: Text(
            "HOME",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 50),
          ),
        ));
  }
}
