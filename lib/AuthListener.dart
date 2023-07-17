import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kafil/screens/LoginPage.dart';
import 'package:kafil/screens/homePage.dart';

class AuthListener extends StatefulWidget {
  const AuthListener({super.key});

  @override
  State<AuthListener> createState() => _AuthListenerState();
}

class _AuthListenerState extends State<AuthListener> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          print("i am waiting");
          // Show a loading indicator if the connection is still waiting
          return CircularProgressIndicator();
        } else if (snapshot.hasData) {
          // User is signed in, redirect to home page
          print("i am connecting");
          return MyHomePage();
        } else {
          // User is not signed in, redirect to signup page
          print("i am out");
          return LoginPage();
        }
      },
    );
  }
}
