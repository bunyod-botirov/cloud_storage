import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ServiceUser {
  static Future<DocumentSnapshot<Map>> getUser() {
    final FirebaseAuth _authUser = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return _firestore
        .collection("users")
        .doc(_authUser.currentUser!.phoneNumber!)
        .get();
  }

  static DocumentReference<Map> getUserDoc() {
    final FirebaseAuth _authUser = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return _firestore
        .collection("users")
        .doc(_authUser.currentUser!.phoneNumber!);
  }
}
