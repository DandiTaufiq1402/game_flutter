import 'dart:async'; // Imported for Timer
import 'dart:math';  // Imported for Random numbers
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fruit Catcher Game',
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // Game Variables
  int score = 0;
  bool isPlaying = false;
  
  // Positions (0.0 to 1.0 logic for screen alignment)
  double basketX = 0; 
  double fruitX = 0;
  double fruitY = -1; // Start above the screen

  // Timer for the game loop
  Timer? gameTimer;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    score = 0;
    fruitY = -1;
    fruitX = Random().nextDouble() * 2 - 1; // Random X between -1 and 1
    isPlaying = true;

    // Game Loop runs every 50 milliseconds
    gameTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (mounted) {
        setState(() {
          // Move fruit down
          fruitY += 0.02;

          // Check if fruit hit the bottom
          if (fruitY > 1) {
             // Check Collision with Basket (simple logic)
             if ((fruitX - basketX).abs() < 0.2) {
               // Caught!
               score++;
               resetFruit();
             } else {
               // Missed - Reset fruit but don't increase score
               // (Optional: You could subtract life here)
               resetFruit();
             }
          }
        });
      }
    });
  }

  void resetFruit() {
    fruitY = -1;
    fruitX = Random().nextDouble() * 2 - 1;
  }

  // Move basket with finger drag
  void moveBasket(DragUpdateDetails details) {
    setState(() {
      // Sensitivity factor implies how fast the basket moves
      basketX += details.delta.dx * 0.01; 
      // Clamp keeps the basket inside the screen (-1 to 1)
      if (basketX > 1) basketX = 1;
      if (basketX < -1) basketX = -1;
    });
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: GestureDetector(
        onPanUpdate: moveBasket, // Allows dragging the basket
        child: Stack(
          children: [
            // 1. The Score Board
            Positioned(
              top: 50,
              left: 20,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Score: $score', // Updated to use the variable
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // 2. The Falling Fruit
            AlignmentPositioned(
              alignment: Alignment(fruitX, fruitY),
              child: const Text(
                '🍎', 
                style: TextStyle(fontSize: 50),
              ),
            ),

            // 3. The Player's Basket
            AlignmentPositioned(
              alignment: Alignment(basketX, 0.9), // 0.9 is near bottom
              child: Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Colors.brown,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                    child: Text('🧺', style: TextStyle(fontSize: 40))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper widget to position elements using -1 to 1 coordinates easily
class AlignmentPositioned extends StatelessWidget {
  final Alignment alignment;
  final Widget child;

  const AlignmentPositioned({
    super.key,
    required this.alignment,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: child,
    );
  }
}