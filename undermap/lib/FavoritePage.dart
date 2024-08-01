import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:undermap/SubwayService.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SubwayService>(
      builder: (context, subwayService, child) {
        return Scaffold(
            appBar: AppBar(
              title: Text("좋아요"),
              backgroundColor: Colors.amber,
            ),
            body: GridView.count(
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              padding: EdgeInsets.all(8),
              crossAxisCount: 2,
              children: List.generate(
                subwayService.favoriteSubways.length,
                    (index) {
                  String subwayImage = subwayService.favoriteSubways[index];
                  return GestureDetector(
                      onTap: () {
                        subwayService.toggleFavoriteImage(subwayImage);
                      },
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(
                                subwayImage,
                                fit:BoxFit.cover
                            ),
                          ),
                          Positioned(
                              right: 8,
                              bottom: 8,
                              child: Icon(
                                Icons.favorite,
                                color:subwayService.favoriteSubways.contains(subwayImage)
                                    ? Colors.amber
                                    : Colors.transparent,
                              )
                          )
                        ],
                      )

                  );
                },
              ),
            )
        );
      },
    );
  }
}