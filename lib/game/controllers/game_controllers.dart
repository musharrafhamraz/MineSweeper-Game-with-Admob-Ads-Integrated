import 'dart:math';

class GameController {
  final int gridSize;
  late List<List<int>> gridData;
  int score = 0;
  bool gameOver = false;

  GameController({required this.gridSize}) {
    _initializeGrid();
  }

  // Initialize the grid with random values (0: green, 1: red)
  void _initializeGrid() {
    final random = Random();
    gridData = List.generate(gridSize, (i) {
      return List.generate(gridSize, (j) {
        return random.nextInt(5) == 0 ? 1 : 0; // 0: green, 1: red
      });
    });
  }

  // Handle tap on grid cell
  bool handleTap(int i, int j) {
    if (gameOver || gridData[i][j] == -1) return false;

    if (gridData[i][j] == 1) {
      gameOver = true;
      return false; // Game over condition
    } else {
      score += 2;
      gridData[i][j] = -1; // Mark cell as clicked
      return true; // Successfully clicked a green cell
    }
  }

  // Reset the game by re-initializing the grid and resetting the score
  void restartGame() {
    score = 0;
    gameOver = false;
    _initializeGrid();
  }
}
