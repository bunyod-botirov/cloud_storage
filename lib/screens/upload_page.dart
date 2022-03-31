import 'package:cloud_storage/providers/upload_provider.dart';
import 'package:cloud_storage/widgets/buttons_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UploadPage extends StatelessWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ChangeNotifierProvider(
          create: (context) => UploadProvider(),
          builder: (BuildContext context, Widget? child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                context.watch<UploadProvider>().photo.path.isNotEmpty
                    ? Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.4,
                        padding: const EdgeInsets.all(1),
                        margin: const EdgeInsets.only(bottom: 20),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Image.file(
                          context.watch<UploadProvider>().photo,
                        ),
                      )
                    : const Text(""),
                ButtonsW.filledButton(
                  context,
                  "Rasm tanlash",
                  () => context.read<UploadProvider>().choosePhoto(),
                ),
                const SizedBox(height: 20),
                ButtonsW.filledButton(
                  context,
                  "Rasmni yuklash",
                  () => context.read<UploadProvider>().uploadPhoto(context),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
