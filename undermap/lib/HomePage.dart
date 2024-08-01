import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'FavoritePage.dart';
import 'SubwayService.dart';

late SharedPreferences prefs;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SubwayService> (
      builder: (context, subwayService, child) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              // 좋아요 페이지로 이동
              IconButton(
                icon: Icon(Icons.favorite),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FavoritePage()),
                  );
                },
              )
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "어떤 동네, 어떤 역을",
                            style: TextStyle(fontSize: 24),
                        ),
                        Text(
                          "찾고 계신가요?",
                          style: TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Search',
                        hintText: 'Enter a location or station',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 150, // Adjust the height as needed
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(
                                catImage,
                                fit:BoxFit.cover
                            ),
                          ),
                          Positioned(
                              right: 8,
                              bottom: 8,
                              child: Icon(
                                Icons.favorite,
                                color:catService.favoriteImages.contains(catImage)
                                    ? Colors.amber
                                    : Colors.transparent,
                              )
                          )
                        ],
                      )
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
