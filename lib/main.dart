import 'dart:math';
import 'package:flutter/material.dart';

import 'Direction.dart';
import 'Tile.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '2048 Flutter',
      home: Game(),
    );
  }
}

class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  static const int size = 4;
  List<List<int>> board = List.generate(size, (_) => List.filled(size, 0));
  int score = 0;
  Random rnd = Random();

  bool get isGameOver => !canMove();

  @override
  void initState() {
    super.initState();
    initGame();
  }

  void initGame() {
    board = List.generate(size, (_) => List.filled(size, 0));
    score = 0;
    addRandomTile(true);
    addRandomTile(true);
  }

  void addRandomTile(bool init) {
    List<Point<int>> empties = [];
    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size; c++) {
        if (board[r][c] == 0) empties.add(Point(r, c));
      }
    }
    if (empties.isEmpty) return;
    final pos = empties[rnd.nextInt(empties.length)];
    int r = init ? 50 : rnd.nextInt(100);
    if (r < 10) { // 10%
      board[pos.x][pos.y] = 4;
    } else if ( r < 12) { // 2%
      board[pos.x][pos.y] = 1;
    } else if ( r < 14) {// 2%
      board[pos.x][pos.y] = 3;
    } else {
      board[pos.x][pos.y] = 2;
    }
  }

  bool canMove() {
    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size; c++) {
        if (board[r][c] == 0) return true;
        if (c + 1 < size && board[r][c] == board[r][c + 1]) return true;
        if (r + 1 < size && board[r][c] == board[r + 1][c]) return true;
      }
    }
    return false;
  }

  List<int> _compress(List<int> row) {
    List<int> newRow = row.where((v) => v != 0).toList();
    while (newRow.length < size) newRow.add(0);
    return newRow;
  }

  List<int> _merge(List<int> row) {
    for (int i = 0; i < size - 1; i++) {
      bool canmerge = false;
      if (row[i] != 0 && row[i + 1] != 0) {
        if ((row[i] == 3) ^ (row[i + 1] == 3)) {
          row[i] = 0;
          canmerge = true;
        } else if ((row[i] == 1) ^ (row[i + 1] == 1)) {
          row[i] = max(row[i], row[i + 1]) * 2;
          canmerge = true;
        } else if (row[i] == row[i + 1] && (row[i] != 3) && (row[i] != 1)) {
          row[i] = row[i] * 2;
          canmerge = true;
        }
        if (canmerge) {
          score += row[i];
          row[i + 1] = 0;
          if (row[i] > 2048) {
            row[i] = 0;
          }
        }
      }
    }

    return row;
  }

  bool moveLeft() {
    bool moved = false;
    for (int r = 0; r < size; r++) {
      List<int> original = List.from(board[r]);
      List<int> row = _compress(board[r]);
      row = _merge(row);
      row = _compress(row);
      board[r] = row;
      if (!moved && !_listEquals(original, board[r])) moved = true;
    }
    return moved;
  }

  bool moveRight() {
    _reverseRows();
    bool moved = moveLeft();
    _reverseRows();
    return moved;
  }

  bool moveUp() {
    _transpose();
    bool moved = moveLeft();
    _transpose();
    return moved;
  }

  bool moveDown() {
    _transpose();
    bool moved = moveRight();
    _transpose();
    return moved;
  }

  void _transpose() {
    List<List<int>> b = List.generate(size, (_) => List.filled(size, 0));
    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size; c++) {
        b[r][c] = board[c][r];
      }
    }
    board = b;
  }

  void _reverseRows() {
    for (int r = 0; r < size; r++) {
      board[r] = board[r].reversed.toList();
    }
  }

  bool _listEquals(List<int> a, List<int> b) {
    if (a.length != b.length) {
      return false;
    }
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  void handleMove(Direction dir) {
    bool moved = false;
    setState(() {
      switch (dir) {
        case Direction.left:
          moved = moveLeft();
          break;
        case Direction.right:
          moved = moveRight();
          break;
        case Direction.up:
          moved = moveUp();
          break;
        case Direction.down:
          moved = moveDown();
          break;
      }
      if (moved) {
        addRandomTile(false);
      }
    });
  }

  void onMove(DragEndDetails details) {
    final v = details.velocity.pixelsPerSecond;
    final dx = v.dx.abs();
    final dy = v.dy.abs();
    if (dx < 100 && dy < 100) return;
    if (dx > dy) {
      if (v.dx > 0) {
        handleMove(Direction.right);
      } else {
        handleMove(Direction.left);
      }
    } else {
      if (v.dy > 0) {
        handleMove(Direction.down);
      } else {
        handleMove(Direction.up);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('2048 - Simpson'),
        actions: [IconButton(icon: Icon(Icons.refresh), onPressed: initGame)],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('media/fond.jpg', fit: BoxFit.fill),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Score', style: TextStyle(fontSize: 18)),
                      Text(
                        '$score',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onPanEnd: onMove,
                    child: Container(
                      padding: EdgeInsets.all(12),
                      color: Colors.transparent,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: size * size,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: size,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                          itemBuilder: (context, index) {
                            int r = index ~/ size;
                            int c = index % size;
                            int val = board[r][c];
                            return Tile(value: val);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                if (isGameOver)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8,
                    ),
                    child: ElevatedButton(
                      onPressed: initGame,
                      child: Text('Game Over — Recommencer'),
                    ),
                  ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
