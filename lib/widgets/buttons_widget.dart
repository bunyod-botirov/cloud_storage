import 'package:flutter/material.dart';

class ButtonsW {
  static SizedBox filledButton(
    BuildContext context,
    String child,
    Function onPressed,
  ) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 1,
      height: MediaQuery.of(context).size.height * 0.06,
      child: ElevatedButton(
        child: Text(
          child,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          onPressed();
        },
      ),
    );
  }

  static SizedBox textButton(
    BuildContext context,
    String child,
    Function onPressed,
  ) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 1,
      height: MediaQuery.of(context).size.height * 0.06,
      child: TextButton(
        child: Text(
          child,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          onPressed();
        },
      ),
    );
  }
}
