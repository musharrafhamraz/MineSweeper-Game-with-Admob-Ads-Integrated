import 'package:flutter/material.dart';

class GameOverDialog {
  static void showGameOverDialog(BuildContext context, int score,
      VoidCallback onNewGame, VoidCallback onWatchAd) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromRGBO(65, 75, 182, 1),
          title: const Text(
            "Game Over",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Your score: $score",
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onNewGame();
              },
              child: const Text(
                "New Game",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                // Logic to show rewarded ad to continue playing.
                Navigator.of(context).pop();
                onWatchAd(); // Call to undo the move after ad is watched
              },
              child: const Text(
                "Don't Loose Score",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
