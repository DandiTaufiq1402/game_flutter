import 'dart:math';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'components/basket.dart';
import 'components/fruit.dart';
import '../managers/audio_manager.dart'; // Path diperbaiki dengan ../

class FruitCatcherGame extends FlameGame with PanDetector, HasCollisionDetection {
  late Basket basket;
  late TextComponent scoreText;
  
  final Random random = Random();
  double fruitSpawnTimer = 0;
  final double fruitSpawnInterval = 1.5;
  
  final ValueNotifier<int> scoreNotifier = ValueNotifier<int>(0);
  int _score = 0;
  
  int get score => _score;
  set score(int value) {
    _score = value;
    scoreNotifier.value = value;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Set background color
    camera.viewport = FixedResolutionViewport(resolution: Vector2(400, 800));
    
    // Add basket
    basket = Basket();
    await add(basket);
    
    // Play background music
    AudioManager().playBackgroundMusic();
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Spawn fruits
    fruitSpawnTimer += dt;
    if (fruitSpawnTimer >= fruitSpawnInterval) {
      spawnFruit();
      fruitSpawnTimer = 0;
    }
  }

  void spawnFruit() {
    final x = random.nextDouble() * size.x;
    final fruit = Fruit(position: Vector2(x, -50));
    add(fruit);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    basket.position.x += info.delta.global.x;
    basket.position.x = basket.position.x.clamp(basket.size.x / 2, size.x - basket.size.x / 2);
  }

  void incrementScore() {
    score++;
    AudioManager().playSfx('collect.mp3');
  }

  void gameOver() {
    AudioManager().playSfx('explosion.mp3');
    pauseEngine();
    // Show game over dialog
  }

  @override
  void onRemove() {
    AudioManager().stopBackgroundMusic();
    super.onRemove();
  }

  @override
  Color backgroundColor() => const Color(0xFF87CEEB); // Sky blue
}