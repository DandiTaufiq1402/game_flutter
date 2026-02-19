import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../managers/audio_manager.dart';

class FruitCatcherGame extends FlameGame {
  @override
  Color backgroundColor() => const Color(0xFF87CEEB); // sky blue
  
  final ValueNotifier<int> scoreNotifier = ValueNotifier<int>(0);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Play background music
    AudioManager().playBackgroundMusic(); 
  }
}