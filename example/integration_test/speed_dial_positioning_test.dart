import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:enhanced_speed_dial_example/main.dart' as app;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Enhanced Speed Dial Positioning Tests', () {
    testWidgets('FAB position should remain consistent when opening/closing',
        (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Find the main FAB
      final fabFinder = find.byType(FloatingActionButton).first;
      expect(fabFinder, findsOneWidget);

      // Get initial position
      final RenderBox initialRenderBox =
          tester.renderObject(fabFinder) as RenderBox;
      final Offset initialPosition =
          initialRenderBox.localToGlobal(Offset.zero);
      final Size initialSize = initialRenderBox.size;

      print('Initial FAB position: $initialPosition');
      print('Initial FAB size: $initialSize');

      // Take screenshot before opening
      await binding.convertFlutterSurfaceToImage();
      await tester.binding.delayed(const Duration(milliseconds: 100));

      // Tap to open the speed dial
      await tester.tap(fabFinder);
      await tester.pumpAndSettle();

      // Wait a bit for animations to complete
      await tester.binding.delayed(const Duration(milliseconds: 500));

      // Find the main FAB again (it might be in overlay now)
      final openFabFinder = find.byType(FloatingActionButton).first;
      expect(openFabFinder, findsOneWidget);

      // Get position after opening
      final RenderBox openRenderBox =
          tester.renderObject(openFabFinder) as RenderBox;
      final Offset openPosition = openRenderBox.localToGlobal(Offset.zero);
      final Size openSize = openRenderBox.size;

      print('Open FAB position: $openPosition');
      print('Open FAB size: $openSize');

      // Take screenshot after opening
      await binding.convertFlutterSurfaceToImage();
      await tester.binding.delayed(const Duration(milliseconds: 100));

      // Check if positions are the same
      final double positionTolerance = 1.0; // Allow 1px tolerance
      final bool positionsMatch =
          (initialPosition.dx - openPosition.dx).abs() <= positionTolerance &&
              (initialPosition.dy - openPosition.dy).abs() <= positionTolerance;

      print(
          'Position difference: dx=${initialPosition.dx - openPosition.dx}, dy=${initialPosition.dy - openPosition.dy}');

      if (!positionsMatch) {
        print('❌ POSITION MISMATCH DETECTED!');
        print('Expected position: $initialPosition');
        print('Actual position: $openPosition');
        print(
            'Difference: dx=${initialPosition.dx - openPosition.dx}, dy=${initialPosition.dy - openPosition.dy}');
      } else {
        print('✅ Position is consistent');
      }

      // Also check that options are visible
      expect(find.text('Create'), findsOneWidget);
      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('Share'), findsOneWidget);

      // Close the speed dial
      await tester.tap(openFabFinder);
      await tester.pumpAndSettle();

      // Wait for closing animation
      await tester.binding.delayed(const Duration(milliseconds: 500));

      // Get final position
      final closedFabFinder = find.byType(FloatingActionButton).first;
      final RenderBox closedRenderBox =
          tester.renderObject(closedFabFinder) as RenderBox;
      final Offset closedPosition = closedRenderBox.localToGlobal(Offset.zero);

      print('Closed FAB position: $closedPosition');

      // Take final screenshot
      await binding.convertFlutterSurfaceToImage();

      // Verify final position matches initial position
      final bool finalPositionsMatch =
          (initialPosition.dx - closedPosition.dx).abs() <= positionTolerance &&
              (initialPosition.dy - closedPosition.dy).abs() <=
                  positionTolerance;

      if (!finalPositionsMatch) {
        print('❌ FINAL POSITION MISMATCH!');
        print('Initial position: $initialPosition');
        print('Final position: $closedPosition');
        print(
            'Difference: dx=${initialPosition.dx - closedPosition.dx}, dy=${initialPosition.dy - closedPosition.dy}');
      } else {
        print('✅ Final position matches initial position');
      }

      // The test should pass if positions are consistent
      expect(positionsMatch, true,
          reason: 'FAB position should not change when opening speed dial. '
              'Initial: $initialPosition, Open: $openPosition');
      expect(finalPositionsMatch, true,
          reason: 'FAB position should return to original when closing. '
              'Initial: $initialPosition, Final: $closedPosition');
    });

    testWidgets('Test FAB position in different screen orientations',
        (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Test in portrait
      await tester.binding.setSurfaceSize(Size(400, 800));
      await tester.pumpAndSettle();

      final fabFinder = find.byType(FloatingActionButton).first;
      final portraitRenderBox = tester.renderObject(fabFinder) as RenderBox;
      final portraitPosition = portraitRenderBox.localToGlobal(Offset.zero);

      print('Portrait FAB position: $portraitPosition');

      // Open speed dial in portrait
      await tester.tap(fabFinder);
      await tester.pumpAndSettle();

      final openPortraitFinder = find.byType(FloatingActionButton).first;
      final openPortraitRenderBox =
          tester.renderObject(openPortraitFinder) as RenderBox;
      final openPortraitPosition =
          openPortraitRenderBox.localToGlobal(Offset.zero);

      print('Open portrait FAB position: $openPortraitPosition');

      // Check consistency in portrait
      final portraitConsistent =
          (portraitPosition.dx - openPortraitPosition.dx).abs() <= 1.0 &&
              (portraitPosition.dy - openPortraitPosition.dy).abs() <= 1.0;

      print('Portrait position consistent: $portraitConsistent');

      // Close speed dial
      await tester.tap(openPortraitFinder);
      await tester.pumpAndSettle();

      // Test in landscape
      await tester.binding.setSurfaceSize(Size(800, 400));
      await tester.pumpAndSettle();

      final landscapeRenderBox = tester.renderObject(fabFinder) as RenderBox;
      final landscapePosition = landscapeRenderBox.localToGlobal(Offset.zero);

      print('Landscape FAB position: $landscapePosition');

      // Open speed dial in landscape
      await tester.tap(fabFinder);
      await tester.pumpAndSettle();

      final openLandscapeFinder = find.byType(FloatingActionButton).first;
      final openLandscapeRenderBox =
          tester.renderObject(openLandscapeFinder) as RenderBox;
      final openLandscapePosition =
          openLandscapeRenderBox.localToGlobal(Offset.zero);

      print('Open landscape FAB position: $openLandscapePosition');

      // Check consistency in landscape
      final landscapeConsistent =
          (landscapePosition.dx - openLandscapePosition.dx).abs() <= 1.0 &&
              (landscapePosition.dy - openLandscapePosition.dy).abs() <= 1.0;

      print('Landscape position consistent: $landscapeConsistent');

      expect(portraitConsistent, true,
          reason: 'Portrait positioning should be consistent');
      expect(landscapeConsistent, true,
          reason: 'Landscape positioning should be consistent');
    });
  });
}
