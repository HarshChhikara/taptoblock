import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taptoblock/components/disc.dart';
import 'package:taptoblock/components/score_text.dart';
import 'package:taptoblock/components/wall.dart';

class TapToBlockGame extends FlameGame with TapCallbacks {
  late Disc disc;
  Vector2 velocity = Vector2(150, 120);
  bool justBounced = false;

  static const String overlayStart = 'StartMenu';
  static const String overlayGameOver = 'GameOverMenu';

  // box properties
  final double wallThickness = 30.0;
  final Vector2 boxSize = Vector2(300, 400);
  late Vector2 boxTopLeft;
  late Vector2 boxBottomRight;
  final List<RectangleComponent> walls = [];

  int selectedColorIndex = 0;
  int selectedVariantIndex = 0;

  // open/close logic
  int openWallIndex = 2;
  bool isClosed = false;

  // scoring
  int score = 0;
  int highScore = 0;
  late ScoreText scoreText;

  Color discColor = const Color.fromARGB(255, 228, 132, 126);
  String discVariant = 'Variant 1';
  List<int> unlockedColors = [];
  List<int> unlockedVariants = [];

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.purple.shade800, Colors.deepPurple.shade400],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect);
    canvas.drawRect(rect, paint);

    super.render(canvas);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    await _loadHighScore();
    await _loadPlayerData();
    _checkUnlocks();
    await _savePlayerData();

    // Compute centered box coordinates
    final center = size / 2;
    boxTopLeft = center - (boxSize / 2);
    boxBottomRight = center + (boxSize / 2);

    _createWalls();
    _createDisc();
    _createScoreText();
    pauseEngine();
    overlays.add(overlayStart);
  }

  void _createWalls() {
    final w = wallThickness;

    walls.addAll([
      Wall(
        position: Vector2(boxTopLeft.x + boxSize.x / 2, boxTopLeft.y),
        size: Vector2(boxSize.x, w),
        anchor: Anchor.topCenter,
      ),
      Wall(
        position: Vector2(boxBottomRight.x, boxTopLeft.y + boxSize.y / 2),
        size: Vector2(w, boxSize.y),
        anchor: Anchor.centerRight,
      ),
      Wall(
        position: Vector2(boxTopLeft.x + boxSize.x / 2, boxBottomRight.y),
        size: Vector2(boxSize.x, w),
        anchor: Anchor.bottomCenter,
        color: Colors.transparent,
      ),
      Wall(
        position: Vector2(boxTopLeft.x, boxTopLeft.y + boxSize.y / 2),
        size: Vector2(w, boxSize.y),
        anchor: Anchor.centerLeft,
      ),
    ]);

    for (final wall in walls) {
      add(wall);
    }
  }

  void _createDisc() {
    disc = Disc(position: size / 2);
    disc.updateColor(discColor);
    disc.setVariant(discVariant);
    add(disc);
  }

  void _createScoreText() {
    scoreText = ScoreText(position: Vector2(size.x / 2, 40));
    add(scoreText);
  }

  @override
  void update(double dt) {
    super.update(dt);
    disc.position += velocity * dt;

    final left = boxTopLeft.x + wallThickness;
    final right = boxBottomRight.x - wallThickness;
    final top = boxTopLeft.y + wallThickness;
    final bottom = boxBottomRight.y - wallThickness;

    // Bounce inside left/right/top
    if (disc.x - disc.radius <= left) {
      velocity.x = velocity.x.abs();
      justBounced = false;
    }
    if (disc.x + disc.radius >= right) {
      velocity.x = -velocity.x.abs();
      justBounced = false;
    }
    if (disc.y - disc.radius <= top) {
      velocity.y = velocity.y.abs();
      justBounced = false;
    }

    // bottom wall behavior
    if (isClosed) {
      if (disc.y + disc.radius >= bottom) {
        if (!justBounced) {
          disc.y = bottom - disc.radius;
          velocity.y = -velocity.y.abs();
          _increaseScore();
          justBounced = true;
        }
      } else {
        justBounced = false;
      }
    } else {
      if (disc.y - disc.radius > boxBottomRight.y) {
        gameOver();
      }
    }
  }

  void _increaseScore() {
    score += 1;
    scoreText.updateScore(score);

    if (score > highScore) {
      highScore = score;
      _saveHighScore();
    }

    _checkUnlocks();
    _savePlayerData();

    final maxSpeed = 600.0;
    final newVelocity = velocity * 1.05;
    if (newVelocity.length < maxSpeed) {
      velocity = newVelocity;
    }
  }

  Future<void> _savePlayerData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('score', score);
    await prefs.setInt('discColor', discColor.value);
    await prefs.setString('discVariant', discVariant);
    await prefs.setStringList(
      'unlockedColors',
      unlockedColors.map((e) => e.toString()).toList(),
    );
    await prefs.setStringList(
      'unlockedVariants',
      unlockedVariants.map((e) => e.toString()).toList(),
    );
  }

  Future<void> _loadPlayerData() async {
    final prefs = await SharedPreferences.getInstance();
    score = prefs.getInt('score') ?? 0;
    discColor = Color(
      prefs.getInt('discColor') ??
          const Color.fromARGB(255, 228, 132, 126).value,
    );
    discVariant = prefs.getString('discVariant') ?? 'Variant 1';
    unlockedColors =
        prefs
            .getStringList('unlockedColors')
            ?.map((e) => int.parse(e))
            .toList() ??
        [];
    unlockedVariants =
        prefs
            .getStringList('unlockedVariants')
            ?.map((e) => int.parse(e))
            .toList() ??
        [];
    _checkUnlocks();
  }

  void _checkUnlocks() {
    final progressScore = (score > highScore) ? score : highScore;
    for (int i = 0; i < 5; i++) {
      int colorScoreNeeded = (i + 1) * 50;
      int variantScoreNeeded = (i + 1) * 100;

      if (progressScore >= colorScoreNeeded && !unlockedColors.contains(i)) {
        unlockedColors.add(i);
      }
      if (progressScore >= variantScoreNeeded &&
          !unlockedVariants.contains(i)) {
        unlockedVariants.add(i);
      }
    }
  }

  Future<void> _saveHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('highScore', highScore);
  }

  Future<void> _loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    highScore = prefs.getInt('highScore') ?? 0;

    unlockedColors =
        prefs.getStringList('unlockedColors')?.map(int.parse).toList() ?? [];
    unlockedVariants =
        prefs.getStringList('unlockedVariants')?.map(int.parse).toList() ?? [];

    if (!unlockedColors.contains(0)) unlockedColors.add(0);
    if (!unlockedVariants.contains(0)) unlockedVariants.add(0);

    selectedColorIndex = prefs.getInt('selectedColorIndex') ?? 0;
    selectedVariantIndex = prefs.getInt('selectedVariantIndex') ?? 0;
  }

  Future<void> saveSelections() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedColorIndex', selectedColorIndex);
    await prefs.setInt('selectedVariantIndex', selectedVariantIndex);
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (isClosed) return;

    // close bottom wall
    isClosed = true;
    walls[openWallIndex].paint.color = const Color.fromARGB(255, 218, 218, 218);

    add(
      TimerComponent(
        period: 0.4,
        onTick: () {
          walls[openWallIndex].paint.color = Colors.transparent;
          isClosed = false;
        },
      ),
    );
  }

  void startGame() {
    score = 0;
    scoreText.text = 'Score: 0';
    disc.position = size / 2;
    velocity = Vector2(200, -200);
    isClosed = false;
    for (final wall in walls) {
      wall.removeFromParent();
    }
    walls.clear();
    _createWalls();

    final colorList = [
      const Color.fromARGB(255, 228, 132, 126),
      const Color.fromARGB(255, 100, 198, 100),
      const Color.fromARGB(255, 83, 83, 235),
      const Color.fromARGB(255, 197, 30, 183),
      const Color.fromARGB(255, 255, 215, 0),
    ];

    disc.updateColor(colorList[selectedColorIndex]);
    disc.setVariant('Variant ${selectedVariantIndex + 1}');

    overlays.remove(overlayGameOver);
    resumeEngine();
  }

  void gameOver() {
    pauseEngine();
    overlays.add(overlayGameOver);
  }

  void setDiscColor(Color color) {
    discColor = color;
    disc.updateColor(color);
    _savePlayerData();
  }

  void setDiscVariant(String variant) {
    discVariant = variant;
    disc.setVariant(variant);
    _savePlayerData();
  }

  void startShop() {
    pauseEngine();
    overlays.add('ShopOverlay');
  }

  void updateScore(int value) {
    score += value;
    _checkUnlocks();
    _savePlayerData();
  }
}
