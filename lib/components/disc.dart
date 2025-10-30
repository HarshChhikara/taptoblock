import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Disc extends CircleComponent {
  Vector2 velocity = Vector2(150, 120);
  bool justBounced = false;

  Color discColor;
  String currentVariant;

  Disc({
    required Vector2 position,
    this.discColor = Colors.white,
    this.currentVariant = 'Default',
  }) : super(
         position: position,
         radius: 15,
         anchor: Anchor.center,
         paint: Paint()
           ..shader = RadialGradient(
             colors: [discColor, discColor.withValues(alpha: .6)],
           ).createShader(Rect.fromCircle(center: Offset.zero, radius: 15)),
       );

  // Update the color of the disc
  void updateColor(Color color) {
    discColor = color;
    paint = Paint()
      ..shader = RadialGradient(
        colors: [discColor, discColor.withValues(alpha: .6)],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius));
  }

  // Update the variant of the disc
  void setVariant(String variant) {
    currentVariant = variant;

    switch (variant) {
      case 'Variant 1':
        radius = 25;
        break;
      case 'Variant 2':
        radius = 35;
        break;
      case 'Variant 3':
        radius = 45;
        break;
      case 'Variant 4':
        radius = 55;
        break;
      case 'Variant 5':
        radius = 65;
        break;
      default:
        radius = 15;
    }

    // Update the shader so color looks consistent with new radius
    paint.shader = RadialGradient(
      colors: [discColor, discColor.withValues(alpha: .6)],
    ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius));
  }
}
