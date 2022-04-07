import 'package:cloud_storage/service/user_service.dart';
import 'package:cloud_storage/widgets/messenger_widget.dart';
import 'package:flutter/cupertino.dart';

class ShareProvider extends ChangeNotifier {
  bool? switcher;

  void switcherController(bool value) async {
    switcher = value;
    await ServiceUser.getUserDoc().update({"canShare": value});
    notifyListeners();
  }

  Future delCanSharePhotos(BuildContext context) async {
    await ServiceUser.getUserDoc().update({"sharePhotos": []});
    MessengerW.messenger(
        context, "Rasmlaringiz tez orada o'chirib tashlanadi!");
    notifyListeners();
  }
}
