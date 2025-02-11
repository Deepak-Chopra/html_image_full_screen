import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;
import 'package:flutter/widgets.dart';
import 'dart:ui' as ui;

import 'package:fluttertoast/fluttertoast.dart'; // For platform view registry

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  TextEditingController controller = TextEditingController();
  String imageUrl = "";

  void setImageDataToHTMLCode(String url) {
    if (kIsWeb) {
      final divElement = html.DivElement()
        ..style.display = 'flex'
        ..style.justifyContent = 'center'
        ..style.alignItems = 'center'
        ..style.height = '100vh'
        ..style.width = '100%';

      final imgElement = html.ImageElement()
        ..src = url
        ..style.width = '400px'
        ..style.height = '400px'
        ..style.cursor = 'pointer';
      imgElement.onDoubleClick.listen((event) {
        if (html.document.documentElement?.requestFullscreen != null) {
          if (html.document.fullscreenElement == null) {
            html.document.documentElement?.requestFullscreen();
          } else {
            html.document.exitFullscreen();
          }
        }
      });
      divElement.append(imgElement);

      // ignore: undefined_prefixed_name
      ui.platformViewRegistry.registerViewFactory(
        'html-img',
        (int viewId) => divElement, // Return the div as the view
      );

      setState(() {
        imageUrl = url;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("HTML Image View Example")),
      body: imageUrl.isNotEmpty
          ? HtmlElementView(
              viewType: 'html-img',
            )
          : Center(child: const Text("Enter an image URL and press send")),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: "Enter Image URL",
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                if (kIsWeb) {
                  if (controller.text.isNotEmpty) {
                    setImageDataToHTMLCode(controller.text);
                  }
                } else {
                  Fluttertoast.showToast(msg: "This Works only in web");
                }
              },
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
