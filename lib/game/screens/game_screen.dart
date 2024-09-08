import 'package:flutter/material.dart';
import 'package:survivegame/animations/button_pressed_animation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'dart:math';

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

  @override
  void initState() {
    super.initState();
    _initializeGrid();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(_controller!);
    // Initialize Google Mobile Ads
    MobileAds.instance.initialize();
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
      _showGameOverDialog();
    } else {
      _controller!.forward().then((_) => _controller!.reverse());
      _showPlusTwoAnimation(i, j);
      setState(() {
        score += 2;
        gridData[i][j] = -1; // Mark as clicked
      });
    }
  }

  void _showPlusTwoAnimation(int i, int j) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset position = box.localToGlobal(Offset.zero);

    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx + (j * (box.size.width / gridSize)),
        top: position.dy + (i * (box.size.height / gridSize)),
        child: const PlusTwoAnimation(),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(milliseconds: 800), () {
      overlayEntry.remove();
    });
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Game Over"),
          content: Text("Your score: $score"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  score = 0;
                  gameOver = false;
                  gridData.clear();
                  _initializeGrid();
                });
              },
              child: Text("Restart"),
            ),
          ],
        );
      },
    );
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
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        height: 50, // Typically the banner height
                        child: AdWidget(
                          ad: BannerAd(
                            size: AdSize.banner,
                            adUnitId:
                                'ca-app-pub-3940256099942544/9214589741', // Replace with real Ad Unit ID
                            listener: const BannerAdListener(),
                            request: const AdRequest(),
                          )..load(),
                        ),
                      ),
                    ),
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
