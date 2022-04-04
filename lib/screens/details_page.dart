import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_storage/providers/details_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({Key? key, required this.data}) : super(key: key);
  final List data;

  @override
  Widget build(BuildContext context) {
    final Map _photo = data[0];
    final int _photoIndex = data[1];

    return ChangeNotifierProvider(
      create: (context) => DetailsProvider(),
      builder: (BuildContext context, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: const Icon(Icons.groups),
                onPressed: () =>
                    context.read<DetailsProvider>().controlSharePhotos(
                          context,
                          _photo["name"],
                          _photo["link"],
                          _photoIndex,
                        ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: CachedNetworkImage(imageUrl: _photo["link"]),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.06,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.red),
                        child: const Text(
                          "O'chirish",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () => context
                            .read<DetailsProvider>()
                            .deletePhoto(context, _photoIndex, _photo["name"]),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.06,
                      child: ElevatedButton(
                        child: const Text(
                          "Yuklab Olish",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () => context
                            .read<DetailsProvider>()
                            .downloadPhoto(
                                context, _photo["link"], _photo["name"]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
