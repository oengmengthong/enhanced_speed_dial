import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:enhanced_speed_dial/enhanced_speed_dial.dart';

void main() {
  testWidgets('EnhancedSpeedDial can be instantiated',
      (WidgetTester tester) async {
    // Create a test app with the Enhanced Speed Dial
    final testApp = MaterialApp(
      home: Scaffold(
        floatingActionButton: EnhancedSpeedDial(
          mainIcon: Icons.add,
          options: [
            SpeedDialOption(
              label: 'Test',
              icon: Icons.star,
              color: Colors.blue,
              heroTag: 'test_tag',
              onTap: () {},
            ),
          ],
        ),
      ),
    );

    // Build the widget
    await tester.pumpWidget(testApp);

    // Verify that the floating action button is rendered
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('EnhancedSpeedDial opens and shows options',
      (WidgetTester tester) async {
    // Create a test app with the Enhanced Speed Dial
    final testApp = MaterialApp(
      home: Scaffold(
        floatingActionButton: EnhancedSpeedDial(
          mainIcon: Icons.add,
          openIcon: Icons.close,
          options: [
            SpeedDialOption(
              label: 'Test Option',
              icon: Icons.star,
              color: Colors.red,
              heroTag: 'test_option_tag',
              onTap: () {},
            ),
          ],
        ),
      ),
    );

    // Build the widget
    await tester.pumpWidget(testApp);

    // Tap to open the speed dial
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Verify that the close icon is shown and the option is visible
    expect(find.byIcon(Icons.close), findsOneWidget);
    expect(find.text('Test Option'), findsOneWidget);
  });

  testWidgets('EnhancedSpeedDial supports different directions',
      (WidgetTester tester) async {
    // Test down direction
    final testAppDown = MaterialApp(
      home: Scaffold(
        floatingActionButton: EnhancedSpeedDial(
          mainIcon: Icons.add,
          direction: SpeedDialDirection.down,
          options: [
            SpeedDialOption(
              label: 'Down Option',
              icon: Icons.arrow_downward,
              color: Colors.green,
              heroTag: 'down_tag',
              onTap: () {},
            ),
          ],
        ),
      ),
    );

    await tester.pumpWidget(testAppDown);
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.text('Down Option'), findsOneWidget);
  });

  testWidgets('EnhancedSpeedDial supports all corner positions',
      (WidgetTester tester) async {
    // Test each corner position
    for (final corner in SpeedDialCorner.values) {
      final testApp = MaterialApp(
        home: Scaffold(
          body: EnhancedSpeedDial(
            mainIcon: Icons.add,
            corner: corner,
            applySafeArea: true,
            heroTag: 'test_${corner.name}', // Unique hero tag
            options: [
              SpeedDialOption(
                label: '${corner.name.toUpperCase()} Option',
                icon: Icons.star,
                color: Colors.blue,
                heroTag: '${corner.name}_option_tag',
                onTap: () {},
              ),
            ],
          ),
        ),
      );

      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Find the main FAB by icon since it's unique in this test
      final mainFabFinder = find.byIcon(Icons.add);
      expect(mainFabFinder, findsOneWidget);

      // Tap to open
      await tester.tap(mainFabFinder);
      await tester.pumpAndSettle();

      // Verify option is visible
      expect(find.text('${corner.name.toUpperCase()} Option'), findsOneWidget);

      // Tap close icon to close (speed dial shows close icon when open)
      final closeFabFinder = find.byIcon(Icons.close);
      await tester.tap(closeFabFinder);
      await tester.pumpAndSettle();
    }
  });

  testWidgets('EnhancedSpeedDial supports all expansion directions',
      (WidgetTester tester) async {
    // Test each direction
    for (final direction in SpeedDialDirection.values) {
      final testApp = MaterialApp(
        home: Scaffold(
          body: EnhancedSpeedDial(
            mainIcon: Icons.add,
            direction: direction,
            applySafeArea: true,
            heroTag: 'test_${direction.name}', // Unique hero tag
            options: [
              SpeedDialOption(
                label: '${direction.name.toUpperCase()} Option',
                icon: Icons.arrow_forward,
                color: Colors.red,
                heroTag: '${direction.name}_option_tag',
                onTap: () {},
              ),
            ],
          ),
        ),
      );

      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Find the main FAB by icon since it's unique in this test
      final mainFabFinder = find.byIcon(Icons.add);
      expect(mainFabFinder, findsOneWidget);

      // Tap to open
      await tester.tap(mainFabFinder);
      await tester.pumpAndSettle();

      // Verify option is visible
      expect(
          find.text('${direction.name.toUpperCase()} Option'), findsOneWidget);

      // Tap close icon to close (speed dial shows close icon when open)
      final closeFabFinder = find.byIcon(Icons.close);
      await tester.tap(closeFabFinder);
      await tester.pumpAndSettle();
    }
  });

  testWidgets('EnhancedSpeedDial.simple constructor works',
      (WidgetTester tester) async {
    final testApp = MaterialApp(
      home: Scaffold(
        floatingActionButton: EnhancedSpeedDial.simple(
          mainIcon: Icons.menu,
          options: [
            SpeedDialOption.simple(
              label: 'Simple Option',
              icon: Icons.star,
              onTap: () {},
            ),
          ],
        ),
      ),
    );

    await tester.pumpWidget(testApp);
    await tester.pumpAndSettle();

    // Tap to open
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Verify simple option is visible
    expect(find.text('Simple Option'), findsOneWidget);
    expect(find.byIcon(Icons.star), findsOneWidget);
  });

  testWidgets('EnhancedSpeedDial supports custom animations',
      (WidgetTester tester) async {
    final testApp = MaterialApp(
      home: Scaffold(
        floatingActionButton: EnhancedSpeedDial(
          mainIcon: Icons.add,
          animationDuration: const Duration(milliseconds: 100),
          animationCurve: Curves.bounceIn,
          rotationAngle: 1.5708, // 90 degrees
          options: [
            SpeedDialOption(
              label: 'Animated',
              icon: Icons.animation,
              color: Colors.cyan,
              heroTag: 'animated_tag',
              onTap: () {},
            ),
          ],
        ),
      ),
    );

    await tester.pumpWidget(testApp);
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.text('Animated'), findsOneWidget);
  });
}
