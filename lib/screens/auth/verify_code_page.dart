import 'package:cloud_storage/widgets/buttons_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyCodePage extends StatelessWidget {
  VerifyCodePage({Key? key, required this.verificationId}) : super(key: key);

  final String verificationId;
  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Kodni Tasdiqlash",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Telefon raqamingizga SMS tarzda kelgan kodni kiriting:",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            TextFormField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                labelText: "Kod",
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            ButtonsW.filledButton(
              context,
              "Kodni Tasqidlash",
              () async {
                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                  verificationId: verificationId,
                  smsCode: _codeController.text,
                );

                await FirebaseAuth.instance.signInWithCredential(credential);

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  "/home_page",
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
