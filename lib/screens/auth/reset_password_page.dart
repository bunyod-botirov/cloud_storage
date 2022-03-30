import 'package:cloud_storage/widgets/buttons_widget.dart';
import 'package:cloud_storage/widgets/messenger_widget.dart';
import 'package:flutter/material.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Parolni Tiklash",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.phone,
              style: const TextStyle(fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                labelText: "Telefon raqamingiz",
                hintText: "+998 XXX XX XX",
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            ButtonsW.filledButton(
              context,
              "Parolni Tiklash",
              () {
                MessengerW.messenger(
                    context, "Bu funksiya hozirchalik ishlamaydi!");
              },
            ),
          ],
        ),
      ),
    );
  }
}
