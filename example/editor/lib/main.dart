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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
      ),
      home: const MyHomePage(title: 'auto_layout_frame demo'),
    );
  }
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

  /// How much space to place between children in a run in the main axis.
  /// When set to [double.infinity], the children will be spaced evenly
  /// (same as `auto` in Figma)
  double? gap;

  /// The amount of space to inset the children in this frame.
  EdgeInsets? padding;

  /// How to align children in the main and cross axis.
  /// Defined by [alignChildren.x] and [alignChildren.y] respectively.
  Alignment alignChildren = Alignment.center;

  /// How to align this frame in its parent.
  /// Defined by [alignSelf.x] and [alignSelf.y] respectively.
  Alignment? alignSelf;

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
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Row(
        children: [
          Expanded(
            child: Center(
              child: AutoLayoutFrame(
                gap: gap,
                padding: padding ?? EdgeInsets.zero,
                alignChildren: alignChildren,
                alignSelf: alignSelf ?? Alignment.center,
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
            width: 320,
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            child: Column(
              // title
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Properties",
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
                        'Children',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          FilledButton.tonal(
                            onPressed: () {
                              setState(() {
                                final index = children.length + 1;
                                children = [
                                  ...children,
                                  Container(
                                    width: 80,
                                    height: 80,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primaryContainer,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                    ),
                                    child: Text('Item $index'),
                                  ),
                                ];
                              });
                            },
                            child: const Text('Add'),
                          ),
                          FilledButton.tonal(
                            onPressed: children.isEmpty
                                ? null
                                : () {
                                    setState(() {
                                      children = children.sublist(
                                        0,
                                        children.length - 1,
                                      );
                                    });
                                  },
                            child: const Text('Remove last'),
                          ),
                          FilledButton.tonal(
                            onPressed: children.isEmpty
                                ? null
                                : () {
                                    setState(() {
                                      children = [];
                                    });
                                  },
                            child: const Text('Clear'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Count: ${children.length}'),
                      const Divider(height: 24),

                      // --- Direction ---
                      // (show as 3 buttons: horizontal, vertical, (wrap))
                      Text(
                        'direction',
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
                                  (
                                    'Wrap',
                                    Icons.u_turn_right,
                                    AutoLayoutDirection.wrap,
                                  ),
                                ]
                                .map(
                                  (e) => ButtonSegment(
                                    value: e.$3,
                                    tooltip: e.$1,
                                    icon: e.$3 == AutoLayoutDirection.wrap
                                        ? Transform.rotate(
                                            angle: 90 * pi / 180,
                                            child: Icon(e.$2, size: 16),
                                          )
                                        : Icon(e.$2, size: 16),
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
                        'overflow',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SegmentedButton(
                        segments:
                            [
                                  (
                                    'None',
                                    Icons.block_rounded,
                                    AutoLayoutOverflowBehavior.none,
                                  ),
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
                                    icon: Icon(v.$2, size: 16),
                                    enabled:
                                        !(v.$3 ==
                                                AutoLayoutOverflowBehavior
                                                    .visible &&
                                            (horizontalResizing ==
                                                    AutoLayoutResizing
                                                        .hugContents ||
                                                verticalResizing ==
                                                    AutoLayoutResizing
                                                        .hugContents)),
                                  ),
                                )
                                .toList(),
                        selected: {overflow},
                        showSelectedIcon: false,
                        onSelectionChanged: (s) => setState(() {
                          overflow = s.first;
                        }),
                      ),
                      const Divider(height: 24),

                      // --- Gap ---
                      Text(
                        'gap',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Row(
                        spacing: 6,
                        children: [
                          SizedBox(
                            width: 120,
                            child: TextFormField(
                              initialValue:
                                  double.tryParse(
                                    gap?.toString() ?? '0',
                                  )?.toString() ??
                                  '0',
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              onChanged: (s) => setState(() {
                                final t = s.trim();
                                gap = t.isEmpty ? 0 : double.tryParse(t);
                              }),
                            ),
                          ),
                          FilterChip(
                            label: const Text(
                              'A',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            showCheckmark: false,
                            selected: gap == double.infinity,
                            onSelected: (s) => setState(() {
                              gap = s ? double.infinity : 0;
                            }),
                            padding: EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 0,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),

                      // --- Padding ---
                      Text(
                        'padding',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Enable padding'),
                        value: padding != null,
                        onChanged: (enabled) {
                          setState(() {
                            padding = enabled ? EdgeInsets.zero : null;
                          });
                        },
                      ),
                      Builder(
                        builder: (_) {
                          final p = padding ?? EdgeInsets.zero;

                          void setPadding({
                            double? left,
                            double? top,
                            double? right,
                            double? bottom,
                          }) {
                            final next = EdgeInsets.fromLTRB(
                              left ?? p.left,
                              top ?? p.top,
                              right ?? p.right,
                              bottom ?? p.bottom,
                            );
                            setState(() {
                              padding = (next == EdgeInsets.zero)
                                  ? (padding == null ? null : next)
                                  : next;
                            });
                          }

                          Widget field(
                            String label,
                            double value,
                            void Function(double?) set,
                          ) {
                            return Expanded(
                              child: TextFormField(
                                initialValue: value == 0 ? '' : '$value',
                                enabled: padding != null,
                                decoration: InputDecoration(labelText: label),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                onChanged: (s) =>
                                    set(double.tryParse(s.trim()) ?? 0),
                              ),
                            );
                          }

                          return Row(
                            children: [
                              field('L', p.left, (v) => setPadding(left: v)),
                              const SizedBox(width: 8),
                              field('T', p.top, (v) => setPadding(top: v)),
                              const SizedBox(width: 8),
                              field('R', p.right, (v) => setPadding(right: v)),
                              const SizedBox(width: 8),
                              field(
                                'B',
                                p.bottom,
                                (v) => setPadding(bottom: v),
                              ),
                            ],
                          );
                        },
                      ),
                      const Divider(height: 24),

                      // --- Alignment helpers ---
                      Text(
                        'alignChildren',
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
                                        size: 16,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 0,
                                        vertical: 10,
                                      ),
                                      showCheckmark: false,
                                      selected:
                                          alignChildren ==
                                          Alignment(x.toDouble(), y.toDouble()),
                                      onSelected: (_) => setState(() {
                                        alignChildren = Alignment(
                                          x.toDouble(),
                                          y.toDouble(),
                                        );
                                      }),
                                    ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // --- Resizing ---
                      DropdownButtonFormField<AutoLayoutResizing>(
                        initialValue: horizontalResizing,
                        decoration: const InputDecoration(
                          labelText: 'horizontalResizing',
                        ),
                        items: AutoLayoutResizing.values
                            .map(
                              (v) => DropdownMenuItem(
                                value: v,
                                child: Text(v.name),
                              ),
                            )
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
                      const SizedBox(height: 12),
                      DropdownButtonFormField<AutoLayoutResizing>(
                        initialValue: verticalResizing,
                        decoration: const InputDecoration(
                          labelText: 'verticalResizing',
                        ),
                        items: AutoLayoutResizing.values
                            .map(
                              (v) => DropdownMenuItem(
                                value: v,
                                child: Text(v.name),
                              ),
                            )
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
                      const Divider(height: 24),

                      // --- Width / Height ---
                      TextFormField(
                        initialValue: width?.toString() ?? '',
                        decoration: const InputDecoration(
                          labelText: 'width (double?)',
                          helperText: 'Empty = null',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onChanged: (s) {
                          setState(() {
                            final t = s.trim();
                            width = t.isEmpty ? null : double.tryParse(t);

                            if (width != null &&
                                horizontalResizing !=
                                    AutoLayoutResizing.fixed) {
                              horizontalResizing = AutoLayoutResizing.fixed;
                            } else if (width == null &&
                                horizontalResizing ==
                                    AutoLayoutResizing.fixed) {
                              horizontalResizing =
                                  AutoLayoutResizing.hugContents;
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        initialValue: height?.toString() ?? '',
                        decoration: const InputDecoration(
                          labelText: 'height (double?)',
                          helperText: 'Empty = null',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onChanged: (s) {
                          setState(() {
                            final t = s.trim();
                            height = t.isEmpty ? null : double.tryParse(t);

                            if (height != null &&
                                verticalResizing != AutoLayoutResizing.fixed) {
                              verticalResizing = AutoLayoutResizing.fixed;
                            } else if (height == null &&
                                verticalResizing == AutoLayoutResizing.fixed) {
                              verticalResizing = AutoLayoutResizing.hugContents;
                            }
                          });
                        },
                      ),
                      const Divider(height: 24),

                      // --- Background color ---
                      // use FlexColorPicker
                      Text(
                        'backgroundColor',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      ColorPicker(
                        color: backgroundColor ?? Colors.transparent,
                        onColorChanged: (color) => setState(() {
                          backgroundColor = color == Colors.transparent
                              ? null
                              : color;
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
