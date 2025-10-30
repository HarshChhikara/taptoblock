import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:taptoblock/overlays/game_over_menu.dart';
import 'package:taptoblock/overlays/shop_menu.dart';
import 'package:taptoblock/overlays/start_menu.dart';
import 'package:taptoblock/tap_to_block.dart';

void main() {
  final game = TapToBlockGame();
  runApp(
    GameWidget(
      game: game,
      overlayBuilderMap: {
        TapToBlockGame.overlayStart:
            (BuildContext context, TapToBlockGame gameInstance) =>
                StartMenu(game),
        TapToBlockGame.overlayGameOver:
            (BuildContext context, TapToBlockGame gameInstance) =>
                GameOverMenu(game, game.score),
        'ShopOverlay': (context, game) =>
            ShopMenu(game: game as TapToBlockGame),
      },
    ),
  );
}
