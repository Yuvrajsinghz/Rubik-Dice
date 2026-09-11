import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const RubikDiceApp());
}

class RubikDiceApp extends StatelessWidget {
  const RubikDiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rubik Dice',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const DiceScreen(),
    );
  }
}

class DiceScreen extends StatefulWidget {
  const DiceScreen({super.key});

  @override
  State<DiceScreen> createState() => _DiceScreenState();
}

class _DiceScreenState extends State<DiceScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  final Random _random = Random();

  int _result = 1;
  int _rollCount = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );
  }

  void _rollDice() {
    if (_controller.isAnimating) return;

    setState(() {
      _result = _random.nextInt(6) + 1;
      _rollCount++;
    });

    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF08090D),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final shortestSide =
                min(constraints.maxWidth, constraints.maxHeight);

            final diceSize = (shortestSide * 0.52).clamp(170.0, 230.0);

            return Column(
              children: [
                // ----------------------------------------------------------
                // TOP BAR
                // ----------------------------------------------------------
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 18, 22, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'RUBIK',
                            style: TextStyle(
                              fontSize: 13,
                              letterSpacing: 5,
                              fontWeight: FontWeight.w500,
                              color: Colors.white54,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'DICE',
                            style: TextStyle(
                              fontSize: 26,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      // Roll counter
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.08),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.casino_outlined,
                              size: 16,
                              color: Colors.white54,
                            ),
                            const SizedBox(width: 7),
                            Text(
                              '$_rollCount',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ----------------------------------------------------------
                // MAIN AREA
                // ----------------------------------------------------------
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Dice
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: _rollDice,
                          child: AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) {
                              final value = Curves.easeInOutCubic.transform(
                                _controller.value,
                              );

                              final rotationX = value * pi * 4;
                              final rotationY = value * pi * 4;

                              final scale =
                                  1.0 + sin(value * pi) * 0.06;

                              return Transform.scale(
                                scale: scale,
                                child: Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.identity()
                                    ..setEntry(3, 2, 0.0014)
                                    ..rotateX(rotationX)
                                    ..rotateY(rotationY),
                                  child: child,
                                ),
                              );
                            },
                            child: DiceFace(
                              number: _result,
                              size: diceSize,
                            ),
                          ),
                        ),

                        SizedBox(height: shortestSide * 0.10),

                        // Result label
                        const Text(
                          'RESULT',
                          style: TextStyle(
                            fontSize: 11,
                            letterSpacing: 4,
                            fontWeight: FontWeight.w600,
                            color: Colors.white38,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Result number
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          transitionBuilder: (child, animation) {
                            return ScaleTransition(
                              scale: animation,
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                          child: Text(
                            '$_result',
                            key: ValueKey(_result),
                            style: const TextStyle(
                              fontSize: 42,
                              height: 1,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ----------------------------------------------------------
                // BOTTOM INSTRUCTION
                // ----------------------------------------------------------
                Padding(
                  padding: const EdgeInsets.only(bottom: 28),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.055),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.08),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.touch_app_rounded,
                              size: 18,
                              color: Colors.white60,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'TAP THE DICE TO ROLL',
                              style: TextStyle(
                                fontSize: 10,
                                letterSpacing: 1.8,
                                fontWeight: FontWeight.w700,
                                color: Colors.white60,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ============================================================================
// DICE WIDGET
// ============================================================================

class DiceFace extends StatelessWidget {
  final int number;
  final double size;

  const DiceFace({
    super.key,
    required this.number,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.145),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.19),

        // Premium white/silver dice
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFFFFF),
            Color(0xFFEDEDED),
            Color(0xFFD0D0D0),
          ],
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.65),
            blurRadius: 35,
            spreadRadius: 2,
            offset: const Offset(0, 24),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.12),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: DiceDots(
        number: number,
        dotSize: size * 0.115,
      ),
    );
  }
}

// ============================================================================
// DICE DOTS
// ============================================================================

class DiceDots extends StatelessWidget {
  final int number;
  final double dotSize;

  const DiceDots({
    super.key,
    required this.number,
    required this.dotSize,
  });

  List<int> _positions(int number) {
    switch (number) {
      case 1:
        return [4];

      case 2:
        return [0, 8];

      case 3:
        return [0, 4, 8];

      case 4:
        return [0, 2, 6, 8];

      case 5:
        return [0, 2, 4, 6, 8];

      case 6:
        return [0, 2, 3, 5, 6, 8];

      default:
        return [4];
    }
  }

  @override
  Widget build(BuildContext context) {
    final positions = _positions(number);

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: 9,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemBuilder: (context, index) {
        final visible = positions.contains(index);

        return Center(
          child: AnimatedScale(
            scale: visible ? 1.0 : 0.7,
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutBack,
            child: AnimatedOpacity(
              opacity: visible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 150),
              child: Container(
                width: dotSize,
                height: dotSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF14161C),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.35),
                      blurRadius: 5,
                      offset: const Offset(2, 3),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}