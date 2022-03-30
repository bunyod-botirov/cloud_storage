import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_storage/providers/home_provider.dart';
import 'package:cloud_storage/service/auth_service.dart';
import 'package:cloud_storage/widgets/messenger_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final FirebaseAuth _authUser = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _firestore
          .collection("users")
          .doc(_authUser.currentUser!.phoneNumber!)
          .get(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return const Center(child: Text("Hatolik yuz berdi!"));
        } else {
          return ChangeNotifierProvider(
            create: (context) => HomeProvider(),
            builder: (BuildContext context, Widget? child) {
              return Scaffold(
                drawer: drawer(context, snapshot),
                appBar: AppBar(
                  title: const Text(
                    "Cloud Storage",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  bottom: TabBar(
                    controller: _tabController,
                    labelStyle: const TextStyle(
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.normal,
                    ),
                    tabs: const <Widget>[
                      Tab(text: "Yuklab olish"),
                      Tab(text: "Yuklash"),
                    ],
                    onTap: (int selectedPage) {
                      context.read<HomeProvider>().changePages(selectedPage);
                    },
                  ),
                ),
                body: context
                    .watch<HomeProvider>()
                    .pages[context.watch<HomeProvider>().currentPage],
              );
            },
          );
        }
      },
    );
  }

  Drawer drawer(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            currentAccountPictureSize: const Size.fromRadius(30),
            currentAccountPicture: InkWell(
              child: context.watch<HomeProvider>().accountPhoto.path.isEmpty
                  ? CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: CachedNetworkImageProvider(
                        snapshot.data["photo"].isEmpty
                            ? "https://eitrawmaterials.eu/wp-content/uploads/2016/09/person-icon.png"
                            : snapshot.data["photo"],
                      ),
                    )
                  : CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage:
                          FileImage(context.watch<HomeProvider>().accountPhoto),
                    ),
              onTap: () async {
                context
                    .read<HomeProvider>()
                    .changeAccountPhoto(context, snapshot);
              },
            ),
            accountName: const Text(
              "Sizning telefon raqamingiz:",
              style: TextStyle(fontSize: 18),
            ),
            accountEmail: Text(
              snapshot.data!["phoneNumber"],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            textColor: Colors.blue,
            iconColor: Colors.blue,
            style: ListTileStyle.list,
            leading: const Icon(Icons.question_answer),
            title: const Text(
              "Chat",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              MessengerW.showSnackBarAsBottomSheet(
                  context, "Bu funksiya hozirchalik ishlamaydi!");
            },
          ),
          ListTile(
            textColor: Colors.blue,
            iconColor: Colors.blue,
            style: ListTileStyle.list,
            leading: const Icon(Icons.info_outline),
            title: const Text(
              "Muhim",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                builder: (BuildContext context) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Text(
                                "Muhim:",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              InkWell(
                                child: const Icon(Icons.highlight_remove),
                                onTap: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Texnik sabablarga ko'ra sizning malumotlaringiz yoqolib qolishi mumkin.",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          const Text(
                            "Sizning malumotlaringiz uchun biz javobgar emasmiz!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          ListTile(
            textColor: Colors.blue,
            iconColor: Colors.blue,
            style: ListTileStyle.list,
            leading: const Icon(Icons.logout),
            title: const Text(
              "Chiqish",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () => AuthService().signOut(),
          ),
        ],
      ),
    );
  }
}
