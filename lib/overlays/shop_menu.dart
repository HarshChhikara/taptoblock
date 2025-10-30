import 'package:flutter/material.dart';
import 'package:taptoblock/tap_to_block.dart';

class ShopMenu extends StatefulWidget {
  final TapToBlockGame game;
  const ShopMenu({super.key, required this.game});
  @override
  State<ShopMenu> createState() => _ShopMenuState();
}

class _ShopMenuState extends State<ShopMenu> {
  TapToBlockGame get game => widget.game;

  final List<Map<String, dynamic>> discColors = [
    {'color': const Color.fromARGB(255, 228, 132, 126), 'scoreNeeded': 50},
    {'color': const Color.fromARGB(255, 100, 198, 100), 'scoreNeeded': 100},
    {'color': const Color.fromARGB(255, 83, 83, 235), 'scoreNeeded': 150},
    {'color': const Color.fromARGB(255, 197, 30, 183), 'scoreNeeded': 200},
    {'color': const Color.fromARGB(255, 255, 215, 0), 'scoreNeeded': 250},
  ];

  final List<Map<String, dynamic>> discVariants = List.generate(
    5,
    (index) => {
      'variant': 'Variant ${index + 1}',
      'radius': 30 + (index * 5),
      'scoreNeeded': (index + 1) * 100,
    },
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 98, 28, 142),
            Color.fromARGB(255, 98, 28, 142),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Shop',
                  style: TextStyle(
                    color: Colors.yellowAccent,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 32),
                  onPressed: () {
                    game.overlays.remove('ShopOverlay');
                    game.overlays.add(TapToBlockGame.overlayStart);
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Disc Colors
            const Text(
              'Disc Colors',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: discColors.length,
                itemBuilder: (context, index) {
                  final item = discColors[index];
                  bool unlocked =
                      index == 0 || game.unlockedColors.contains(index);
                  bool selected = game.selectedColorIndex == index;
                  return GestureDetector(
                    onTap: unlocked
                        ? () {
                            setState(() {
                              game.selectedColorIndex = index;
                            });
                            game.setDiscColor(item['color']);
                            game.saveSelections();
                          }
                        : null,
                    child: Container(
                      width: 80,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: item['color'],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: selected
                              ? Colors.redAccent
                              : (unlocked ? Colors.yellowAccent : Colors.grey),
                          width: 3,
                        ),
                      ),
                      child: Center(
                        child: index == 0
                            ? const SizedBox.shrink()
                            : Text(
                                '${item['scoreNeeded']}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),

            // Disc Variants
            const Text(
              'Disc Variants',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: discVariants.length,
                itemBuilder: (context, index) {
                  final item = discVariants[index];
                  final isUnlocked =
                      index == 0 || game.unlockedVariants.contains(index);
                  final selected = game.selectedVariantIndex == index;
                  return GestureDetector(
                    onTap: isUnlocked
                        ? () {
                            setState(() {
                              game.selectedVariantIndex = index;
                            });
                            game.saveSelections();
                            game.setDiscVariant(item['variant']);
                          }
                        : null,
                    child: Container(
                      width: 120,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: isUnlocked
                            ? (selected
                                  ? Colors.redAccent.withValues(alpha: .6)
                                  : Colors.white24)
                            : Colors.grey.shade700,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: selected
                              ? Colors.redAccent
                              : (isUnlocked
                                    ? Colors.yellowAccent
                                    : Colors.grey),
                          width: 3,
                        ),
                      ),
                      child: Center(
                        child: index == 0
                            ? const SizedBox.shrink()
                            : Text(
                                '${item['variant']}\n(Radius = ${item['radius']})\n(${item['scoreNeeded']})',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
