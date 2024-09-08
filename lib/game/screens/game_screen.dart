import 'package:flutter/material.dart';
import 'package:survivegame/game/admob_ads/interstial_ad.dart';
import 'package:lottie/lottie.dart';
import 'package:survivegame/game/controllers/game_controllers.dart';
import 'dart:math';

import 'package:survivegame/game/widgets/ad_widget.dart';
import 'package:survivegame/game/widgets/dialog_show.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  final int gridSize = 10;
  final List<List<int>> gridData = [];
  int score = 0;
  bool gameOver = false;
  AnimationController? _controller;
  Animation<double>? _scaleAnimation;

  // Mobile Ads class members
  final fullAd = InterstialAd();
  final gameControllers = GameController(gridSize: 10);

  @override
  void initState() {
    super.initState();
    _initializeGrid();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(_controller!);

    // initializing the Admob Ads
    fullAd.loadInterstitialAd();
  }

  void _initializeGrid() {
    final random = Random();
    for (int i = 0; i < gridSize; i++) {
      List<int> row = [];
      for (int j = 0; j < gridSize; j++) {
        // 0 represents green, 1 represents red
        row.add(random.nextInt(5) == 0 ? 1 : 0);
      }
      gridData.add(row);
    }
  }

  void _handleTap(int i, int j) async {
    if (gameOver || gridData[i][j] == -1) return;

    if (gridData[i][j] == 1) {
      setState(() {
        gameOver = true;
      });
      GameOverDialog.showGameOverDialog(context, score, startAgain);
    } else {
      _controller!.forward().then((_) => _controller!.reverse());
      setState(() {
        score += 2;
        gridData[i][j] = -1; // Mark as clicked
      });
    }
  }

  void startAgain() {
    setState(() {
      score = 0;
      gameOver = false;
      gridData.clear();
      _initializeGrid();
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Score:  ${score.toString()}",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo[900],
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: Lottie.asset(
                'assets/animations/animation1.json',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: gridSize,
                          ),
                          itemCount: gridSize * gridSize,
                          itemBuilder: (context, index) {
                            int i = index ~/ gridSize;
                            int j = index % gridSize;
                            return ScaleTransition(
                              scale: _scaleAnimation!,
                              child: GestureDetector(
                                onTap: () => _handleTap(i, j),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  margin: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: gridData[i][j] == -1
                                        ? Colors.green
                                        : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: gridData[i][j] == -1
                                        ? [
                                            BoxShadow(
                                              color:
                                                  Colors.green.withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                            ),
                                          ]
                                        : [],
                                  ),
                                  child: Center(
                                    child: gridData[i][j] == -1
                                        ? const Icon(Icons.check,
                                            color: Colors.white)
                                        : null,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 150,
                      left: 100,
                      child: ElevatedButton(
                          onPressed: fullAd.showInterstitial,
                          child: const Text('show Interstitial')),
                    ),
                    WidgetAd(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
