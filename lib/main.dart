import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sally Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const BucketBallGame(title: 'Sally game'),
    );
  }
}

class Ball {
  double x;
  double y;
  double speed;
  double rotation;
  double rotationSpeed;
  bool isSpiky;
  Color color;

  Ball({
    required this.x,
    required this.y,
    required this.speed,
    required this.color,
    this.rotation = 0.0,
    this.rotationSpeed = 0.0,
    this.isSpiky = false,
  });
}

class BucketBallGame extends StatefulWidget {
  const BucketBallGame({super.key, required this.title});

  final String title;

  @override
  State<BucketBallGame> createState() => _BucketBallGameState();
}

class _BucketBallGameState extends State<BucketBallGame> {
  int _score = 0;
  int _lives = 5;
  bool _gameOver = false;
  double _bucketPosition = 0.5;
  final List<Ball> _balls = [];
  final Random _random = Random();
  late double _screenWidth;
  late double _screenHeight;

  // Game constants
  static const double bucketWidth = 100.0;
  static const double bucketHeight = 80.0;
  static const double ballSize = 40.0;
  static const int ballSpawnRate = 45;
  int _frameCount = 0;

  // Image paths
  final String backgroundImage = 'assets/images/background.png';
  final String bucketImage = 'assets/images/bucket.png';
  final String ballImage = 'assets/images/ball.png';
  final String spikyBallImage = 'assets/images/spiky_ball.png';

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    _score = 0;
    _lives = 5;
    _gameOver = false;
    _balls.clear();
    _frameCount = 0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _gameLoop();
      }
    });
  }

  void _gameLoop() {
    if (_gameOver) return;

    setState(() {
      _frameCount++;
      if (_frameCount % ballSpawnRate == 0) {
        _balls.add(Ball(
          x: _random.nextDouble(),
          y: 0,
          speed: 1.5 + _random.nextDouble(),
          color: Colors.primaries[_random.nextInt(Colors.primaries.length)],
          rotationSpeed: _random.nextDouble() * 0.1 - 0.05,
          isSpiky: _random.nextDouble() < 0.3, // 30% chance of being spiky
        ));
      }

      for (var ball in _balls) {
        ball.y += ball.speed / 100;
        ball.rotation += ball.rotationSpeed;
      }

      _balls.removeWhere((ball) {
        if (ball.y > 1.0) return true;

        if (ball.y > 0.85 &&
            ball.x > _bucketPosition - 0.1 &&
            ball.x < _bucketPosition + 0.1) {
          if (ball.isSpiky) {
            _lives--;
          } else {
            _score += 10;
          }
          if (_lives <= 0) _gameOver = true;
          return true;
        }
        return false;
      });
    });

    Future.delayed(const Duration(milliseconds: 16), _gameLoop);
  }

  void _moveBucket(Offset localPosition) {
    setState(() {
      _bucketPosition = localPosition.dx / _screenWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: GestureDetector(
        onPanUpdate: (details) => _moveBucket(details.localPosition),
        child: Stack(
          children: [
            // Background
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(backgroundImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Balls
            for (var ball in _balls)
              Positioned(
                left: ball.x * _screenWidth - ballSize / 2,
                top: ball.y * _screenHeight - ballSize / 2,
                child: Transform.rotate(
                  angle: ball.rotation,
                  child: Image.asset(
                    ball.isSpiky ? spikyBallImage : ballImage,
                    width: ballSize,
                    height: ballSize,
                  ),
                ),
              ),

            // Bucket
            Positioned(
              left: _bucketPosition * _screenWidth - bucketWidth / 2,
              bottom: 20,
              child: Image.asset(
                bucketImage,
                width: bucketWidth,
                height: bucketHeight,
              ),
            ),

            // Score display
            Positioned(
              top: 20,
              left: 20,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Score: $_score',
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Lives: $_lives',
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Game over overlay
            if (_gameOver)
              Container(
                color: Colors.black.withOpacity(0.7),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Game Over!',
                        style: TextStyle(
                          fontSize: 48,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Final Score: $_score',
                        style: const TextStyle(
                          fontSize: 36,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _startGame,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 20),
                          backgroundColor: Colors.orange,
                        ),
                        child: const Text(
                          'Play Again',
                          style: TextStyle(fontSize: 24, color: Colors.white),
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