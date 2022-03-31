import 'package:cloud_storage/service/auth_service.dart';
import 'package:cloud_storage/widgets/buttons_widget.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  SignInPage({Key? key}) : super(key: key);

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Kirish",
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
                labelText: "Parolingiz",
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            ButtonsW.filledButton(
              context,
              "Kirish",
              () {
                AuthService().signInWithPhoneNumber(
                  context,
                  _phoneController.text,
                  _passwordController.text,
                );
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.015),
            ButtonsW.textButton(
              context,
              "Ro'yhatdan O'tish",
              () => Navigator.pushNamed(context, "/sign_up"),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.06,
              child: TextButton(
                child: const Text(
                  "Parolingizni unutdingizmi?",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, "/reset_password"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// Cloud Storage