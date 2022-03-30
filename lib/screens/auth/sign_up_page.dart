import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_storage/service/auth_service.dart';
import 'package:cloud_storage/widgets/buttons_widget.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({Key? key}) : super(key: key);

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Ro'yhatdan O'tish",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                labelText: "Telefon raqamingiz",
                hintText: "+998 XXX XX XX",
              ),
            ),
            TextFormField(
              controller: _passwordController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                labelText: "Parol",
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            ButtonsW.filledButton(
              context,
              "Ro'yhatdan O'tish",
              () {
                _firestore.collection("users").doc(_phoneController.text).set(
                  {
                    "phoneNumber": _phoneController.text,
                    "password": _passwordController.text,
                    "joinTime": FieldValue.serverTimestamp(),
                    "photo": "",
                    "gallery": [],
                  },
                ).then(
                  (value) => AuthService().signUpWithPhoneNumber(
                    context,
                    _phoneController.text,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
