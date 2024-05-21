import "package:firebase_auth/firebase_auth.dart";
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:friends_1/page/firstPage.dart';
import 'package:friends_1/page/home.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // User is logged in
          if (snapshot.hasData) {
            return const FirstPage();
          }
          // User is NOT logged in
          else {
            return const HomePage();
          }
        },
      ),
    );
  }
}