import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class SlotMachineGame extends StatefulWidget {
  @override
  _SlotMachineGameState createState() => _SlotMachineGameState();
}

class _SlotMachineGameState extends State<SlotMachineGame> {
  final List<IconData> icons = [Icons.star, Icons.favorite, Icons.cake, Icons.flash_on, Icons.pets];
  final Random random = Random();
  List<int> currentIcons = [0, 0, 0];
  List<ScrollController> controllers = List.generate(3, (_) => ScrollController());
  bool isSpinning = false;
  final double itemHeight = 100;

  final double jackpotProbability = 0.1; // 당첨 확률 (예: 10%)

  void spin() async {
    if (isSpinning) return;
    setState(() {
      isSpinning = true;
    });

    // 당첨 여부 결정
    bool isJackpot = random.nextDouble() < jackpotProbability;
    int jackpotIconIndex = random.nextInt(icons.length); // 당첨 아이콘 선택

    for (int i = 0; i < 3; i++) {
      if (isJackpot) {
        // 모든 슬롯에 동일한 아이콘 설정
        await _spinSingleSlot(i, fixedIndex: jackpotIconIndex);
      } else {
        // 개별 랜덤 아이콘 설정
        await _spinSingleSlot(i);
      }
    }

    checkResult();
    setState(() {
      isSpinning = false;
    });
  }

  Future<void> _spinSingleSlot(int index, {int? fixedIndex}) async {
    int spins = 30 + random.nextInt(10);
    int finalIndex = fixedIndex ?? random.nextInt(icons.length); // 당첨 또는 랜덤 아이콘

    double targetOffset = (controllers[index].offset + (spins * itemHeight)) + (finalIndex * itemHeight);
    targetOffset = (targetOffset ~/ itemHeight) * itemHeight;

    await controllers[index].animateTo(
      targetOffset,
      duration: Duration(milliseconds: 2000),
      curve: Curves.easeOut,
    );

    setState(() {
      currentIcons[index] = finalIndex;
    });
  }

  void checkResult() {
    if (currentIcons.every((icon) => icon == currentIcons[0])) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('🎉 당첨! 축하합니다! 🎉')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('당첨 확률 조정 슬롯머신')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Container(
                  width: 80,
                  height: itemHeight,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(blurRadius: 5, color: Colors.grey)],
                  ),
                  child: ListView.builder(
                    controller: controllers[index],
                    itemCount: icons.length * 100,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i) {
                      int iconIndex = i % icons.length;
                      return Container(
                        height: itemHeight,
                        child: Center(
                          child: Icon(
                            icons[iconIndex],
                            size: 60,
                            color: Colors.orangeAccent,
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: spin,
              child: Text(
                isSpinning ? '스핀 중...' : '스핀!',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
