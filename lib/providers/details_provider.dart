import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_storage/widgets/messenger_widget.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

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

  Future downloadPhoto(int photoIndex, String photoName) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    File downloadToFile = File('${appDocDir.path}/$photoName');

    await _storage
        .ref("${_authUser.currentUser!.phoneNumber}/$photoName")
        .writeToFile(downloadToFile);

    final response = await Dio().get(
        _storage
            .ref("${_authUser.currentUser!.phoneNumber}/$photoName")
            .toString(),
        options: Options(responseType: ResponseType.bytes));
    final raf = downloadToFile.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data);
    await raf.close();
    return null;
  }
}
