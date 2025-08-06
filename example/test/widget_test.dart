// This is a basic Flutter widget test for the Enhanced Speed Dial package.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:enhanced_speed_dial_example/main.dart';

void main() {
  testWidgets('Enhanced Speed Dial displays correctly',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our app displays the main text
    expect(find.text('Tap the floating action button to see the speed dial!'),
        findsOneWidget);
    expect(find.text('Last action: No action yet'), findsOneWidget);

    // Verify that the floating action button is present
    expect(find.byType(FloatingActionButton), findsOneWidget);

    // Verify the initial icon is displayed
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('Speed dial can be opened and closed',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Find the main floating action button by its tooltip
    final mainFab = find.byTooltip('Open speed dial');
    expect(mainFab, findsOneWidget);

    // Tap the main floating action button to open speed dial
    await tester.tap(mainFab);
    await tester.pumpAndSettle();

    // After opening, the icon should change to close icon and speed dial options should appear
    expect(find.byIcon(Icons.close), findsOneWidget);
    expect(find.byIcon(Icons.add), findsNothing);

    // Check that speed dial options are visible
    expect(find.text('Create Note'), findsOneWidget);
    expect(find.text('Add Photo'), findsOneWidget);
    expect(find.text('Record Audio'), findsOneWidget);
    expect(find.text('Share'), findsOneWidget);

    // Tap again to close speed dial
    await tester.tap(mainFab);
    await tester.pumpAndSettle();

    // After closing, the icon should change back to add icon and options should be hidden
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.byIcon(Icons.close), findsNothing);

    // Speed dial options should no longer be visible
    expect(find.text('Create Note'), findsNothing);
    expect(find.text('Add Photo'), findsNothing);
    expect(find.text('Record Audio'), findsNothing);
    expect(find.text('Share'), findsNothing);
  });

  testWidgets('Speed dial option can be tapped', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Find the main floating action button by its tooltip
    final mainFab = find.byTooltip('Open speed dial');

    // Open the speed dial
    await tester.tap(mainFab);
    await tester.pumpAndSettle();

    // Tap on the "Create Note" option by finding its floating action button
    final createNoteFab = find.byTooltip('Create a new note');
    expect(createNoteFab, findsOneWidget);
    await tester.tap(createNoteFab);
    await tester.pumpAndSettle();

    // Verify that the action was registered
    expect(find.text('Last action: Create Note tapped'), findsOneWidget);
  });
}
