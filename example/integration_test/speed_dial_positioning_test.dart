import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:enhanced_speed_dial/enhanced_speed_dial.dart';
import 'package:enhanced_speed_dial_example/main.dart' as app;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Enhanced Speed Dial Positioning Tests', () {
    testWidgets(
        'Simple FAB position should remain consistent when opening/closing',
        (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Should start in simple mode
      expect(find.text('Simple Configuration'), findsOneWidget);

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

    testWidgets('Test advanced mode with different corner positions',
        (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Switch to advanced mode
      await tester.tap(find.text('Advanced'));
      await tester.pumpAndSettle();

      // Should now be in advanced mode
      expect(find.text('Advanced Configuration'), findsOneWidget);

      // Test different corner positions
      final corners = [
        SpeedDialCorner.bottomRight,
        SpeedDialCorner.bottomLeft,
        SpeedDialCorner.topRight,
        SpeedDialCorner.topLeft,
      ];

      for (final corner in corners) {
        print('Testing corner: ${corner.name}');

        // Find and tap the corner chip
        final cornerChip =
            find.widgetWithText(ChoiceChip, _getCornerName(corner));
        if (tester.any(cornerChip)) {
          await tester.tap(cornerChip);
          await tester.pumpAndSettle();

          // Wait for animation to complete
          await tester.binding.delayed(const Duration(milliseconds: 500));

          // Find the main FAB in its new position
          final fabFinder = find.byType(FloatingActionButton).first;
          expect(fabFinder, findsOneWidget);

          // Get the FAB position
          final RenderBox fabRenderBox =
              tester.renderObject(fabFinder) as RenderBox;
          final Offset fabPosition = fabRenderBox.localToGlobal(Offset.zero);

          print('FAB position for ${corner.name}: $fabPosition');

          // Tap to open speed dial
          await tester.tap(fabFinder);
          await tester.pumpAndSettle();

          // Wait for options to appear
          await tester.binding.delayed(const Duration(milliseconds: 500));

          // Verify options are visible
          expect(find.text('Create Note'), findsOneWidget);
          expect(find.text('Add Photo'), findsOneWidget);

          // Close speed dial
          await tester.tap(find.byType(FloatingActionButton).first);
          await tester.pumpAndSettle();

          print('✅ Corner ${corner.name} test passed');
        }
      }
    });

    testWidgets('Test expansion directions in advanced mode',
        (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Switch to advanced mode
      await tester.tap(find.text('Advanced'));
      await tester.pumpAndSettle();

      // Test different directions
      final directions = [
        SpeedDialDirection.up,
        SpeedDialDirection.down,
        SpeedDialDirection.left,
        SpeedDialDirection.right,
      ];

      for (final direction in directions) {
        print('Testing direction: ${direction.name}');

        // Find and tap the direction chip
        final directionChip =
            find.widgetWithText(ChoiceChip, _getDirectionName(direction));
        if (tester.any(directionChip)) {
          await tester.tap(directionChip);
          await tester.pumpAndSettle();

          // Wait for changes to take effect
          await tester.binding.delayed(const Duration(milliseconds: 300));

          // Find the main FAB
          final fabFinder = find.byType(FloatingActionButton).first;
          expect(fabFinder, findsOneWidget);

          // Tap to open speed dial
          await tester.tap(fabFinder);
          await tester.pumpAndSettle();

          // Wait for options to appear
          await tester.binding.delayed(const Duration(milliseconds: 500));

          // Verify options are visible
          expect(find.text('Create Note'), findsOneWidget);
          expect(find.text('Add Photo'), findsOneWidget);

          // Close speed dial
          await tester.tap(find.byType(FloatingActionButton).first);
          await tester.pumpAndSettle();

          print('✅ Direction ${direction.name} test passed');
        }
      }
    });

    testWidgets('Test FAB position in different screen orientations',
        (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Test in portrait
      await tester.binding.setSurfaceSize(const Size(400, 800));
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
      await tester.binding.setSurfaceSize(const Size(800, 400));
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

// Helper functions to match the main app
String _getCornerName(SpeedDialCorner corner) {
  switch (corner) {
    case SpeedDialCorner.topLeft:
      return 'Top Left';
    case SpeedDialCorner.topRight:
      return 'Top Right';
    case SpeedDialCorner.bottomLeft:
      return 'Bottom Left';
    case SpeedDialCorner.bottomRight:
      return 'Bottom Right';
  }
}

String _getDirectionName(SpeedDialDirection direction) {
  switch (direction) {
    case SpeedDialDirection.up:
      return 'Up';
    case SpeedDialDirection.down:
      return 'Down';
    case SpeedDialDirection.left:
      return 'Left';
    case SpeedDialDirection.right:
      return 'Right';
  }
}
