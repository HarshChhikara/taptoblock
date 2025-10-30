import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ScoreText extends TextComponent {
  ScoreText({required Vector2 position})
    : super(
        text: 'Score: 0',
        position: position,
        anchor: Anchor.topCenter,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      );

  void updateScore(int score) {
    text = 'Score: $score';
  }
}
