import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_storage/widgets/messenger_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _authUser = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void signUpWithPhoneNumber(BuildContext context, String phoneNumber) {
    MessengerW.messenger(context, "Loading...");
    _authUser.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Android Only
        await _authUser.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == "network-request-failed") {
          MessengerW.messenger(
              context, "Ro'yhatdan o'tishingiz uchun internet kerak!");
        } else {
          MessengerW.messenger(context, e.message!);
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        await Navigator.pushNamed(
          context,
          "/verify_code",
          arguments: verificationId,
        );
      },
      timeout: const Duration(minutes: 2),
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future signInWithPhoneNumber(
      BuildContext context, String phoneNumber, String password) async {
    MessengerW.messenger(context, "Loading...");
    final DocumentSnapshot<Map<String, dynamic>> data =
        await _firestore.collection("users").doc(phoneNumber).get();

    if (data.data()!["password"] == password) {
      _authUser.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Android Only
          await _authUser.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          MessengerW.messenger(context, e.message!);
        },
        codeSent: (String verificationId, int? resendToken) async {
          await Navigator.pushNamed(
            context,
            "/verify_code",
            arguments: verificationId,
          );
        },
        timeout: const Duration(minutes: 2),
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } else {
      MessengerW.messenger(context, "Parol noto'g'ri!");
    }
  }

  void signOut(BuildContext context) {
    _authUser.signOut();
    Navigator.pushNamedAndRemoveUntil(
      context,
      "/splash",
      (route) => false,
    );
  }
}
