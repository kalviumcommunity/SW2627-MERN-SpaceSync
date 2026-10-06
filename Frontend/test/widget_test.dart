// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/app.dart';

void main() {
  testWidgets('dashboard shows overview and key sections', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CoWorkHubApp());

    expect(find.text('CoWorkHub'), findsOneWidget);
    expect(find.text('Good morning, Admin 👋'), findsOneWidget);
    expect(find.text('Live Occupancy'), findsOneWidget);
    expect(find.text('Peak Hours'), findsOneWidget);
    expect(find.text('Location Overview'), findsOneWidget);
    expect(find.text('Active Alerts'), findsOneWidget);
    expect(find.text('128'), findsOneWidget);
  });

  testWidgets('spaces navigation shows location-specific availability', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CoWorkHubApp());

    await tester.tap(find.text('Spaces').last);
    await tester.pumpAndSettle();

    expect(find.text('Manage workspace availability'), findsOneWidget);
    expect(find.text('13'), findsOneWidget);
    expect(find.text('Hot Desk #1'), findsOneWidget);

    await tester.tap(find.text('Koramangala').first);
    await tester.pumpAndSettle();
    expect(find.text('10'), findsOneWidget);
    expect(find.text('Meeting Room A'), findsOneWidget);

    await tester.tap(find.text('Hot Desk #1').first);
    await tester.pumpAndSettle();
    expect(find.text('In use by a day-pass member'), findsOneWidget);
    expect(find.text('Close'), findsOneWidget);
  });

  testWidgets('analytics and profile destinations show their content', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CoWorkHubApp());

    await tester.tap(find.text('Analytics').last);
    await tester.pumpAndSettle();
    expect(
      find.text('Track utilization and business performance'),
      findsOneWidget,
    );
    expect(find.text('Occupancy Trend'), findsOneWidget);
    expect(find.text('Bengaluru Central'), findsOneWidget);

    await tester.tap(find.text('Profile').last);
    await tester.pumpAndSettle();
    expect(find.text('Workspace Administrator'), findsOneWidget);
    expect(find.text('Personal Information'), findsOneWidget);
    expect(find.text('Log Out'), findsOneWidget);
  });

  testWidgets('appearance changes the app theme immediately', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CoWorkHubApp());
    await tester.tap(find.text('Profile').last);
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Appearance'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Appearance'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dark').first);
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.text('Workspace Administrator'))).brightness,
      Brightness.dark,
    );
    expect(find.text('Dark theme'), findsOneWidget);

    await tester.ensureVisible(find.text('Appearance'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Appearance'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('System default').first);
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.text('Workspace Administrator'))).brightness,
      Brightness.light,
    );
    tester.binding.platformDispatcher.platformBrightnessTestValue =
        Brightness.dark;
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.text('Workspace Administrator'))).brightness,
      Brightness.dark,
    );
    tester.binding.platformDispatcher.platformBrightnessTestValue =
        Brightness.light;
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Appearance'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Appearance'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Light').first);
    await tester.pumpAndSettle();
    expect(find.text('Light theme'), findsOneWidget);
  });

  testWidgets('dashboard fits a narrow phone width', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 720));
    await tester.pumpWidget(const CoWorkHubApp());
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);

    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('bookings filters and searches the local list', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CoWorkHubApp());
    await tester.tap(find.text('Bookings').last);
    await tester.pumpAndSettle();

    expect(find.text('20 bookings'), findsOneWidget);
    await tester.tap(find.text('Conflict').first);
    await tester.pumpAndSettle();
    expect(find.text('2 bookings'), findsOneWidget);
    expect(find.text('Kavya Nair'), findsOneWidget);
    expect(find.text('Ranjith Kumar'), findsOneWidget);

    await tester.tap(find.text('All').first);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'indiranagar');
    await tester.pumpAndSettle();
    expect(find.text('4 bookings'), findsOneWidget);
    expect(find.text('Sneha Iyer'), findsOneWidget);
    expect(find.text('Priya Anand'), findsNothing);
  });

  testWidgets('booking card opens a detail sheet', (WidgetTester tester) async {
    await tester.pumpWidget(const CoWorkHubApp());
    await tester.tap(find.text('Bookings').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Priya Anand'));
    await tester.pumpAndSettle();

    expect(find.text('Hot Desk #1'), findsWidgets);
    expect(find.text('Bengaluru Central'), findsWidgets);
    expect(find.byTooltip('Close booking details'), findsOneWidget);
  });
}
