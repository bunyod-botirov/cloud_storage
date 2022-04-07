import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_storage/providers/share_provider.dart';
import 'package:cloud_storage/service/user_service.dart';
import 'package:cloud_storage/widgets/buttons_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SharePage extends StatelessWidget {
  const SharePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ServiceUser.getUser(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return const Center(child: Text("Hatolik yuz berdi!"));
        } else {
          return ChangeNotifierProvider(
            create: (context) => ShareProvider(),
            builder: (BuildContext context, Widget? child) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text(
                    "Share Docs",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  actions: [
                    const Icon(Icons.share),
                    Switch(
                      value: context.watch<ShareProvider>().switcher ??
                          snapshot.data["canShare"],
                      activeColor: Colors.white,
                      onChanged: (value) => context
                          .read<ShareProvider>()
                          .switcherController(value),
                    ),
                  ],
                ),
                body: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "Sizning parolingiz: ${snapshot.data["password"]}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.image_not_supported,
                          color: Colors.red,
                        ),
                        onPressed: () => context
                            .read<ShareProvider>()
                            .delCanSharePhotos(context),
                      ),
                    ),
                    Expanded(
                      child: snapshot.data["sharePhotos"].isEmpty
                          ? const Center(
                              child: Text(
                                "Iltimos Rasm Qo'shing!",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : GridView.builder(
                              itemCount: snapshot.data["sharePhotos"].length,
                              padding: const EdgeInsets.all(5),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 0.75,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                    child: Container(
                                      padding: const EdgeInsets.all(1.5),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black26, width: 1),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot.data["sharePhotos"]
                                            [index]["link"],
                                        fit: BoxFit.cover,
                                        placeholder: (BuildContext context,
                                            String fileName) {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        },
                                      ),
                                    ),
                                    onTap: () {});
                              },
                            ),
                    ),
                  ],
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                floatingActionButton: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ButtonsW.filledButton(
                    context,
                    "Foydalanuvchidan rasmlarni olish",
                    () => Navigator.pushNamed(context, "/get_docs"),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
