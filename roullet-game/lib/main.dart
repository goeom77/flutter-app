import 'package:flutter/material.dart';
import 'roulette_game.dart';
import 'slot_machine_game.dart';

void main() {
  runApp(LuckyGameApp());
}

class LuckyGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '행운의 게임',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('행운의 게임')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RouletteGame()),
                );
              },
              child: Text('룰렛 게임', style: TextStyle(fontSize: 20)),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SlotMachineGame()),
                );
              },
              child: Text('슬롯머신 게임', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
