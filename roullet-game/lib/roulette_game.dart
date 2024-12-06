import 'dart:math';
import 'package:flutter/material.dart';

class RouletteGame extends StatefulWidget {
  @override
  _RouletteGameState createState() => _RouletteGameState();
}

class _RouletteGameState extends State<RouletteGame> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final List<String> options = ['1등', '2등', '3등', '꽝', '보너스'];
  double _currentAngle = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 2 * pi * 5)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.addListener(() {
      setState(() {
        _currentAngle = _animation.value;
      });
    });
  }

  void _spinRoulette() {
    _controller.reset();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('룰렛 게임')),
      body: Center(
        child: GestureDetector(
          onTap: _spinRoulette,
          child: CustomPaint(
            painter: RoulettePainter(options, _currentAngle),
            size: Size(300, 300),
          ),
        ),
      ),
    );
  }
}

class RoulettePainter extends CustomPainter {
  final List<String> options;
  final double angle;

  RoulettePainter(this.options, this.angle);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()..style = PaintingStyle.fill;

    final sweepAngle = 2 * pi / options.length;
    for (int i = 0; i < options.length; i++) {
      paint.color = Colors.primaries[i % Colors.primaries.length];
      canvas.drawArc(rect, angle + (i * sweepAngle), sweepAngle, true, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
