import 'dart:io';
import 'package:cloud_storage/screens/download_page.dart';
import 'package:cloud_storage/screens/upload_page.dart';
import 'package:cloud_storage/service/user_service.dart';
import 'package:cloud_storage/widgets/messenger_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class HomeProvider extends ChangeNotifier {
  final List pages = [const DownloadPage(), const UploadPage()];
  int currentPage = 0;

  final FirebaseAuth _authUser = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  File accountPhoto = File("");

  void changePages(int selectedPage) {
    currentPage = selectedPage;
    notifyListeners();
  }

  Future changeAccountPhoto(
      BuildContext context, AsyncSnapshot snapshot) async {
    Reference userStorage =
        _storage.ref("${_authUser.currentUser!.phoneNumber}");

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    accountPhoto = File(image!.path);

    MessengerW.showSnackBarAsBottomSheet(context, "Yuklanmoqda...");

    await userStorage.child("accountPhoto").putFile(accountPhoto);

    String photoURL = await userStorage.child("accountPhoto").getDownloadURL();

    await ServiceUser.getUserDoc().update({"photo": photoURL});

    notifyListeners();
  }
}
