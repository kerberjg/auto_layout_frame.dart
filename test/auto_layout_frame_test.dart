import 'package:auto_layout_frame/auto_layout_frame.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

const kColorRed = Color(0xFFFF0000);
const kColorBlue = Color(0xFF0000FF);
const kColorGreen = Color(0xFF00FF00);
const kColorPurple = Color(0xFF800080);

void main() {
  group('AutoLayoutFrame', () {
    group('Constructor Assertions', () {
      test('asserts when horizontalResizing is fixed but width is null', () {
        expect(
          () => AutoLayoutFrame(
            children: [],
            horizontalResizing: AutoLayoutResizing.fixed,
          ),
          throwsAssertionError,
        );
      });

      test('asserts when verticalResizing is fixed but height is null', () {
        expect(
          () => AutoLayoutFrame(
            children: [],
            verticalResizing: AutoLayoutResizing.fixed,
          ),
          throwsAssertionError,
        );
      });

      test('asserts when horizontalResizing is not fixed but width is set', () {
        expect(
          () => AutoLayoutFrame(
            children: [],
            horizontalResizing: AutoLayoutResizing.hugContents,
            width: 100,
          ),
          throwsAssertionError,
        );
      });

      test('asserts when verticalResizing is not fixed but height is set', () {
        expect(
          () => AutoLayoutFrame(
            children: [],
            verticalResizing: AutoLayoutResizing.hugContents,
            height: 100,
          ),
          throwsAssertionError,
        );
      });
    });

    group('Layout Direction', () {
      testWidgets('renders in vertical direction', (WidgetTester tester) async {
        await tester.pumpWidget(
          WidgetsApp(
              color: Color(0xFFFFFFFF),
              builder: (context, child) => Center(
                    child: Center(
                      child: AutoLayoutFrame(
                        direction: AutoLayoutDirection.vertical,
                        horizontalResizing: AutoLayoutResizing.hugContents,
                        verticalResizing: AutoLayoutResizing.hugContents,
                        children: [
                          Container(width: 50, height: 50, color: kColorRed),
                          Container(width: 50, height: 50, color: kColorBlue),
                        ],
                      ),
                    ),
                  )),
        );

        // check size of widget on screen to confirm it layouts correctly
        final Size size = tester.getSize(find.byType(AutoLayoutFrame));
        expect(size.height, greaterThan(size.width));
      });

      testWidgets('renders in horizontal direction',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          WidgetsApp(
            color: Color(0xFFFFFFFF),
            builder: (context, child) => Center(
                child: Center(
              child: AutoLayoutFrame(
                direction: AutoLayoutDirection.horizontal,
                horizontalResizing: AutoLayoutResizing.hugContents,
                verticalResizing: AutoLayoutResizing.hugContents,
                children: [
                  Container(width: 50, height: 50, color: kColorRed),
                  Container(width: 50, height: 50, color: kColorBlue),
                ],
              ),
            )),
          ),
        );

        // check size of widget on screen to confirm it layouts correctly
        final Size size = tester.getSize(find.byType(AutoLayoutFrame));
        expect(size.width, greaterThan(size.height));
      });

      testWidgets('renders in wrap direction', (WidgetTester tester) async {
        await tester.pumpWidget(
          WidgetsApp(
            color: Color(0xFFFFFFFF),
            builder: (context, child) => Center(
              child: AutoLayoutFrame(
                direction: AutoLayoutDirection.wrap,
                children: [
                  Container(width: 100, height: 100, color: kColorRed),
                  Container(width: 100, height: 100, color: kColorBlue),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(Wrap), findsOneWidget);
      });
    });

    group('Resizing Behavior', () {
      testWidgets('fixed size respects width and height',
          (WidgetTester tester) async {
        const double testWidth = 200;
        const double testHeight = 150;

        await tester.pumpWidget(
          WidgetsApp(
            color: Color(0xFFFFFFFF),
            builder: (context, child) => Center(
              child: AutoLayoutFrame(
                width: testWidth,
                height: testHeight,
                horizontalResizing: AutoLayoutResizing.fixed,
                verticalResizing: AutoLayoutResizing.fixed,
                children: [
                  Container(color: kColorRed),
                ],
              ),
            ),
          ),
        );

        final Size size = tester.getSize(find.byType(AutoLayoutFrame));
        expect(size.width, testWidth);
        expect(size.height, testHeight);
      });

      testWidgets('hugContents sizes to children', (WidgetTester tester) async {
        await tester.pumpWidget(
          WidgetsApp(
            color: Color(0xFFFFFFFF),
            builder: (context, child) => Center(
              child: Center(
                child: AutoLayoutFrame(
                  horizontalResizing: AutoLayoutResizing.hugContents,
                  verticalResizing: AutoLayoutResizing.hugContents,
                  children: [
                    Container(width: 100, height: 50, color: kColorRed),
                  ],
                ),
              ),
            ),
          ),
        );

        final Size size = tester.getSize(find.byType(AutoLayoutFrame));
        expect(size.width, 100);
        expect(size.height, 50);
      });

      testWidgets('fillContainer fills available space',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          WidgetsApp(
            color: Color(0xFFFFFFFF),
            builder: (context, child) => Center(
              child: AutoLayoutFrame(
                horizontalResizing: AutoLayoutResizing.fillContainer,
                verticalResizing: AutoLayoutResizing.fillContainer,
                children: [
                  Container(color: kColorRed, width: 100, height: 100),
                ],
              ),
            ),
          ),
        );

        final Size screenSize = tester.getSize(find.byType(Center));
        final Size frameSize = tester.getSize(find.byType(AutoLayoutFrame));
        expect(screenSize, equals(frameSize));
      });

      testWidgets('supports IntrinsicHeight with hugContents',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          WidgetsApp(
            color: Color(0xFFFFFFFF),
            builder: (context, child) => Center(
              child: IntrinsicHeight(
                child: AutoLayoutFrame(
                  direction: AutoLayoutDirection.vertical,
                  horizontalResizing: AutoLayoutResizing.hugContents,
                  verticalResizing: AutoLayoutResizing.hugContents,
                  children: [
                    Container(width: 100, height: 50, color: kColorRed),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);

        final Size size = tester.getSize(find.byType(AutoLayoutFrame));
        expect(size.width, 100);
        expect(size.height, 50);
      });

      testWidgets('supports IntrinsicWidth with hugContents',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          WidgetsApp(
            color: Color(0xFFFFFFFF),
            builder: (context, child) => Center(
              child: IntrinsicWidth(
                child: AutoLayoutFrame(
                  direction: AutoLayoutDirection.horizontal,
                  horizontalResizing: AutoLayoutResizing.hugContents,
                  verticalResizing: AutoLayoutResizing.hugContents,
                  children: [
                    Container(width: 100, height: 50, color: kColorRed),
                  ],
                ),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);

        final Size size = tester.getSize(find.byType(AutoLayoutFrame));
        expect(size.width, 100);
        expect(size.height, 50);
      });

      testWidgets('fixed intrinsic width reports explicit size',
          (WidgetTester tester) async {
        const double fixedWidth = 120;

        await tester.pumpWidget(
          WidgetsApp(
            color: Color(0xFFFFFFFF),
            builder: (context, child) => Center(
              child: AutoLayoutFrame(
                width: fixedWidth,
                horizontalResizing: AutoLayoutResizing.fixed,
                verticalResizing: AutoLayoutResizing.hugContents,
                children: [
                  Container(width: 100, height: 50, color: kColorRed),
                ],
              ),
            ),
          ),
        );

        final RenderBox box = tester.renderObject(find.byType(AutoLayoutFrame));
        expect(box.getMinIntrinsicWidth(50), fixedWidth);
        expect(box.getMaxIntrinsicWidth(50), fixedWidth);
      });

      testWidgets('fillContainer intrinsic width reports 0 and infinity',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          WidgetsApp(
            color: Color(0xFFFFFFFF),
            builder: (context, child) => Center(
              child: AutoLayoutFrame(
                direction: AutoLayoutDirection.horizontal,
                horizontalResizing: AutoLayoutResizing.fillContainer,
                verticalResizing: AutoLayoutResizing.hugContents,
                children: [
                  Container(width: 100, height: 50, color: kColorRed),
                ],
              ),
            ),
          ),
        );

        final RenderBox box = tester.renderObject(find.byType(AutoLayoutFrame));
        expect(box.getMinIntrinsicWidth(50), 0);
        expect(box.getMaxIntrinsicWidth(50), double.infinity);
      });
    });

    group('Overflow Behavior', () {
      testWidgets('none allows overflow errors', (WidgetTester tester) async {
        await tester.pumpWidget(WidgetsApp(
          color: Color(0xFFFFFFFF),
          builder: (context, child) => Center(
            child: SizedBox(
              width: 100,
              height: 50,
              child: AutoLayoutFrame(
                overflow: AutoLayoutOverflowBehavior.none,
                children: [
                  Container(width: 100, height: 100, color: kColorRed),
                ],
              ),
            ),
          ),
        ));

        // expect overflow error to be thrown when rendering
        final FlutterError error = tester.takeException() as FlutterError;
        expect(error.toString(), contains('A RenderFlex overflowed by'));
      });

      testWidgets('clip reduces size', (WidgetTester tester) async {
        await tester.pumpWidget(
          WidgetsApp(
            color: Color(0xFFFFFFFF),
            builder: (context, child) => Center(
              child: SizedBox(
                width: 100,
                height: 50,
                child: AutoLayoutFrame(
                  overflow: AutoLayoutOverflowBehavior.clip,
                  children: [
                    Container(width: 100, height: 100, color: kColorRed),
                  ],
                ),
              ),
            ),
          ),
        );

        final Size size = tester.getSize(find.byType(AutoLayoutFrame));
        expect(size.width, 100);
        expect(size.height, 50);
      });

      testWidgets("clip doesn't affect cross axis size with hugContents",
          (WidgetTester tester) async {
        const Size childSize = Size(100, 100);
        const Size clipSize = Size(50, 200);

        await tester.pumpWidget(
          WidgetsApp(
            color: Color(0xFFFFFFFF),
            builder: (context, child) => Center(
              child: AutoLayoutFrame(
                direction: AutoLayoutDirection.horizontal,
                overflow: AutoLayoutOverflowBehavior.clip,
                horizontalResizing: AutoLayoutResizing.fixed,
                width: clipSize.width,
                verticalResizing: AutoLayoutResizing.hugContents,
                children: [
                  Container(
                      width: childSize.width,
                      height: childSize.height,
                      color: kColorRed),
                ],
              ),
            ),
          ),
        );

        final Size actualSize = tester.getSize(find.byType(AutoLayoutFrame));
        expect(actualSize.width, clipSize.width);
        expect(actualSize.height, childSize.height);
      });

      testWidgets("overflow doesn't affect cross axis size with hugContents",
          (WidgetTester tester) async {
        const Size childSize = Size(100, 100);
        const Size frameSize = Size(50, 200);

        await tester.pumpWidget(
          WidgetsApp(
            color: Color(0xFFFFFFFF),
            builder: (context, child) => Center(
              child: AutoLayoutFrame(
                direction: AutoLayoutDirection.horizontal,
                overflow: AutoLayoutOverflowBehavior.visible,
                horizontalResizing: AutoLayoutResizing.fixed,
                width: frameSize.width,
                verticalResizing: AutoLayoutResizing.hugContents,
                children: [
                  Container(
                      width: childSize.width,
                      height: childSize.height,
                      color: kColorRed),
                ],
              ),
            ),
          ),
        );

        final Size actualSize = tester.getSize(find.byType(AutoLayoutFrame));
        expect(actualSize.width, frameSize.width);
        expect(actualSize.height, childSize.height);
      });

      testWidgets('scroll wraps in SingleChildScrollView',
          (WidgetTester tester) async {
        await tester.pumpWidget(WidgetsApp(
          color: Color(0xFFFFFFFF),
          builder: (context, child) => Center(
            child: SizedBox(
              width: 100,
              height: 50,
              child: AutoLayoutFrame(
                overflow: AutoLayoutOverflowBehavior.scroll,
                children: [
                  Container(width: 100, height: 100, color: kColorRed),
                ],
              ),
            ),
          ),
        ));

        // check height
        final Size size = tester.getSize(find.byType(AutoLayoutFrame));
        expect(size.height, 50);

        // check if scrollable
        final SingleChildScrollView scrollView = find
            .byType(SingleChildScrollView)
            .evaluate()
            .first
            .widget as SingleChildScrollView;
        expect(scrollView, isNotNull);
      });

      testWidgets('visible wraps in OverflowBox', (WidgetTester tester) async {
        await tester.pumpWidget(WidgetsApp(
          color: Color(0xFFFFFFFF),
          builder: (context, child) => Center(
            child: SizedBox(
              width: 100,
              height: 50,
              child: AutoLayoutFrame(
                overflow: AutoLayoutOverflowBehavior.visible,
                direction: AutoLayoutDirection.vertical,
                gap: 0,
                children: [
                  Container(width: 100, height: 100, color: kColorRed),
                ],
              ),
            ),
          ),
        ));

        // AutoLayoutFrame size should match parent constraints...
        final Size frameSize = tester.getSize(find.byType(AutoLayoutFrame));
        expect(frameSize.width, 100);
        expect(frameSize.height, 50);

        // ...but child of OverflowBox should be able to overflow
        // and have its own size
        final Size size = tester.getSize(find.descendant(
            of: find.byType(OverflowBox), matching: find.byType(Column)));
        expect(size.width, 100);
        expect(size.height, 100);
      });
    });

    group('Padding and Gap', () {
      testWidgets('applies padding to children', (WidgetTester tester) async {
        const EdgeInsets testPadding = EdgeInsets.all(16);

        await tester.pumpWidget(
          WidgetsApp(
            color: Color(0xFFFFFFFF),
            builder: (context, child) => Center(
              child: AutoLayoutFrame(
                padding: testPadding,
                children: [
                  Container(width: 100, height: 100, color: kColorRed),
                ],
              ),
            ),
          ),
        );

        final Padding padding =
            find.byType(Padding).evaluate().first.widget as Padding;
        expect(padding.padding, testPadding);
      });

      testWidgets('applies gap between children with vertical direction',
          (WidgetTester tester) async {
        const double testGap = 8;

        await tester.pumpWidget(
          WidgetsApp(
            color: Color(0xFFFFFFFF),
            builder: (context, child) => Center(
              child: AutoLayoutFrame(
                direction: AutoLayoutDirection.vertical,
                gap: testGap,
                children: [
                  Container(width: 100, height: 50, color: kColorRed),
                  Container(width: 100, height: 50, color: kColorBlue),
                ],
              ),
            ),
          ),
        );

        final Column column =
            find.byType(Column).evaluate().first.widget as Column;
        expect(column.spacing, testGap);
      });

      testWidgets('applies gap between children with horizontal direction',
          (WidgetTester tester) async {
        const double testGap = 8;

        await tester.pumpWidget(
          WidgetsApp(
            color: Color(0xFFFFFFFF),
            builder: (context, child) => Center(
              child: AutoLayoutFrame(
                direction: AutoLayoutDirection.horizontal,
                gap: testGap,
                children: [
                  Container(width: 50, height: 100, color: kColorRed),
                  Container(width: 50, height: 100, color: kColorBlue),
                ],
              ),
            ),
          ),
        );

        final Row row = find.byType(Row).evaluate().first.widget as Row;
        expect(row.spacing, testGap);
      });

      testWidgets('gap of infinity uses spaceBetween alignment',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          WidgetsApp(
            color: Color(0xFFFFFFFF),
            builder: (context, child) => Center(
              child: AutoLayoutFrame(
                direction: AutoLayoutDirection.vertical,
                gap: double.infinity,
                children: [
                  Container(width: 100, height: 50, color: kColorRed),
                  Container(width: 100, height: 50, color: kColorBlue),
                ],
              ),
            ),
          ),
        );

        final Column column =
            find.byType(Column).evaluate().first.widget as Column;
        expect(column.mainAxisAlignment, MainAxisAlignment.spaceBetween);
      });
    });

    group('Alignment', () {
      testWidgets('alignChildren centers content by default',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          WidgetsApp(
            color: Color(0xFFFFFFFF),
            builder: (context, child) => Center(
              child: AutoLayoutFrame(
                alignChildren: Alignment.center,
                direction: AutoLayoutDirection.vertical,
                children: [
                  Container(width: 100, height: 50, color: kColorRed),
                ],
              ),
            ),
          ),
        );

        final Column column =
            find.byType(Column).evaluate().first.widget as Column;
        expect(column.mainAxisAlignment, MainAxisAlignment.center);
        expect(column.crossAxisAlignment, CrossAxisAlignment.center);
      });

      testWidgets('alignChildren.start aligns to start',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          WidgetsApp(
            color: Color(0xFFFFFFFF),
            builder: (context, child) => Center(
              child: AutoLayoutFrame(
                alignChildren: Alignment.topLeft,
                direction: AutoLayoutDirection.vertical,
                children: [
                  Container(width: 100, height: 50, color: kColorRed),
                ],
              ),
            ),
          ),
        );

        final Column column =
            find.byType(Column).evaluate().first.widget as Column;
        expect(column.mainAxisAlignment, MainAxisAlignment.start);
        expect(column.crossAxisAlignment, CrossAxisAlignment.start);
      });

      testWidgets('alignChildren.end aligns to end',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          WidgetsApp(
            color: Color(0xFFFFFFFF),
            builder: (context, child) => Center(
              child: AutoLayoutFrame(
                alignChildren: Alignment.bottomRight,
                direction: AutoLayoutDirection.vertical,
                children: [
                  Container(width: 100, height: 50, color: kColorRed),
                ],
              ),
            ),
          ),
        );

        final Column column =
            find.byType(Column).evaluate().first.widget as Column;
        expect(column.mainAxisAlignment, MainAxisAlignment.end);
        expect(column.crossAxisAlignment, CrossAxisAlignment.end);
      });

      testWidgets('alignSelf affects frame alignment in parent',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          WidgetsApp(
            color: Color(0xFFFFFFFF),
            builder: (context, child) => Center(
              child: AutoLayoutFrame(
                alignSelf: Alignment.bottomRight,
                children: [
                  Container(width: 100, height: 100, color: kColorRed),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(AutoLayoutFrame), findsOneWidget);
      });
    });

    group('Background Color', () {
      testWidgets('applies background color', (WidgetTester tester) async {
        const Color testColor = Color.fromARGB(255, 182, 40, 207);

        await tester.pumpWidget(
          WidgetsApp(
            color: Color(0xFFFFFFFF),
            builder: (context, child) => Center(
              child: AutoLayoutFrame(
                backgroundColor: testColor,
                children: [
                  Container(width: 100, height: 100, color: kColorRed),
                ],
              ),
            ),
          ),
        );

        final ColoredBox coloredBox =
            find.byType(ColoredBox).evaluate().first.widget as ColoredBox;
        expect(coloredBox.color, testColor);
      });

      testWidgets('children are clickable', (WidgetTester tester) async {
        bool wasTapped = false;

        await tester.pumpWidget(
          WidgetsApp(
            color: Color(0xFFFFFFFF),
            builder: (context, child) => Center(
              child: AutoLayoutFrame(
                backgroundColor: kColorPurple,
                children: [
                  GestureDetector(
                    key: const Key('tappable-child'),
                    onTap: () => wasTapped = true,
                    child: Container(width: 100, height: 100, color: kColorRed),
                  ),
                ],
              ),
            ),
          ),
        );

        await tester.tap(find.byKey(const Key('tappable-child')));
        expect(wasTapped, isTrue);
      });
    });

    group('Nested Frames', () {
      testWidgets(
          'handles nested AutoLayoutFrames in a vertical layout (perpendicular child)',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          WidgetsApp(
            color: Color(0xFFFFFFFF),
            builder: (context, child) => Center(
              child: AutoLayoutFrame(
                direction: AutoLayoutDirection.vertical,
                children: [
                  AutoLayoutFrame(
                    direction: AutoLayoutDirection.horizontal,
                    children: [
                      Container(width: 50, height: 100, color: kColorRed),
                      Container(width: 50, height: 100, color: kColorBlue),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(AutoLayoutFrame), findsWidgets);
      });

      testWidgets(
          'handles nested AutoLayoutFrames in a vertical layout (parallel child)',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          WidgetsApp(
            color: Color(0xFFFFFFFF),
            builder: (context, child) => Center(
              child: AutoLayoutFrame(
                direction: AutoLayoutDirection.vertical,
                children: [
                  AutoLayoutFrame(
                    direction: AutoLayoutDirection.vertical,
                    children: [
                      Container(width: 100, height: 50, color: kColorRed),
                      Container(width: 100, height: 50, color: kColorBlue),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(AutoLayoutFrame), findsWidgets);
      });

      testWidgets(
          'handles nested AutoLayoutFrames in a horizontal layout (perpendicular child)',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          WidgetsApp(
            color: Color(0xFFFFFFFF),
            builder: (context, child) => Center(
              child: AutoLayoutFrame(
                direction: AutoLayoutDirection.horizontal,
                children: [
                  AutoLayoutFrame(
                    direction: AutoLayoutDirection.vertical,
                    children: [
                      Container(width: 100, height: 50, color: kColorRed),
                      Container(width: 100, height: 50, color: kColorBlue),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(AutoLayoutFrame), findsWidgets);
      });

      testWidgets(
          'handles nested AutoLayoutFrames in a horizontal layout (parallel child)',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          WidgetsApp(
            color: Color(0xFFFFFFFF),
            builder: (context, child) => Center(
              child: AutoLayoutFrame(
                direction: AutoLayoutDirection.horizontal,
                children: [
                  AutoLayoutFrame(
                    direction: AutoLayoutDirection.horizontal,
                    children: [
                      Container(width: 50, height: 100, color: kColorRed),
                      Container(width: 50, height: 100, color: kColorBlue),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(AutoLayoutFrame), findsWidgets);
      });

      testWidgets('wraps nested frame in Flexible when growing on same axis',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          WidgetsApp(
            color: Color(0xFFFFFFFF),
            builder: (context, child) => Center(
              child: AutoLayoutFrame(
                direction: AutoLayoutDirection.vertical,
                verticalResizing: AutoLayoutResizing.fillContainer,
                children: [
                  AutoLayoutFrame(
                    direction: AutoLayoutDirection.vertical,
                    verticalResizing: AutoLayoutResizing.fillContainer,
                    children: [
                      Container(color: kColorRed),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(Flexible), findsWidgets);
      });

      testWidgets('parent hugs child correctly', (WidgetTester tester) async {
        const Size expected = Size(100, 50);

        await tester.pumpWidget(
          WidgetsApp(
            color: Color(0xFFFFFFFF),
            builder: (context, child) => Center(
              child: AutoLayoutFrame(
                direction: AutoLayoutDirection.vertical,
                verticalResizing: AutoLayoutResizing.hugContents,
                horizontalResizing: AutoLayoutResizing.hugContents,
                children: [
                  AutoLayoutFrame(
                    direction: AutoLayoutDirection.vertical,
                    verticalResizing: AutoLayoutResizing.hugContents,
                    horizontalResizing: AutoLayoutResizing.hugContents,
                    children: [
                      Container(
                          width: expected.width,
                          height: expected.height,
                          color: kColorRed),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        final Size actual = tester.getSize(find.byType(AutoLayoutFrame).first);
        expect(actual.width, expected.width);
        expect(actual.height, expected.height);
      });
    });

    group('Children Rendering', () {
      testWidgets('renders all children', (WidgetTester tester) async {
        await tester.pumpWidget(
          WidgetsApp(
            color: Color(0xFFFFFFFF),
            builder: (context, child) => Center(
              child: AutoLayoutFrame(
                children: [
                  Container(width: 100, height: 50, color: kColorRed),
                  Container(width: 100, height: 50, color: kColorBlue),
                  Container(width: 100, height: 50, color: kColorGreen),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(Container), findsWidgets);
      });

      testWidgets('renders empty children list', (WidgetTester tester) async {
        await tester.pumpWidget(
          WidgetsApp(
            color: Color(0xFFFFFFFF),
            builder: (context, child) => Center(
              child: AutoLayoutFrame(
                children: [],
              ),
            ),
          ),
        );

        expect(find.byType(AutoLayoutFrame), findsOneWidget);
      });
    });

    group('Scroll Behavior', () {
      testWidgets('scroll direction is vertical for vertical layout',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          WidgetsApp(
            color: Color(0xFFFFFFFF),
            builder: (context, child) => Center(
              child: AutoLayoutFrame(
                direction: AutoLayoutDirection.vertical,
                overflow: AutoLayoutOverflowBehavior.scroll,
                children: [
                  Container(width: 100, height: 500, color: kColorRed),
                ],
              ),
            ),
          ),
        );

        final SingleChildScrollView scrollView = find
            .byType(SingleChildScrollView)
            .evaluate()
            .first
            .widget as SingleChildScrollView;
        expect(scrollView.scrollDirection, Axis.vertical);
      });

      testWidgets('scroll direction is horizontal for horizontal layout',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          WidgetsApp(
            color: Color(0xFFFFFFFF),
            builder: (context, child) => Center(
              child: AutoLayoutFrame(
                direction: AutoLayoutDirection.horizontal,
                overflow: AutoLayoutOverflowBehavior.scroll,
                children: [
                  Container(width: 500, height: 100, color: kColorRed),
                ],
              ),
            ),
          ),
        );

        final SingleChildScrollView scrollView = find
            .byType(SingleChildScrollView)
            .evaluate()
            .first
            .widget as SingleChildScrollView;
        expect(scrollView.scrollDirection, Axis.horizontal);
      });

      testWidgets('scroll mode provides finite viewport with scroll extent',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          WidgetsApp(
            color: Color(0xFFFFFFFF),
            builder: (context, child) => Center(
              child: SizedBox(
                width: 120,
                height: 120,
                child: AutoLayoutFrame(
                  direction: AutoLayoutDirection.horizontal,
                  overflow: AutoLayoutOverflowBehavior.scroll,
                  horizontalResizing: AutoLayoutResizing.hugContents,
                  verticalResizing: AutoLayoutResizing.hugContents,
                  children: [
                    Container(width: 96, height: 96, color: kColorRed),
                    Container(width: 96, height: 96, color: kColorBlue),
                    Container(width: 96, height: 96, color: kColorGreen),
                  ],
                ),
              ),
            ),
          ),
        );

        final SingleChildScrollView scrollView = find
            .byType(SingleChildScrollView)
            .evaluate()
            .first
            .widget as SingleChildScrollView;
        expect(scrollView.scrollDirection, Axis.horizontal);

        final ScrollableState scrollableState =
            tester.state(find.byType(Scrollable));
        final double before = scrollableState.position.pixels;
        expect(scrollableState.position.maxScrollExtent, greaterThan(0));

        await tester.drag(find.byType(SingleChildScrollView), Offset(-80, 0));
        await tester.pumpAndSettle();

        final double after = scrollableState.position.pixels;
        expect(after, greaterThan(before));
      });

      testWidgets(
          'vertical scroll mode provides finite viewport with scroll extent',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          WidgetsApp(
            color: Color(0xFFFFFFFF),
            builder: (context, child) => Center(
              child: SizedBox(
                width: 120,
                height: 120,
                child: AutoLayoutFrame(
                  direction: AutoLayoutDirection.vertical,
                  overflow: AutoLayoutOverflowBehavior.scroll,
                  horizontalResizing: AutoLayoutResizing.hugContents,
                  verticalResizing: AutoLayoutResizing.hugContents,
                  children: [
                    Container(width: 96, height: 96, color: kColorRed),
                    Container(width: 96, height: 96, color: kColorBlue),
                    Container(width: 96, height: 96, color: kColorGreen),
                  ],
                ),
              ),
            ),
          ),
        );

        final SingleChildScrollView scrollView = find
            .byType(SingleChildScrollView)
            .evaluate()
            .first
            .widget as SingleChildScrollView;
        expect(scrollView.scrollDirection, Axis.vertical);

        final ScrollableState scrollableState =
            tester.state(find.byType(Scrollable));
        final double before = scrollableState.position.pixels;
        expect(scrollableState.position.maxScrollExtent, greaterThan(0));

        await tester.drag(find.byType(SingleChildScrollView), Offset(0, -80));
        await tester.pumpAndSettle();

        final double after = scrollableState.position.pixels;
        expect(after, greaterThan(before));
      });
    });

    group('MainAxisSize', () {
      testWidgets('uses MainAxisSize.max for fillContainer',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          WidgetsApp(
            color: Color(0xFFFFFFFF),
            builder: (context, child) => Center(
              child: AutoLayoutFrame(
                direction: AutoLayoutDirection.vertical,
                verticalResizing: AutoLayoutResizing.fillContainer,
                children: [
                  Container(width: 100, height: 50, color: kColorRed),
                ],
              ),
            ),
          ),
        );

        final Column column =
            find.byType(Column).evaluate().first.widget as Column;
        expect(column.mainAxisSize, MainAxisSize.max);
      });

      testWidgets('uses MainAxisSize.min for non-fillContainer',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          WidgetsApp(
            color: Color(0xFFFFFFFF),
            builder: (context, child) => Center(
              child: AutoLayoutFrame(
                direction: AutoLayoutDirection.vertical,
                verticalResizing: AutoLayoutResizing.hugContents,
                children: [
                  Container(width: 100, height: 50, color: kColorRed),
                ],
              ),
            ),
          ),
        );

        final Column column =
            find.byType(Column).evaluate().first.widget as Column;
        expect(column.mainAxisSize, MainAxisSize.min);
      });
    });
  });
}
