import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 3),
      () => Navigator.pushNamedAndRemoveUntil(
        context,
        "/sign_in",
        (route) => false,
      ),
    );
    return Scaffold(
      body: Center(
        child: Text(
          "Cloud Storage",
        ),
      ),
    );
  }
}
