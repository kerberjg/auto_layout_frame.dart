import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

import 'package:auto_layout_frame/auto_layout_frame.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'auto_layout_frame demo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink)),
      home: const MyHomePage(title: 'auto_layout_frame demo'),
    );
  }
}

const double kIconButtonSize = 16;

// ignore: non_constant_identifier_names
Widget ItemChild(int i) {
  final borderColor = Colors.primaries[i % Colors.primaries.length];

  return Container(
    width: 96,
    height: 96,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: borderColor.shade50,
      border: Border.all(color: borderColor, width: 1.25),
    ),
    child: Center(child: Text('Item ${i + 1}')),
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /// The widgets below this widget in the tree.
  /// NOTE! Infinitely-growing widgets (e.g. [ListView]) must be wrapped in an [Expanded] widget.
  List<Widget> children = [];
  TextEditingController childrenCount = TextEditingController(text: '0');

  /// How much space to place between children in a run in the main axis.
  /// When set to [double.infinity], the children will be spaced evenly
  /// (same as `auto` in Figma)
  double gap = 0;

  /// The amount of space to inset the children in this frame.
  EdgeInsets padding = EdgeInsets.zero;

  bool _paddingShowLTRB = false;

  /// How to align children in the main and cross axis.
  /// Defined by [alignChildren.x] and [alignChildren.y] respectively.
  Alignment alignChildren = Alignment.center;

  /// The direction to layout the children in.
  AutoLayoutDirection direction = AutoLayoutDirection.horizontal;

  /// How this frame should behave when its children overflow its bounds.
  AutoLayoutOverflowBehavior overflow = AutoLayoutOverflowBehavior.none;

  /// How this frame should resize in the horizontal and vertical axis.
  AutoLayoutResizing horizontalResizing = AutoLayoutResizing.hugContents;

  /// How this frame should resize in the horizontal and vertical axis.
  AutoLayoutResizing verticalResizing = AutoLayoutResizing.hugContents;

  /// The width and height of this frame.
  /// Must be specified when the corresponding resizing behavior is set
  /// to [AutoLayoutResizing.fixed], and must not be specified otherwise.
  double? width;

  /// The width and height of this frame.
  /// Must be specified when the corresponding resizing behavior is set
  /// to [AutoLayoutResizing.fixed], and must not be specified otherwise.
  double? height;

  /// The background color of this frame. Defaults to transparent.
  Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    // workaround
    childrenCount.text = children.length.toString();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Row(
        children: [
          Expanded(
            child: Center(
              child: AutoLayoutFrame(
                gap: gap,
                padding: padding,
                alignChildren: alignChildren,
                direction: direction,
                overflow: overflow,
                horizontalResizing: horizontalResizing,
                verticalResizing: verticalResizing,
                width: width,
                height: height,
                backgroundColor: backgroundColor ?? Colors.transparent,
                children: children,
              ),
            ),
          ),
          // Property editor
          Container(
            width: 400,
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            child: Column(
              // title
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Properties", //
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                // property editor goes here
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    children: [
                      // --- Children ---
                      Text(
                        'Children', //
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      // number field with plus/minus buttons to add/remove children
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: children.isEmpty
                                ? null
                                : () => setState(() {
                                    children = children.sublist(0, children.length - 1);
                                  }),
                            child: const Icon(Icons.remove, size: kIconButtonSize),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 60,
                            child: TextFormField(
                              controller: childrenCount,
                              style: TextStyle(height: 0.9),
                              textAlign: TextAlign.center,
                              // decoration: const InputDecoration(labelText: ''),
                              keyboardType: const TextInputType.numberWithOptions(decimal: false),
                              onChanged: (s) => setState(() {
                                final t = s.trim();
                                final n = int.tryParse(t) ?? 0;
                                if (n < children.length) {
                                  children = children.sublist(0, n);
                                } else if (n > children.length) {
                                  children = [
                                    ...children,
                                    ...List.generate(
                                      n - children.length,
                                      (i) => ItemChild(children.length + i),
                                    ),
                                  ];
                                }
                              }),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () => setState(() {
                              children = [...children, ItemChild(children.length)];
                            }),
                            child: const Icon(Icons.add, size: kIconButtonSize),
                          ),
                        ],
                      ),

                      const Divider(height: 32),

                      // --- Direction ---
                      // (show as 3 buttons: horizontal, vertical, (wrap))
                      Text(
                        'Direction', //
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SegmentedButton(
                        segments:
                            [
                                  (
                                    'Horizontal',
                                    Icons.horizontal_distribute_rounded,
                                    AutoLayoutDirection.horizontal,
                                  ),
                                  (
                                    'Vertical',
                                    Icons.vertical_distribute_rounded,
                                    AutoLayoutDirection.vertical,
                                  ),
                                  ('Wrap', Icons.u_turn_right, AutoLayoutDirection.wrap),
                                ]
                                .map(
                                  (e) => ButtonSegment(
                                    value: e.$3,
                                    tooltip: e.$1,
                                    icon: e.$3 == AutoLayoutDirection.wrap
                                        ? Transform.rotate(
                                            angle: 90 * pi / 180,
                                            child: Icon(e.$2, size: kIconButtonSize),
                                          )
                                        : Icon(e.$2, size: kIconButtonSize),
                                  ),
                                )
                                .toList(),
                        selected: {direction},
                        showSelectedIcon: false,
                        onSelectionChanged: (s) => setState(() {
                          direction = s.first;
                        }),
                      ),
                      const SizedBox(height: 12),

                      // --- Overflow ---
                      Text(
                        'Overflow', //
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SegmentedButton(
                        segments:
                            [
                                  ('None', Icons.block_rounded, AutoLayoutOverflowBehavior.none),
                                  (
                                    'Scroll',
                                    Icons.swap_vert_rounded,
                                    AutoLayoutOverflowBehavior.scroll,
                                  ),
                                  (
                                    'Visible',
                                    Icons.remove_red_eye_rounded,
                                    AutoLayoutOverflowBehavior.visible,
                                  ),
                                  (
                                    'Clip',
                                    Icons.content_cut_rounded,
                                    AutoLayoutOverflowBehavior.clip,
                                  ),
                                ]
                                .map(
                                  (v) => ButtonSegment(
                                    value: v.$3,
                                    tooltip: v.$1,
                                    icon: Icon(v.$2, size: kIconButtonSize),
                                  ),
                                )
                                .toList(),
                        selected: {overflow},
                        showSelectedIcon: false,
                        onSelectionChanged: (s) => setState(() {
                          overflow = s.first;
                        }),
                      ),
                      Text(
                        //
                        switch (overflow) {
                          AutoLayoutOverflowBehavior.none =>
                            'Any overflow will result in a \'RenderOverflowError\' (yellow and black stripes in debug mode).',
                          AutoLayoutOverflowBehavior.scroll =>
                            'If children overflow the frame, scrollbars will appear to allow scrolling to see the overflowed content.',
                          AutoLayoutOverflowBehavior.visible =>
                            'Children that overflow the frame will be visible, visually exceeding the bounds without affecting the rest of the layout.',
                          AutoLayoutOverflowBehavior.clip =>
                            'Any overflow will be clipped to the frame\'s bounds and not visible.',
                        },
                        style: TextStyle(fontSize: 11),
                      ),
                      const Divider(height: 32),

                      // --- Gap ---
                      Text(
                        'gap', //
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Row(
                        spacing: 6,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 120,
                            child: TextFormField(
                              initialValue: gap.toString(),
                              style: TextStyle(height: 0.9),
                              enabled: gap.isFinite,
                              decoration: const InputDecoration(labelText: ''),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              onChanged: (s) => setState(() {
                                final t = s.trim();
                                gap = t.isEmpty ? 0 : double.tryParse(t) ?? 0;
                              }),
                            ),
                          ),
                          Expanded(child: SizedBox()),
                          FilterChip(
                            label: const Text(
                              'A',
                              style: TextStyle(
                                fontSize: kIconButtonSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            showCheckmark: false,
                            selected: gap == double.infinity,
                            onSelected: (s) => setState(() {
                              gap = s ? double.infinity : 0;
                            }),
                            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                          ),
                        ],
                      ),
                      const Divider(height: 32),

                      // --- Padding ---
                      Text(
                        'padding', //
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Builder(
                        builder: (_) {
                          final p = padding;

                          void setPadding({
                            double? left,
                            double? top,
                            double? right,
                            double? bottom,
                          }) {
                            setState(() {
                              padding = EdgeInsets.fromLTRB(
                                left ?? p.left,
                                top ?? p.top,
                                right ?? p.right,
                                bottom ?? p.bottom,
                              );
                            });
                          }

                          Widget field(String label, double value, void Function(double?) set) {
                            return SizedBox(
                              width: 100,
                              child: TextFormField(
                                initialValue: value == 0 ? '' : '$value',
                                decoration: InputDecoration(labelText: label),
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                onChanged: (s) => set(double.tryParse(s.trim()) ?? 0),
                              ),
                            );
                          }

                          return Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            crossAxisAlignment: WrapCrossAlignment.end,
                            children: [
                              _paddingShowLTRB
                                  ? field('Left', p.left, (v) => setPadding(left: v))
                                  : field(
                                      'Horizontal',
                                      p.left,
                                      (v) => setPadding(left: v, right: v),
                                    ),
                              _paddingShowLTRB
                                  ? field('Top', p.top, (v) => setPadding(top: v))
                                  : field('Vertical', p.top, (v) => setPadding(top: v, bottom: v)),
                              SizedBox(height: 0, width: 104),
                              FilterChip(
                                label: _paddingShowLTRB
                                    ? const Icon(Icons.border_inner_rounded, size: kIconButtonSize)
                                    : const Icon(Icons.border_outer_rounded, size: kIconButtonSize),
                                showCheckmark: false,
                                selected: _paddingShowLTRB,
                                onSelected: (s) => setState(() {
                                  _paddingShowLTRB = s;
                                }),
                                padding: EdgeInsets.symmetric(horizontal: 2, vertical: 12),
                              ),
                              // newline
                              // newline
                              _paddingShowLTRB
                                  ? field('Right', p.right, (v) => setPadding(right: v))
                                  : SizedBox.shrink(),
                              _paddingShowLTRB
                                  ? field('Bottom', p.bottom, (v) => setPadding(bottom: v))
                                  : SizedBox.shrink(),
                            ],
                          );
                        },
                      ),
                      const Divider(height: 32),

                      // --- Alignment helpers ---
                      Text(
                        'Alignment', //
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: Wrap(
                              spacing: 4,
                              runSpacing: 4,
                              clipBehavior: Clip.hardEdge,
                              children: [
                                for (int y = -1; y <= 1; y++)
                                  for (int x = -1; x <= 1; x++)
                                    ChoiceChip(
                                      // use direction arrows to indicate alignment
                                      label: Icon(
                                        [
                                          Icons.north_west,
                                          Icons.north,
                                          Icons.north_east,
                                          Icons.west,
                                          Icons.circle,
                                          Icons.east,
                                          Icons.south_west,
                                          Icons.south,
                                          Icons.south_east,
                                        ][(y + 1) * 3 + (x + 1)],
                                        size: kIconButtonSize,
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                                      showCheckmark: false,
                                      selected:
                                          alignChildren == Alignment(x.toDouble(), y.toDouble()),
                                      onSelected: (_) => setState(() {
                                        alignChildren = Alignment(x.toDouble(), y.toDouble());
                                      }),
                                    ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // --- Resizing ---
                      Text(
                        'Resizing', //
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      DropdownButtonFormField<AutoLayoutResizing>(
                        initialValue: horizontalResizing,
                        decoration: const InputDecoration(labelText: 'Horizontal'),
                        items: AutoLayoutResizing.values
                            .map((v) => DropdownMenuItem(value: v, child: Text(v.name)))
                            .toList(),
                        onChanged: (v) => setState(() {
                          horizontalResizing = v!;
                          if (v == AutoLayoutResizing.fixed) {
                            width = width ?? 100;
                          } else {
                            width = null;
                          }
                        }),
                      ),
                      Visibility(
                        visible: horizontalResizing == AutoLayoutResizing.fixed,
                        child: TextFormField(
                          initialValue: width?.toString() ?? '',
                          decoration: const InputDecoration(labelText: 'Width'),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (s) {
                            setState(() {
                              final t = s.trim();
                              width = t.isEmpty ? null : double.tryParse(t);

                              if (width != null && horizontalResizing != AutoLayoutResizing.fixed) {
                                horizontalResizing = AutoLayoutResizing.fixed;
                              } else if (width == null &&
                                  horizontalResizing == AutoLayoutResizing.fixed) {
                                horizontalResizing = AutoLayoutResizing.hugContents;
                              }
                            });
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      DropdownButtonFormField<AutoLayoutResizing>(
                        initialValue: verticalResizing,
                        decoration: const InputDecoration(labelText: 'Vertical'),
                        items: AutoLayoutResizing.values
                            .map((v) => DropdownMenuItem(value: v, child: Text(v.name)))
                            .toList(),
                        onChanged: (v) => setState(() {
                          verticalResizing = v!;
                          if (v == AutoLayoutResizing.fixed) {
                            height = height ?? 100;
                          } else {
                            height = null;
                          }
                        }),
                      ),
                      Visibility(
                        visible: verticalResizing == AutoLayoutResizing.fixed,
                        child: TextFormField(
                          initialValue: height?.toString() ?? '',
                          decoration: const InputDecoration(labelText: 'Height'),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (s) {
                            setState(() {
                              final t = s.trim();
                              height = t.isEmpty ? null : double.tryParse(t);

                              if (height != null && verticalResizing != AutoLayoutResizing.fixed) {
                                verticalResizing = AutoLayoutResizing.fixed;
                              } else if (height == null &&
                                  verticalResizing == AutoLayoutResizing.fixed) {
                                verticalResizing = AutoLayoutResizing.hugContents;
                              }
                            });
                          },
                        ),
                      ),
                      const Divider(height: 32),

                      // --- Background color ---
                      // use FlexColorPicker
                      Text(
                        'Background Color', //
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      ColorPicker(
                        color: backgroundColor ?? Colors.transparent,
                        onColorChanged: (color) => setState(() {
                          backgroundColor = color == Colors.transparent ? null : color;
                        }),
                        borderRadius: 6,
                        spacing: 4,
                        runSpacing: 4,
                        wheelDiameter: 100,
                        pickersEnabled: const <ColorPickerType, bool>{
                          ColorPickerType.primary: true,
                          ColorPickerType.accent: false,
                          ColorPickerType.bw: false,
                          ColorPickerType.custom: false,
                          ColorPickerType.wheel: false,
                        },
                        enableShadesSelection: false,
                        showColorCode: true,
                      ),
                      // "clear" button
                      TextButton(
                        onPressed: backgroundColor == null
                            ? null
                            : () => setState(() => backgroundColor = null),
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
