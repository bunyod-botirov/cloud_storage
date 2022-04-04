import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ShareProvider extends ChangeNotifier {
  final FirebaseAuth _authUser = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool? switcher;

  void switcherController(bool value) async {
    switcher = value;
    await _firestore
        .collection("users")
        .doc(_authUser.currentUser!.phoneNumber)
        .update({"canShare": value});
    notifyListeners();
  }
}
