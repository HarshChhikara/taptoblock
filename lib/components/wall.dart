import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Wall extends RectangleComponent {
  Wall({
    required Vector2 position,
    required Vector2 size,
    required Anchor anchor,
    Color color = const Color.fromARGB(255, 218, 218, 218),
  }) : super(
         position: position,
         size: size,
         anchor: anchor,
         paint: Paint()..color = color,
       );
}
