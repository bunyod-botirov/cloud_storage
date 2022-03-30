import 'package:flutter/material.dart';

class MessengerW {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> messenger(
      BuildContext context, String text) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.grey[800],
        duration: const Duration(seconds: 2),
        content: Text(
          text,
          style: const TextStyle(
            fontFamily: "Nunito",
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  static void showSnackBarAsBottomSheet(BuildContext context, String message) {
    showModalBottomSheet<void>(
      context: context,
      barrierColor: const Color.fromRGBO(0, 0, 0, 0),
      backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
        });
        return Container(
          padding: const EdgeInsets.all(14),
          margin: const EdgeInsets.fromLTRB(15, 0, 15, 10),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(
                offset: Offset(0, 4),
                blurRadius: 6,
                color: Colors.black38,
              )
            ],
          ),
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}
