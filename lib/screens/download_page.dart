import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DownloadPage extends StatelessWidget {
  DownloadPage({Key? key}) : super(key: key);

  final FirebaseAuth _authUser = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _firestore
            .collection("users")
            .doc(_authUser.currentUser!.phoneNumber!)
            .get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Hatolik yuz berdi!"));
          } else {
            return GridView.builder(
              itemCount: snapshot.data["gallery"].length,
              padding: const EdgeInsets.all(5),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                      border: Border.all(color: Colors.black26, width: 1),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: snapshot.data["gallery"][index]["link"],
                      fit: BoxFit.cover,
                      placeholder: (BuildContext context, String fileName) {
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                  onTap: () => Navigator.pushNamed(
                    context,
                    "/details",
                    arguments: [snapshot.data["gallery"][index], index],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
