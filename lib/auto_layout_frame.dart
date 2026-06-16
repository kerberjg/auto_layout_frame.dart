library;

// ignore_for_file: prefer_expression_function_bodies, unnecessary_parenthesis

import 'package:flutter/rendering.dart';
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

  /// Shrinks the frame to fit its children as tightly as possible.
  hugContents,

  /// Expands the frame to fill the available space in its parent.
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
  }

  /// Builds the outer layout of the frame,
  /// taking care of resizing behavior and background color.
  @override
  Widget build(final BuildContext context) {
    // Wrap in ColoredBox if [backgroundColor] is specified
    final Widget child = backgroundColor != null
        ? ColoredBox(
            color: backgroundColor!,
            child: _buildInnerLayout(context),
          )
        : _buildInnerLayout(context);

    return _AutoLayoutFrameSize(
      horizontalResizing: horizontalResizing,
      verticalResizing: verticalResizing,
      width: width,
      height: height,
      child: child,
    );
  }

  /// Takes care of padding as well as children's inner placement
  /// (alignment/direction)
  Widget _buildInnerLayout(final BuildContext context) {
    final double spacing = gap != double.infinity ? gap ?? 0 : 0;

    Widget child = switch (direction) {
      AutoLayoutDirection.vertical => Column(
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
        ),
      AutoLayoutDirection.horizontal => Row(
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
          mainAxisSize: horizontalResizing == AutoLayoutResizing.fillContainer
              ? MainAxisSize.max
              : MainAxisSize.min,
          children: _buildChildren(),
        ),
      AutoLayoutDirection.wrap => Wrap(
          spacing: spacing,
          runSpacing: spacing,
          alignment: gap == double.infinity
              ? WrapAlignment.spaceBetween
              : alignChildren.x == 0
                  ? WrapAlignment.center
                  : alignChildren.x == 1
                      ? WrapAlignment.end
                      : WrapAlignment.start,
          runAlignment: alignChildren.y == 0
              ? WrapAlignment.center
              : alignChildren.y == 1
                  ? WrapAlignment.end
                  : WrapAlignment.start,
          children: _buildChildren(),
        ),
    };

    // Wrap in overflow behavior
    switch (overflow) {
      case AutoLayoutOverflowBehavior.none:
        break;
      case AutoLayoutOverflowBehavior.clip:
        child = ClipRect(
          clipBehavior: Clip.hardEdge,
          child: OverflowBox(
            alignment: alignChildren,
            maxWidth: double.infinity,
            maxHeight: double.infinity,
            fit: OverflowBoxFit.deferToChild,
            child: child,
          ),
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
          fit: OverflowBoxFit.deferToChild,
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

    // TODO(kerberjg): perhaps wrap other widgets known to grow infinitely? e.g. ListView, GridView, etc.
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

class _AutoLayoutFrameSize extends SingleChildRenderObjectWidget {
  const _AutoLayoutFrameSize({
    required this.horizontalResizing,
    required this.verticalResizing,
    required this.width,
    required this.height,
    super.child,
  });

  final AutoLayoutResizing horizontalResizing;
  final AutoLayoutResizing verticalResizing;
  final double? width;
  final double? height;

  @override
  RenderObject createRenderObject(final BuildContext context) {
    return _RenderAutoLayoutFrameSize(
      horizontalResizing: horizontalResizing,
      verticalResizing: verticalResizing,
      width: width,
      height: height,
    );
  }

  @override
  void updateRenderObject(final BuildContext context,
      final _RenderAutoLayoutFrameSize renderObject) {
    renderObject
      ..horizontalResizing = horizontalResizing
      ..verticalResizing = verticalResizing
      ..width = width
      ..height = height;
  }
}

class _RenderAutoLayoutFrameSize extends RenderProxyBox {
  _RenderAutoLayoutFrameSize({
    required AutoLayoutResizing horizontalResizing,
    required AutoLayoutResizing verticalResizing,
    required double? width,
    required double? height,
    RenderBox? child,
  })  : _horizontalResizing = horizontalResizing,
        _verticalResizing = verticalResizing,
        _width = width,
        _height = height,
        super(child);

  AutoLayoutResizing _horizontalResizing;
  AutoLayoutResizing get horizontalResizing => _horizontalResizing;
  set horizontalResizing(final AutoLayoutResizing value) {
    if (_horizontalResizing == value) {
      return;
    }
    _horizontalResizing = value;
    markNeedsLayout();
  }

  AutoLayoutResizing _verticalResizing;
  AutoLayoutResizing get verticalResizing => _verticalResizing;
  set verticalResizing(final AutoLayoutResizing value) {
    if (_verticalResizing == value) {
      return;
    }
    _verticalResizing = value;
    markNeedsLayout();
  }

  double? _width;
  double? get width => _width;
  set width(final double? value) {
    if (_width == value) {
      return;
    }
    _width = value;
    markNeedsLayout();
  }

  double? _height;
  double? get height => _height;
  set height(final double? value) {
    if (_height == value) {
      return;
    }
    _height = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    if (child == null) {
      size = constraints.constrain(_targetSize(Size.zero, constraints));
      return;
    }

    child!.layout(_childConstraints(constraints), parentUsesSize: true);
    size = constraints.constrain(_targetSize(child!.size, constraints));
  }

  @override
  Size computeDryLayout(final BoxConstraints constraints) {
    final Size childSize =
        child?.getDryLayout(_childConstraints(constraints)) ?? Size.zero;
    return constraints.constrain(_targetSize(childSize, constraints));
  }

  @override
  double computeMinIntrinsicWidth(final double height) {
    return _intrinsicExtent(
      resizing: horizontalResizing,
      fixedExtent: width,
      childExtent: child?.getMinIntrinsicWidth(height) ?? 0,
      isMin: true,
    );
  }

  @override
  double computeMaxIntrinsicWidth(final double height) {
    return _intrinsicExtent(
      resizing: horizontalResizing,
      fixedExtent: width,
      childExtent: child?.getMaxIntrinsicWidth(height) ?? 0,
      isMin: false,
    );
  }

  @override
  double computeMinIntrinsicHeight(final double width) {
    return _intrinsicExtent(
      resizing: verticalResizing,
      fixedExtent: height,
      childExtent: child?.getMinIntrinsicHeight(width) ?? 0,
      isMin: true,
    );
  }

  @override
  double computeMaxIntrinsicHeight(final double width) {
    return _intrinsicExtent(
      resizing: verticalResizing,
      fixedExtent: height,
      childExtent: child?.getMaxIntrinsicHeight(width) ?? 0,
      isMin: false,
    );
  }

  BoxConstraints _childConstraints(final BoxConstraints constraints) {
    final double? tightWidth = _layoutExtent(
      resizing: horizontalResizing,
      fixedExtent: width,
      maxExtent: constraints.maxWidth,
      hasBoundedExtent: constraints.hasBoundedWidth,
      constrainExtent: constraints.constrainWidth,
    );
    final double? tightHeight = _layoutExtent(
      resizing: verticalResizing,
      fixedExtent: height,
      maxExtent: constraints.maxHeight,
      hasBoundedExtent: constraints.hasBoundedHeight,
      constrainExtent: constraints.constrainHeight,
    );

    return BoxConstraints(
      minWidth: tightWidth ?? constraints.minWidth,
      maxWidth: tightWidth ?? constraints.maxWidth,
      minHeight: tightHeight ?? constraints.minHeight,
      maxHeight: tightHeight ?? constraints.maxHeight,
    );
  }

  Size _targetSize(final Size childSize, final BoxConstraints constraints) {
    return Size(
      _resolvedExtent(
        resizing: horizontalResizing,
        fixedExtent: width,
        childExtent: childSize.width,
        minExtent: constraints.minWidth,
        maxExtent: constraints.maxWidth,
        hasBoundedExtent: constraints.hasBoundedWidth,
        constrainExtent: constraints.constrainWidth,
      ),
      _resolvedExtent(
        resizing: verticalResizing,
        fixedExtent: height,
        childExtent: childSize.height,
        minExtent: constraints.minHeight,
        maxExtent: constraints.maxHeight,
        hasBoundedExtent: constraints.hasBoundedHeight,
        constrainExtent: constraints.constrainHeight,
      ),
    );
  }

  static double _intrinsicExtent({
    required AutoLayoutResizing resizing,
    required double? fixedExtent,
    required double childExtent,
    required bool isMin,
  }) {
    return switch (resizing) {
      AutoLayoutResizing.fixed => fixedExtent ?? 0,
      AutoLayoutResizing.hugContents => childExtent,
      AutoLayoutResizing.fillContainer => isMin ? 0 : double.infinity,
    };
  }

  static double? _layoutExtent({
    required AutoLayoutResizing resizing,
    required double? fixedExtent,
    required double maxExtent,
    required bool hasBoundedExtent,
    required double Function(double) constrainExtent,
  }) {
    return switch (resizing) {
      AutoLayoutResizing.fixed => constrainExtent(fixedExtent ?? 0),
      AutoLayoutResizing.hugContents => null,
      AutoLayoutResizing.fillContainer => hasBoundedExtent ? maxExtent : null,
    };
  }

  static double _resolvedExtent({
    required AutoLayoutResizing resizing,
    required double? fixedExtent,
    required double childExtent,
    required double minExtent,
    required double maxExtent,
    required bool hasBoundedExtent,
    required double Function(double) constrainExtent,
  }) {
    return switch (resizing) {
      AutoLayoutResizing.fixed => constrainExtent(fixedExtent ?? 0),
      AutoLayoutResizing.hugContents => constrainExtent(childExtent),
      AutoLayoutResizing.fillContainer =>
        hasBoundedExtent ? maxExtent : constrainExtent(childExtent),
    };
  }
}
