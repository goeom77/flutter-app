import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
late SharedPreferences prefs;

class SubwayService extends ChangeNotifier {
  List<String> subways = [];
  List<String> favoriteSubways = [];
  SubwayService(prefs) {
    getRandomSubwayImages();

    favoriteSubways = prefs.getStringList("favorites") ?? [];
  }

  void getRandomSubwayImages() async {
    Response result = await Dio().get("https://api.thecatapi.com/v1/images/search?limit=10&mime_types=jpg");
    for (var i = 0; i < result.data.length; i++) {
      var map = result.data[i];
      subways.add(map["url"]);
    }
    notifyListeners();
  }

  void toggleFavoriteImage(String catImage) {
    if (favoriteSubways.contains(catImage)) {
      favoriteSubways.remove(catImage); // 이미 좋아요 한 경우
    } else {
      favoriteSubways.add(catImage);
    }

    prefs.setStringList("favorites", favoriteSubways);

    notifyListeners(); // 새로 고침
  }
}