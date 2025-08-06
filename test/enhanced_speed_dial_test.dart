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
