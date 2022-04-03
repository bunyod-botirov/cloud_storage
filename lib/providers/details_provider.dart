import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_storage/widgets/messenger_widget.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

class DetailsProvider extends ChangeNotifier {
  final FirebaseAuth _authUser = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future deletePhoto(
      BuildContext context, int photoIndex, String photoName) async {
    final DocumentSnapshot<Map<String, dynamic>> userData = await _firestore
        .collection("users")
        .doc(_authUser.currentUser!.phoneNumber)
        .get();

    List photos = await userData.data()!["gallery"];

    photos.removeAt(photoIndex);

    await _firestore
        .collection("users")
        .doc(_authUser.currentUser!.phoneNumber)
        .update({"gallery": photos}).whenComplete(() {
      _storage.ref("${_authUser.currentUser!.phoneNumber}/$photoName").delete();
      Navigator.pop(context);
      MessengerW.messenger(context, "Rasmingiz tez orada o'chirib tashlanadi!");
    });
  }

  Future downloadPhoto(
      BuildContext context, String photoLink, String photoName) async {
    MessengerW.messenger(context, "Iltimos Kuting, Yuklab Olinmoqda...");

    String url = photoLink;

    final tempDir = await getTemporaryDirectory();
    final path = "${tempDir.path}/$photoName";

    await Dio().download(url, path);

    await GallerySaver.saveImage(path, albumName: "Cloud Storage");
    MessengerW.messenger(context, "Muvafaqiyatli Yuklab Olindi");
  }
}
