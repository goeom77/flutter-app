import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/feed.dart';

@override
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> images = [
      "https://cdn2.thecatapi.com/images/b1.jpg",
      "https://cdn2.thecatapi.com/images/63g.jpg",
      "https://cdn2.thecatapi.com/images/a3h.jpg",
      "https://cdn2.thecatapi.com/images/a9m.jpg",
      "https://cdn2.thecatapi.com/images/aph.jpg",
    ];
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(CupertinoIcons.camera, color: Colors.black),
            onPressed: () {},
          ),
          actions: [
            IconButton(
              icon: Icon(CupertinoIcons.paperplane, color: Colors.black),
              onPressed: () {},
            )
          ],
          title: Image.asset(
            'assets/logo.png',
            height: 32,
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: ListView.builder(
          itemCount: images.length,
          itemBuilder: (context,index) {
            final image = images[index];
            return Feed(imageUrl: image);
          }
        ));
  }
}
