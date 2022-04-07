import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_storage/service/user_service.dart';
import 'package:cloud_storage/widgets/messenger_widget.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

class DetailsProvider extends ChangeNotifier {
  final FirebaseAuth _authUser = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future controlSharePhotos(BuildContext context, Map photo) async {
    bool ifContains = true;
    final DocumentSnapshot<Map> userData = await ServiceUser.getUser();

    List sharePhotos = await userData.data()!["sharePhotos"];

    for (var i = 0; i < sharePhotos.length; i++) {
      if (sharePhotos[i]["name"] == photo["name"]) {
        await sharePhotos.removeAt(i);
        ifContains = false;
        break;
      }
    }

    if (ifContains) {
      sharePhotos.add({"name": photo["name"], "link": photo["link"]});
    }

    await ServiceUser.getUserDoc()
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
    final DocumentSnapshot<Map> userData = await ServiceUser.getUser();

    List photos = await userData.data()!["gallery"];

    await photos.removeAt(photoIndex);

    await ServiceUser.getUserDoc()
        .update({"gallery": photos}).whenComplete(() async {
      await _storage
          .ref("${_authUser.currentUser!.phoneNumber}/$photoName")
          .delete();
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
