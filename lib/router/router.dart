import 'package:cloud_storage/screens/auth/reset_password_page.dart';
import 'package:cloud_storage/screens/auth/sign_in_page.dart';
import 'package:cloud_storage/screens/auth/sign_up_page.dart';
import 'package:cloud_storage/screens/auth/splash_page.dart';
import 'package:cloud_storage/screens/auth/verify_code_page.dart';
import 'package:cloud_storage/screens/details_page.dart';
import 'package:cloud_storage/screens/home_page.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route? onGenerateRoute(RouteSettings settings) {
    final Object? args = settings.arguments;
    switch (settings.name) {
      case "/splash":
        return MaterialPageRoute(
          builder: (context) => SplashPage(),
        );
      case "/sign_in":
        return MaterialPageRoute(
          builder: (context) => SignInPage(),
        );
      case "/sign_up":
        return MaterialPageRoute(
          builder: (context) => SignUpPage(),
        );
      case "/reset_password":
        return MaterialPageRoute(
          builder: (context) => const ResetPasswordPage(),
        );
      case "/verify_code":
        return MaterialPageRoute(
          builder: (context) => VerifyCodePage(
            verificationId: args.toString(),
          ),
        );
      case "/home_page":
        return MaterialPageRoute(
          builder: (context) => const HomePage(),
        );
      case "/details":
        return MaterialPageRoute(
          builder: (context) => DetailsPage(data: args as List),
        );
    }

    return null;
  }
}
