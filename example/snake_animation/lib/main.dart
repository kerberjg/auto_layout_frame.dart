import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:auto_layout_frame/auto_layout_frame.dart';

final double kChildSize = 48;
final double kPadding = 12;

void main() {
  runApp(const SnakeAnimationApp());
}

class SnakeAnimationApp extends StatelessWidget {
  const SnakeAnimationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Snake Animation',
      home: SnakeAnimationPage(),
    );
  }
}

class SnakeAnimationPage extends StatefulWidget {
  const SnakeAnimationPage({super.key});

  @override
  State<SnakeAnimationPage> createState() => _SnakeAnimationPageState();
}

class _SnakeAnimationPageState extends State<SnakeAnimationPage>
    with TickerProviderStateMixin {
  // Animation controller
  late AnimationController _controller;
  late Animation<double> _animation;

  // Number of children (colored squares) - constant throughout animation
  static const int _childCount = 11;

  // Pre-created children - never rebuilt
  final List<Container> _children = [];

  // Animation duration
  static const Duration _duration = Duration(milliseconds: 6000);

  @override
  void initState() {
    super.initState();

    // Initialize children once - never rebuild
    for (int i = 0; i < _childCount; i++) {
      _children.add(
        Container(
          width: kChildSize,
          height: kChildSize,
          decoration: BoxDecoration(
            color: _getColor(i),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(child: Text("$i")),
        ),
      );
    }

    // Setup animation
    _controller = AnimationController(duration: _duration, vsync: this);

    // Animation goes from 0 to 4 (representing 4 corners with interpolation)
    _animation = Tween<double>(begin: 0, end: 4).animate(
      CurvedAnimation(
        parent: _controller, //
        curve: Curves.linear, //
      ),
    );

    // Start the animation
    _controller.repeat();
  }

  Color _getColor(int index) {
    final hue = (index / _childCount).toDouble();
    // Use HSL color with fixed saturation and lightness
    final color = Color.fromARGB(
      255,
      (255 * hue).toInt(),
      (255 * (1 - hue)).toInt(),
      (128 + 127 * (1 - hue)).toInt(),
    );
    return color;
  }

  // Get alignment based on current corner
  Alignment _getAlignment(int corner) {
    switch (corner) {
      case 0:
        return Alignment.topLeft;
      case 1:
        return Alignment.topRight;
      case 2:
        return Alignment.bottomRight;
      case 3:
        return Alignment.bottomLeft;
      default:
        return Alignment.topLeft;
    }
  }

  // Get direction based on current corner for layout
  AutoLayoutDirection _getDirection(int corner) {
    switch (corner) {
      case 0:
      case 2:
        return AutoLayoutDirection.horizontal;
      case 1:
      case 3:
        return AutoLayoutDirection.vertical;
      default:
        return AutoLayoutDirection.horizontal;
    }
  }

  // Calculate snake size based on animation value
  // Value goes from 0 to 4, where each integer is a corner
  // Sequence per corner: extend (25%) -> switch align (25%) -> shrink (25%) -> switch align (25%)
  double _getSnakeSize(double value, double maxSize, double minSize) {
    // Get the fractional part within the current corner's phase
    final cornerProgress = value - value.floor();

    double size;

    // First 25%: extend from 1 to max
    if (cornerProgress <= 0.25) {
      size = cornerProgress / 0.25;
    }
    // Next 25%: stay at max (align switch happens here)
    else if (cornerProgress <= 0.50) {
      size = 1;
    }
    // Next 25%: shrink from max to 1
    else if (cornerProgress <= 0.75) {
      size = 1 - ((cornerProgress - 0.50) / 0.25);
    }
    // Last 25%: stay at 1 (align switch happens here before next corner)
    else {
      size = 0;
    }

    return lerpDouble(minSize, maxSize, size)!;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final value = _animation.value;

          // Get current corner and interpolation
          final int currentCorner = value.floor();

          final Alignment currentAlignment = _getAlignment(currentCorner);
          final Alignment nextAlignment = _getAlignment(
            (currentCorner + 1) % 4,
          );

          final Alignment alignment = value % 1 < 0.5
              ? currentAlignment
              : nextAlignment; // Switch alignment at halfway point of corner phase

          // Get screen size
          final Size screenSize = MediaQuery.of(context).size;
          // Get snake size
          final double snakeSize = _getSnakeSize(
            value,
            // max size: width/height of screen (depends on direction) minus padding
            (currentCorner % 2 == 0 ? screenSize.width : screenSize.height),
            // min size: just the child size (when fully shrunk)
            kChildSize + kPadding * 2, // child size + padding
          );

          return Align(
            alignment: alignment,
            child: AutoLayoutFrame(
              direction: _getDirection(currentCorner),
              gap: 8,
              width: currentCorner % 2 == 0
                  ? snakeSize
                  : kChildSize + kPadding * 2, // child size + padding
              height: currentCorner % 2 == 1
                  ? snakeSize
                  : kChildSize + kPadding * 2, // child size + padding
              padding: EdgeInsets.all(kPadding),
              alignChildren: Alignment
                  .center, // Keep children centered during alignment switch
              horizontalResizing: AutoLayoutResizing.fixed,
              verticalResizing: AutoLayoutResizing.fixed,
              overflow: AutoLayoutOverflowBehavior.clip,
              backgroundColor: Colors.lime.withValues(alpha: 0.9),
              children: _children,
            ),
          );
        },
      ),
    );
  }
}
