import 'package:flutter/material.dart';
import 'package:taptoblock/tap_to_block.dart';

class StartMenu extends StatefulWidget {
  final TapToBlockGame game;
  const StartMenu(this.game, {super.key});

  @override
  State<StartMenu> createState() => _StartMenuState();
}

class _StartMenuState extends State<StartMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(
      begin: 1.0,
      end: 1.08,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade800, Colors.deepPurple.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _bounceAnimation,
                  builder: (context, child) => Transform.scale(
                    scale: _bounceAnimation.value,
                    child: child,
                  ),
                  child: Text(
                    'Tap To Block',
                    style: TextStyle(
                      color: Colors.yellowAccent,
                      fontSize: 52,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 10,
                          color: Colors.black54,
                          offset: Offset(4, 4),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                AnimatedBuilder(
                  animation: _bounceAnimation,
                  builder: (context, child) => Transform.scale(
                    scale: _bounceAnimation.value,
                    child: child,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellowAccent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 10,
                      shadowColor: Colors.black54,
                    ),
                    onPressed: () {
                      widget.game.overlays.remove(TapToBlockGame.overlayStart);
                      widget.game.startGame();
                    },
                    child: const Text(
                      'Tap To Play',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                AnimatedBuilder(
                  animation: _bounceAnimation,
                  builder: (context, child) => Transform.scale(
                    scale: _bounceAnimation.value,
                    child: child,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 10,
                      shadowColor: Colors.black54,
                    ),
                    onPressed: () {
                      widget.game.pauseEngine();
                      widget.game.overlays.remove(TapToBlockGame.overlayStart);
                      //widget.game.startShop();
                      widget.game.overlays.add('ShopOverlay');
                    },
                    child: const Text(
                      'Tap To Shop!',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                AnimatedBuilder(
                  animation: _bounceAnimation,
                  builder: (context, child) => Transform.scale(
                    scale: _bounceAnimation.value,
                    child: child,
                  ),
                  child: Text(
                    '${widget.game.highScore}',
                    style: TextStyle(
                      color: Colors.yellowAccent,
                      fontSize: 50,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Made by Harsh Chhikara',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
