import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:enhanced_speed_dial/enhanced_speed_dial.dart';

void main() {
  group('Enhanced Speed Dial Position Tests', () {
    testWidgets('FAB position consistency test', (WidgetTester tester) async {
      // Create a test app with the speed dial as floatingActionButton
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const Center(child: Text('Test App')),
            floatingActionButton: EnhancedSpeedDial.simple(
              mainIcon: Icons.menu,
              applySafeArea: false, // Important for Scaffold usage
              options: [
                SpeedDialOption.simple(
                  label: 'Create',
                  icon: Icons.add,
                  onTap: () => print('Create tapped'),
                ),
                SpeedDialOption.simple(
                  label: 'Edit',
                  icon: Icons.edit,
                  onTap: () => print('Edit tapped'),
                ),
                SpeedDialOption.simple(
                  label: 'Share',
                  icon: Icons.share,
                  onTap: () => print('Share tapped'),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the main FAB
      final mainFabFinder = find.byType(FloatingActionButton).first;
      expect(mainFabFinder, findsOneWidget);

      // Get initial position and size
      final RenderBox initialRenderBox =
          tester.renderObject(mainFabFinder) as RenderBox;
      final Offset initialPosition =
          initialRenderBox.localToGlobal(Offset.zero);
      final Size initialSize = initialRenderBox.size;

      print('=== INITIAL STATE ===');
      print('FAB position: $initialPosition');
      print('FAB size: $initialSize');
      print(
          'FAB center: ${initialPosition + Offset(initialSize.width / 2, initialSize.height / 2)}');

      // Tap to open the speed dial
      await tester.tap(mainFabFinder);
      await tester.pumpAndSettle();

      // Wait for animations
      await tester.pump(const Duration(milliseconds: 300));

      print('=== OPENED STATE ===');

      // Try to find the FAB in the opened state
      // It might be in the overlay or still in the original position
      final allFabs = find.byType(FloatingActionButton);
      final fabCount = tester.widgetList(allFabs).length;
      print('Number of FABs found: $fabCount');

      // Find the main FAB (should be the close button now)
      FloatingActionButton? mainFab;
      RenderBox? openRenderBox;
      Offset? openPosition;

      for (int i = 0; i < fabCount; i++) {
        final fabFinder = find.byType(FloatingActionButton).at(i);
        final fab = tester.widget<FloatingActionButton>(fabFinder);
        final renderBox = tester.renderObject(fabFinder) as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);
        final size = renderBox.size;

        print('FAB $i: position=$position, size=$size, heroTag=${fab.heroTag}');

        // The main FAB should have the close icon or be the largest
        if (fab.heroTag?.toString().contains('main') == true ||
            (size.width >= 56.0 && mainFab == null)) {
          mainFab = fab;
          openRenderBox = renderBox;
          openPosition = position;
        }
      }

      expect(mainFab, isNotNull,
          reason: 'Should find the main FAB in open state');
      expect(openRenderBox, isNotNull);
      expect(openPosition, isNotNull);

      print('Main FAB in open state:');
      print('Position: $openPosition');
      print('Size: ${openRenderBox!.size}');
      print(
          'Center: ${openPosition! + Offset(openRenderBox.size.width / 2, openRenderBox.size.height / 2)}');

      // Check that options are visible
      expect(find.text('Create'), findsOneWidget);
      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('Share'), findsOneWidget);

      // Calculate position difference
      final positionDiff = initialPosition - openPosition;
      print('Position difference: $positionDiff');
      print('Distance moved: ${positionDiff.distance}');

      // Allow small tolerance for floating point precision
      const tolerance = 2.0;
      final isPositionConsistent = positionDiff.distance <= tolerance;

      if (!isPositionConsistent) {
        print('❌ POSITION INCONSISTENCY DETECTED!');
        print('Expected position: $initialPosition');
        print('Actual position: $openPosition');
        print('Difference: $positionDiff');
        print('Distance: ${positionDiff.distance}');
      } else {
        print('✅ Position is consistent (within $tolerance px tolerance)');
      }

      // Close the speed dial
      final closeFabFinder = find.byIcon(Icons.close).first;
      await tester.tap(closeFabFinder);
      await tester.pumpAndSettle();

      // Wait for closing animation
      await tester.pump(const Duration(milliseconds: 300));

      print('=== CLOSED STATE ===');

      // Check final position
      final finalFabFinder = find.byType(FloatingActionButton).first;
      final RenderBox finalRenderBox =
          tester.renderObject(finalFabFinder) as RenderBox;
      final Offset finalPosition = finalRenderBox.localToGlobal(Offset.zero);

      print('Final FAB position: $finalPosition');

      final finalDiff = initialPosition - finalPosition;
      print('Final difference from initial: $finalDiff');
      print('Final distance: ${finalDiff.distance}');

      final isFinalConsistent = finalDiff.distance <= tolerance;

      // Assertions
      expect(isPositionConsistent, true,
          reason: 'FAB should maintain position when opening. '
              'Moved by ${positionDiff.distance} pixels');

      expect(isFinalConsistent, true,
          reason: 'FAB should return to original position when closing. '
              'Final difference: ${finalDiff.distance} pixels');
    });

    testWidgets('Test position calculation methods',
        (WidgetTester tester) async {
      // Test with applySafeArea = true
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EnhancedSpeedDial.simple(
              mainIcon: Icons.menu,
              applySafeArea: true, // SafeArea enabled
              options: [
                SpeedDialOption.simple(
                  label: 'Test',
                  icon: Icons.add,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final fabFinder = find.byType(FloatingActionButton).first;
      final renderBox = tester.renderObject(fabFinder) as RenderBox;
      final position1 = renderBox.localToGlobal(Offset.zero);

      print('=== applySafeArea: true ===');
      print('Position: $position1');

      // Test with applySafeArea = false (floatingActionButton style)
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const Center(child: Text('Test')),
            floatingActionButton: EnhancedSpeedDial.simple(
              mainIcon: Icons.menu,
              applySafeArea: false, // Disabled for Scaffold usage
              options: [
                SpeedDialOption.simple(
                  label: 'Test',
                  icon: Icons.add,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final fabFinder2 = find.byType(FloatingActionButton).first;
      final renderBox2 = tester.renderObject(fabFinder2) as RenderBox;
      final position2 = renderBox2.localToGlobal(Offset.zero);

      print('=== applySafeArea: false ===');
      print('Position: $position2');

      final diff = position1 - position2;
      print('Difference between modes: $diff');
    });
  });
}
