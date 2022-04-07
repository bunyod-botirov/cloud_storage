import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_storage/widgets/messenger_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class GetDocsProvider extends ChangeNotifier {
  final FirebaseAuth _authUser = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future getDocs(BuildContext context) async {
    try {
      final DocumentSnapshot<Map> anotherUserData =
          await _firestore.collection("users").doc(phoneController.text).get();

      if (anotherUserData.data()!["canShare"]) {
        if (anotherUserData.data()!["password"] == passwordController.text) {
          MessengerW.messenger(context, "Iltimos Kuting. Yuklab olinmoqda...");
          final DocumentSnapshot<Map> userData = await _firestore
              .collection("users")
              .doc(_authUser.currentUser!.phoneNumber)
              .get();

          List anotherUserCanSharePhotos =
              anotherUserData.data()!["sharePhotos"];

          List userCanSharePhotos = await userData.data()!["gallery"];

          for (var i = 0; i < anotherUserCanSharePhotos.length; i++) {
            Directory tempDir = await getTemporaryDirectory();
            String tempPath = tempDir.path;
            File file =
                File(tempPath + "/" + anotherUserCanSharePhotos[i]["name"]);

            Uri url = Uri.parse(anotherUserCanSharePhotos[i]["link"]);
            http.Response response = await http.get(url);
            await file.writeAsBytes(response.bodyBytes);

            final Reference ref = _storage.ref(
                "${_authUser.currentUser!.phoneNumber}/${anotherUserCanSharePhotos[i]["name"]}");

            await ref.putFile(file).then((p0) async {
              String photoURL = await p0.ref.getDownloadURL();
              userCanSharePhotos.add({
                "name": anotherUserCanSharePhotos[i]["name"],
                "link": photoURL,
              });
              await _firestore
                  .collection("users")
                  .doc(_authUser.currentUser!.phoneNumber)
                  .update({"gallery": userCanSharePhotos}).whenComplete(
                () {
                  file = File("");
                  MessengerW.messenger(
                      context, "${i + 1}ta Rasm Muvafaqiyatli Qo'shildi!");
                },
              );
            });
          }
          MessengerW.messenger(
              context, "Barcha Rasmlar Muvafaqiyatli Qo'shib olindi!");
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
    notifyListeners();
  }
}
