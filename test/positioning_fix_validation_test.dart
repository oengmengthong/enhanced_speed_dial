import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:enhanced_speed_dial/enhanced_speed_dial.dart';

void main() {
  group('Position Fix Validation Tests', () {
    testWidgets('Small screen boundary validation works',
        (WidgetTester tester) async {
      // Test with a very small screen
      const testScreenSize = Size(200, 300);
      await tester.binding.setSurfaceSize(testScreenSize);

      final testApp = MaterialApp(
        home: Scaffold(
          body: EnhancedSpeedDial(
            mainIcon: Icons.add,
            corner: SpeedDialCorner.bottomRight,
            direction: SpeedDialDirection.up,
            applySafeArea: true,
            offsetFromEdge: 50.0, // Intentionally large offset
            options: [
              SpeedDialOption(
                label: 'Test Option',
                icon: Icons.star,
                color: Colors.blue,
                heroTag: 'test_option',
                onTap: () {},
              ),
            ],
          ),
        ),
      );

      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Verify FAB is created and positioned within screen bounds
      final mainFab = find.byIcon(Icons.add);
      expect(mainFab, findsOneWidget);

      // Get position
      final renderBox = tester.renderObject(mainFab) as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);
      final size = renderBox.size;

      print('Screen size: $testScreenSize');
      print('FAB position: $position');
      print('FAB size: $size');

      // Verify position is within screen bounds (accounting for positioning logic)
      expect(position.dx >= 0, true,
          reason: 'FAB should not be positioned left of screen');
      expect(position.dy >= 0, true,
          reason: 'FAB should not be positioned above screen');
      expect(position.dx + size.width <= testScreenSize.width, true,
          reason: 'FAB should not extend past right edge');
      expect(position.dy + size.height <= testScreenSize.height, true,
          reason: 'FAB should not extend past bottom edge');

      // Try to open and verify it doesn't crash
      await tester.tap(mainFab);
      await tester.pumpAndSettle();

      // Options should be created without crash
      expect(find.text('Test Option'), findsOneWidget);

      print('✅ Small screen boundary validation passed');
    });

    testWidgets('Multiple speed dials with unique hero tags work',
        (WidgetTester tester) async {
      // Simple test that just verifies hero tag uniqueness without complex positioning

      final testApp = MaterialApp(
        home: Scaffold(
          floatingActionButton: EnhancedSpeedDial(
            mainIcon: Icons.add,
            applySafeArea: false, // Use as scaffold FAB
            options: [
              SpeedDialOption(
                label: 'Option 1A',
                icon: Icons.star,
                color: Colors.blue,
                onTap: () {},
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: EnhancedSpeedDial(
              mainIcon: Icons.menu,
              corner: SpeedDialCorner.topLeft,
              direction: SpeedDialDirection.right,
              applySafeArea: true,
              options: [
                SpeedDialOption(
                  label: 'Option 2A',
                  icon: Icons.favorite,
                  color: Colors.red,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Both FABs should be present without hero tag conflicts
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.menu), findsOneWidget);

      print('✅ Multiple speed dials with unique hero tags work');
    });
    testWidgets('Smart direction adjustment prevents off-screen options',
        (WidgetTester tester) async {
      const testScreenSize = Size(400, 600);
      await tester.binding.setSurfaceSize(testScreenSize);

      // Test corner that would normally expand off-screen
      final testApp = MaterialApp(
        home: Scaffold(
          body: EnhancedSpeedDial(
            mainIcon: Icons.add,
            corner: SpeedDialCorner.topLeft,
            direction: SpeedDialDirection.up, // This should auto-adjust to down
            applySafeArea: true,
            options: [
              SpeedDialOption(
                label: 'Option 1',
                icon: Icons.star,
                color: Colors.blue,
                heroTag: 'smart_option_1',
                onTap: () {},
              ),
              SpeedDialOption(
                label: 'Option 2',
                icon: Icons.favorite,
                color: Colors.red,
                heroTag: 'smart_option_2',
                onTap: () {},
              ),
            ],
          ),
        ),
      );

      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Open the speed dial
      final mainFab = find.byIcon(Icons.add);
      await tester.tap(mainFab);
      await tester.pumpAndSettle();

      // Options should be visible (smart adjustment should prevent off-screen positioning)
      expect(find.text('Option 1'), findsOneWidget);
      expect(find.text('Option 2'), findsOneWidget);

      // Get positions to verify they're on screen
      final option1Finder = find.text('Option 1');
      final option1RenderBox = tester.renderObject(option1Finder) as RenderBox;
      final option1Position = option1RenderBox.localToGlobal(Offset.zero);

      print('Option 1 position: $option1Position');
      print('Screen size: $testScreenSize');

      // Should be positioned downward from FAB due to smart adjustment
      expect(option1Position.dy > 50, true,
          reason:
              'Options should be positioned downward due to smart adjustment');

      print('✅ Smart direction adjustment working');
    });
  });
}
