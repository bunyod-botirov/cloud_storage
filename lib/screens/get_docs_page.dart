import 'package:cloud_storage/providers/get_docs_provider.dart';
import 'package:cloud_storage/widgets/buttons_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GetDocsPage extends StatelessWidget {
  const GetDocsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Rasmlarni olish",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ChangeNotifierProvider(
          create: (context) => GetDocsProvider(),
          builder: (BuildContext context, Widget? child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: context.watch<GetDocsProvider>().phoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    labelText: "Telefon raqam",
                    hintText: "+998 XXX XX XX",
                  ),
                ),
                TextFormField(
                  controller:
                      context.watch<GetDocsProvider>().passwordController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    labelText: "Parol",
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                ButtonsW.filledButton(
                  context,
                  "Rasmlarni olish",
                  () => context.read<GetDocsProvider>().getDocs(context),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
