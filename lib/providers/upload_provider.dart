import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_storage/widgets/messenger_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class UploadProvider extends ChangeNotifier {
  final FirebaseAuth _authUser = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  late String _photoName;
  File photo = File("");
  List photos = [];

  Future choosePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    _photoName = image!.name.split("/").last;
    photo = File(image.path);

    notifyListeners();
  }

  Future uploadPhoto(BuildContext context) async {
    MessengerW.showSnackBarAsBottomSheet(context, "Yuklanmoqda...");

    final Reference ref =
        _storage.ref("${_authUser.currentUser!.phoneNumber}/$_photoName");

    final DocumentSnapshot<Map<String, dynamic>> userData = await _firestore
        .collection("users")
        .doc(_authUser.currentUser!.phoneNumber)
        .get();

    photos = await userData.data()!["gallery"];

    await ref.putFile(photo).then(
      (p0) async {
        String photoURL = await p0.ref.getDownloadURL();
        photos.add(photoURL);
        await _firestore
            .collection("users")
            .doc(_authUser.currentUser!.phoneNumber)
            .update({"gallery": photos}).whenComplete(
          () {
            photo = File("");
            MessengerW.showSnackBarAsBottomSheet(
                context, "Muvafaqiyatli Yuklandi");
          },
        );
      },
    );

    notifyListeners();
  }
}
