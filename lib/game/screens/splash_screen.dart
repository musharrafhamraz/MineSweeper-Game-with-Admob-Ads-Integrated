import 'package:flutter/material.dart';
import 'package:survivegame/game/screens/game_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<Color?>? _colorAnimation;
  Animation<Color?>? _backgroundColorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: Colors.purple,
      end: Colors.orange,
    ).animate(_controller!);

    _backgroundColorAnimation = ColorTween(
      begin: Colors.blue,
      end: Colors.pink,
    ).animate(_controller!);

    _navigateToGameScreen();
  }

  void _navigateToGameScreen() async {
    await Future.delayed(Duration(seconds: 2));
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => GameScreen()));
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _backgroundColorAnimation!,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: _backgroundColorAnimation!.value,
          body: Center(
            child: AnimatedBuilder(
              animation: _colorAnimation!,
              builder: (context, child) {
                return Text(
                  'MineSweeper',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: _colorAnimation!.value,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.white,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
