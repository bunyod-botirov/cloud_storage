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

  Future controlSharePhotos(
    BuildContext context,
    String photoName,
    String photoURL,
    int photoIndex,
  ) async {
    bool ifContains = true;
    final DocumentSnapshot<Map> userData = await _firestore
        .collection("users")
        .doc(_authUser.currentUser!.phoneNumber)
        .get();

    List sharePhotos = await userData.data()!["sharePhotos"];

    for (var i = 0; i < sharePhotos.length; i++) {
      if (sharePhotos[i]["name"] == photoName) {
        await sharePhotos.removeAt(photoIndex);
        ifContains = false;
        break;
      }
    }

    if (ifContains) {
      sharePhotos.add({"name": photoName, "link": photoURL});
    }

    await _firestore
        .collection("users")
        .doc(_authUser.currentUser!.phoneNumber)
        .update({"sharePhotos": sharePhotos}).whenComplete(
      () {
        ifContains
            ? MessengerW.messenger(context, "Rasmingiz Share Docsga qo'shildi!")
            : MessengerW.messenger(
                context, "Rasmingiz Share Docsdan o'chirildi!");
      },
    );
  }

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
