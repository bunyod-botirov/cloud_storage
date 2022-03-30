import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  SplashPage({Key? key}) : super(key: key);

  final FirebaseAuth _authUser = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 3),
      () => Navigator.pushNamedAndRemoveUntil(
        context,
        _authUser.currentUser == null ? "/sign_in" : "/home_page",
        (route) => false,
      ),
    );
    return const Scaffold(
      body: Center(
        child: Text(
          "Cloud Storage",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
