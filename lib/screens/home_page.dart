import 'package:cloud_storage/service/auth_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        leading: IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            AuthService().signOut();
          },
        ),
      ),
    );
  }
}
