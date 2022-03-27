import 'package:cloud_storage/screens/sign_in_page.dart';
import 'package:cloud_storage/screens/splash_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route? onGenerateRoute(RouteSettings settings) {
    final Object? args = settings.arguments;
    switch (settings.name) {
      case "/splash":
        return MaterialPageRoute(builder: (context) => const SplashPage());
      case "/sign_in":
        return MaterialPageRoute(builder: (context) => const SignInPage());
    }

    return null;
  }
}
