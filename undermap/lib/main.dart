import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:undermap/SubwayService.dart';

import 'HomePage.dart';
import 'OnboardingPage.dart';
import 'UserService.dart';

late SharedPreferences prefs;

void main() async {
  // main() 함수에서 async를 쓰려면 필요
  WidgetsFlutterBinding.ensureInitialized();

  // shared_preferences 인스턴스 생성
  prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserService()),
        ChangeNotifierProvider(create: (context) => SubwayService(prefs)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isOnboarded = prefs.getBool("isOnboarded") ?? false;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.getTextTheme('Lato'),
      ),
      home: isOnboarded ? HomePage() : OnboardingPage(),
    );
  }
}
