import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_storage/widgets/messenger_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class GetDocsProvider extends ChangeNotifier {
  final FirebaseAuth _authUser = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future getDocs(BuildContext context) async {
    try {
      final DocumentSnapshot<Map> anotherUserData =
          await _firestore.collection("users").doc(phoneController.text).get();

      if (anotherUserData.data()!["canShare"]) {
        if (anotherUserData.data()!["password"] == passwordController.text) {
          final DocumentSnapshot<Map> userData = await _firestore
              .collection("users")
              .doc(_authUser.currentUser!.phoneNumber)
              .get();
          List anotherUserCanSharePhotos =
              anotherUserData.data()!["sharePhotos"];
          List userCanSharePhotos = userData.data()!["sharePhotos"];
          userCanSharePhotos.addAll(anotherUserCanSharePhotos);
          _firestore
              .collection("users")
              .doc(_authUser.currentUser!.phoneNumber)
              .update({"sharePhotos": userCanSharePhotos});
        } else {
          MessengerW.messenger(
              context, "Foydalanuvchining parolini noto'g'ri kiritdingiz!");
        }
      } else {
        MessengerW.messenger(context,
            "Foydalanuvchi malumotlarini bo'lishish imkoniyatini o'chirib qoygan");
      }
    } catch (e) {
      MessengerW.messenger(context, "Hatolik yuz berdi!");
    }
  }
}
