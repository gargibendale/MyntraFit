// ignore_for_file: unused_import

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myntra/communitychat.dart';
import 'package:myntra/firebase_options.dart';
import 'package:myntra/helper/helper_function.dart';
import 'package:myntra/login.dart';
import 'splash.dart';
import 'welcome.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBsrWbFzblzwPxbzh-zR8bxuQ8VmC9dX7w",
            appId: "1:850554461811:web:3728e7a7b4ffd9783c9406",
            messagingSenderId: "850554461811",
            projectId: "chatapp-b10cb"));
  } else {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;
  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await HelperFunction.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'MyntraFit',
        debugShowCheckedModeBanner: false, // Remove debug banner
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: _isSignedIn ? SplashScreen() : LoginPage(),
        routes: {
          '/welcome': (context) => WelcomePage(),
          '/chat': (context) => ChatPage()
        });
  }
}
