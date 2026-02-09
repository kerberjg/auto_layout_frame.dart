library;

// ignore_for_file: prefer_expression_function_bodies, unnecessary_parenthesis

import 'package:flutter/widgets.dart';

/// Sets the direction to layout the children in.
enum AutoLayoutDirection {
  /// Layout children in a single horizontal line.
  horizontal,

  /// Layout children in a single vertical line.
  vertical,

  /// Layout children in multiple horizontal lines,
  /// breaking at the boundary of the parent.
  wrap,
}

/// Sets the resizing behavior of the frame in the horizontal and vertical axis.
enum AutoLayoutResizing {
  /// The size of the frame is defined explicitly
  /// by the [width] and [height] properties.
  fixed,

  /// same as [ListView.shrinkWrap]
  hugContents,

  /// same as [Expanded]
  fillContainer,
}

/// Sets the behavior of the frame when its children overflow its bounds.
enum AutoLayoutOverflowBehavior {
  /// Allows overflow errors to be thrown
  none,

  /// Clips the overflow to the bounds of the parent
  clip,

  /// Allows overflow to be visible
  visible,

  /// Allows layout to be scrolled
  scroll,
}

/// Flutter implementation of Figma's Auto Layout frames,
/// supporting most of the main features:
/// - Alignement ([alignChildren], [alignSelf])
/// - Padding ([padding])
/// - Gap ([gap])
/// - Resizing ([horizontalResizing], [verticalResizing])
/// - Overflow behavior ([overflow])
///
/// ...as well as some Flutter-specific features:
/// - Background color ([backgroundColor])
/// - Nesting of [AutoLayoutFrame]s (with proper handling of constraints)
class AutoLayoutFrame extends StatelessWidget {
  /// The widgets below this widget in the tree.
  /// NOTE! Infinitely-growing widgets (e.g. [ListView]) must be wrapped in an [Expanded] widget.
  final List<Widget> children;

  /// How much space to place between children in a run in the main axis.
  /// When set to [double.infinity], the children will be spaced evenly
  /// (same as `auto` in Figma)
  final double? gap;

  /// The amount of space to inset the children in this frame.
  final EdgeInsets padding;

  /// How to align children in the main and cross axis.
  /// Defined by [alignChildren.x] and [alignChildren.y] respectively.
  final Alignment alignChildren;

  /// How to align this frame in its parent.
  /// Defined by [alignSelf.x] and [alignSelf.y] respectively.
  final Alignment alignSelf;

  /// The direction to layout the children in.
  final AutoLayoutDirection direction;

  /// How this frame should behave when its children overflow its bounds.
  final AutoLayoutOverflowBehavior overflow;

  /// How this frame should resize in the horizontal and vertical axis.
  final AutoLayoutResizing horizontalResizing;

  /// How this frame should resize in the horizontal and vertical axis.
  final AutoLayoutResizing verticalResizing;

  /// The width and height of this frame.
  /// Must be specified when the corresponding resizing behavior is set
  /// to [AutoLayoutResizing.fixed], and must not be specified otherwise.
  final double? width;

  /// The width and height of this frame.
  /// Must be specified when the corresponding resizing behavior is set
  /// to [AutoLayoutResizing.fixed], and must not be specified otherwise.
  final double? height;

  /// The background color of this frame. Defaults to transparent.
  final Color? backgroundColor;

  /// Whether this frame is nested inside another [AutoLayoutFrame]
  final ValueNotifier<bool?> _isNested = ValueNotifier(null);

  /// Creates an [AutoLayoutFrame] widget.
  AutoLayoutFrame({
    super.key,
    required this.children,
    this.gap,
    this.padding = EdgeInsets.zero,
    this.alignChildren = Alignment.center,
    this.alignSelf = Alignment.topLeft,
    this.direction = AutoLayoutDirection.vertical,
    this.width,
    this.height,
    final AutoLayoutResizing? horizontalResizing,
    final AutoLayoutResizing? verticalResizing,
    this.overflow = AutoLayoutOverflowBehavior.none,
    this.backgroundColor,
  })  : horizontalResizing = horizontalResizing ??
            (width != null
                ? AutoLayoutResizing.fixed
                : AutoLayoutResizing.hugContents),
        verticalResizing = verticalResizing ??
            (height != null
                ? AutoLayoutResizing.fixed
                : AutoLayoutResizing.hugContents) {
    assert(
        !(this.horizontalResizing == AutoLayoutResizing.fixed && width == null),
        "width must be specified when horizontalResizing is fixed");
    assert(
        !(this.verticalResizing == AutoLayoutResizing.fixed && height == null),
        "height must be specified when verticalResizing is fixed");
    assert(
        !(this.horizontalResizing != AutoLayoutResizing.fixed && width != null),
        "width must not be specified when horizontalResizing is not fixed");
    assert(
        !(this.verticalResizing != AutoLayoutResizing.fixed && height != null),
        "height must not be specified when verticalResizing is not fixed");
    // assert(this.verticalResizing != AutoLayoutResizing.fillContainer, "fillContainer has not been implemented yet");
    // assert(this.horizontalResizing != AutoLayoutResizing.fillContainer, "fillContainer has not been implemented yet");
  }

  @override
  Widget build(final BuildContext context) {
    // Check if nested (unless already checked)
    _isNested.value ??=
        context.findAncestorWidgetOfExactType<AutoLayoutFrame>() != null;

    return _buildOuterLayout(context);
  }

  /// Builds the outer layout of the frame,
  /// taking care of resizing behavior and background color.
  Widget _buildOuterLayout(final BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // debugPrint('Frame constraints:${constraints}');

      final Widget child = Stack(
        fit: StackFit.passthrough,
        children: [
          // Background color
          if (backgroundColor != null)
            IgnorePointer(
              // NOTE: this is required because ColoredBox is [HitTestBehavior.opaque]
              ignoring: true,
              child: ColoredBox(
                color: backgroundColor!,
              ),
            ),
          _buildInnerLayout(context),
        ],
      );

      final Widget outerLayout = SizedBox(
        width: switch (horizontalResizing) {
          AutoLayoutResizing.fillContainer => constraints.maxWidth,
          AutoLayoutResizing.hugContents => null,
          AutoLayoutResizing.fixed => width,
        },
        height: switch (verticalResizing) {
          AutoLayoutResizing.fillContainer => constraints.maxHeight,
          AutoLayoutResizing.hugContents => null,
          AutoLayoutResizing.fixed => height,
        },
        child: child,
      );

      // If not nested in another [AutoLayoutFrame], wrap in Align to make sure the size is respected
      // (source: https://stackoverflow.com/questions/54717748/why-flutter-container-does-not-respects-its-width-and-height-constraints-when-it)
      if (!_isNested.value!) {
        return Align(
          alignment: alignSelf,
          child: outerLayout,
        );
      } else {
        return outerLayout;
      }
    });
  }

  /// Takes care of padding as well as children's inner placement
  /// (alignment/direction)
  Widget _buildInnerLayout(final BuildContext context) {
    final double spacing = gap != double.infinity ? gap ?? 0 : 0;

    Widget child = direction == AutoLayoutDirection.vertical
        ? Column(
            spacing: spacing,
            // defined by this.alignment.y
            mainAxisAlignment: gap == double.infinity
                ? MainAxisAlignment.spaceBetween
                : alignChildren.y == 0
                    ? MainAxisAlignment.center
                    : alignChildren.y == 1
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
            // defined by this.alignment.x
            crossAxisAlignment: alignChildren.x == 0
                ? CrossAxisAlignment.center
                : alignChildren.x == 1
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
            mainAxisSize: verticalResizing == AutoLayoutResizing.fillContainer
                ? MainAxisSize.max
                : MainAxisSize.min,
            children: _buildChildren(),
          )
        : direction == AutoLayoutDirection.horizontal
            ? Row(
                spacing: spacing,
                // defined by this.alignment.x
                mainAxisAlignment: gap == double.infinity
                    ? MainAxisAlignment.spaceBetween
                    : alignChildren.x == 0
                        ? MainAxisAlignment.center
                        : alignChildren.x == 1
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                // defined by this.alignment.y
                crossAxisAlignment: alignChildren.y == 0
                    ? CrossAxisAlignment.center
                    : alignChildren.y == 1
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                mainAxisSize:
                    horizontalResizing == AutoLayoutResizing.fillContainer
                        ? MainAxisSize.max
                        : MainAxisSize.min,
                children: _buildChildren(),
              )
            : Wrap(
                spacing: spacing,
                runSpacing: spacing,
                alignment: gap == double.infinity
                    ? WrapAlignment.spaceBetween
                    : alignChildren.x == 0
                        ? WrapAlignment.center
                        : alignChildren.x == 1
                            ? WrapAlignment.end
                            : WrapAlignment.start,
                crossAxisAlignment: alignChildren.y == 0
                    ? WrapCrossAlignment.center
                    : alignChildren.y == 1
                        ? WrapCrossAlignment.end
                        : WrapCrossAlignment.start,
                children: _buildChildren(),
              );

    // Wrap in overflow behavior
    switch (overflow) {
      case AutoLayoutOverflowBehavior.none:
        break;
      case AutoLayoutOverflowBehavior.clip:
        child = ClipRect(
          clipBehavior: Clip.hardEdge,
          child: child,
        );
        break;
      case AutoLayoutOverflowBehavior.scroll:
        child = SingleChildScrollView(
          scrollDirection: direction == AutoLayoutDirection.vertical
              ? Axis.vertical
              : Axis.horizontal,
          restorationId: key?.toString(),
          child: child,
        );
        break;
      case AutoLayoutOverflowBehavior.visible:
        child = OverflowBox(
          alignment: alignChildren,
          maxWidth: double.infinity,
          maxHeight: double.infinity,
          child: child,
        );
        break;
    }

    // Wrap in padding
    child = Padding(
      padding: padding,
      child: child,
    );

    return child;
  }

  /// Builds children with gaps
  List<Widget> _buildChildren() {
    final List<Widget> children = [];
    for (int i = 0; i < this.children.length; i++) {
      // children.add(this.children[i]);
      children.add(_layoutChild(this.children[i]));
    }
    return children;
  }

  /// Handles nested [AutoLayoutFrame]s and wraps them properly.
  ///
  /// When nesting an infinitely growing Widget inside of another,
  /// the layout crashes with an unbound constraint error.
  ///
  /// This would be regularly fixed by simply wrapping the child
  /// in an [Expanded] widget, but this is not possible because then
  /// the parent is required to be a [Flex]/[Row]/[Column]/[Wrap] widget,
  /// which is not always the case when nesting [AutoLayoutFrame]s,
  /// as there's other layout utilities in the middle
  /// (e.g. [Padding], see [_buildInnerLayout] and [_buildOuterLayout]
  /// for reference).
  ///
  /// This method takes care of wrapping the child in a [Flexible] widget
  /// if needed (when the child [AutoLayoutFrame] is growing
  /// in the same direction as the parent),
  /// or in a [Flex] + [Flexible] widget if needed
  /// (when the child [AutoLayoutFrame] is growing
  /// in the perpendicular direction to the parent);
  /// a [Flex] widget is used for this as a replacement for [Row]/[Column],
  /// as it allows to specify the direction dynamically
  /// (we simply flip the axisto make sure it's perpendicular).
  Widget _layoutChild(Widget child) {
    // If not an AutoLayoutFrame, return as is
    if (child is! AutoLayoutFrame) {
      return child;
    }

    // debugPrint("detected child frame!");
    final AutoLayoutFrame childFrame = child;
    final Axis thisAxis = getSimpleAxis();
    // final Axis otherAxis = other.getSimpleAxis();

    // TODO(kerberjg): perhaps wrap other widgets know to grow infinitely? e.g. ListView, GridView, etc.
    // Wrap in [Flexible] if fills container in the same direction
    if (childFrame.isGrowingOnAxis(thisAxis)) {
      child = Flexible(
        child: child,
      );
    }

    // Wrap in perpendicular [Flex] + [Flexible] if fills container in perpendicular direction
    if (childFrame.isGrowingOnAxis(flipAxis(thisAxis))) {
      child = Flex(
        direction: flipAxis(thisAxis),
        children: [
          Flexible(
            child: child,
          ),
        ],
      );
    }

    return child;
  }

  /// Returns the main axis of this frame as an [Axis] enum.
  Axis getSimpleAxis() {
    return direction == AutoLayoutDirection.vertical
        ? Axis.vertical
        : Axis.horizontal;
  }

  /// Returns whether this frame is growing infinitely on the provided axis.
  bool isGrowingOnAxis(final Axis a) {
    return a == Axis.horizontal
        ? horizontalResizing == AutoLayoutResizing.fillContainer
        : verticalResizing == AutoLayoutResizing.fillContainer;
  }

  /// Returns a perpendicular axis to the one provided
  static Axis flipAxis(final Axis a) {
    return a == Axis.horizontal ? Axis.vertical : Axis.horizontal;
  }
}
