import 'package:flutter/material.dart';

class MessengerW {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> messenger(
      BuildContext context, String text) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.grey[800],
        duration: const Duration(seconds: 2),
        content: Text(text),
      ),
    );
  }
}
