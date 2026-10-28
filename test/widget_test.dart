// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:uts_dart/main.dart';
import 'package:uts_dart/pages/order.dart';

void main() {
  testWidgets('shows onboarding content and actions', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('All your favorites'), findsOneWidget);
    expect(find.textContaining('Get all your loved foods'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'NEXT'), findsOneWidget);
    expect(find.widgetWithText(TextButton, 'Skip'), findsOneWidget);
  });

  testWidgets('NEXT opens the order page', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.widgetWithText(ElevatedButton, 'NEXT'));
    await tester.pumpAndSettle();

    expect(find.text('My Orders'), findsOneWidget);
  });

  testWidgets('Skip opens the order page', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.widgetWithText(TextButton, 'Skip'));
    await tester.pumpAndSettle();

    expect(find.text('My Orders'), findsOneWidget);
  });

  testWidgets('shows the two requested orders with local images', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: OrderPage()));

    expect(find.text('Chicken Thai Biriyani'), findsOneWidget);
    expect(find.text('Beef Burger with Fries'), findsOneWidget);
    expect(find.text('Creamy Pasta Carbonara'), findsNothing);
    expect(find.text('Berry Pancake Special'), findsNothing);
    expect(find.byType(Image), findsNWidgets(2));
  });

  testWidgets('Done updates an order status', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: OrderPage()));

    await tester.tap(find.widgetWithText(ElevatedButton, 'Done').first);
    await tester.pumpAndSettle();

    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.text('Done'), findsNWidgets(2));
  });

  testWidgets('Cancel updates an order status', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: OrderPage()));

    await tester.tap(find.widgetWithText(OutlinedButton, 'Cancel').first);
    await tester.pumpAndSettle();

    expect(find.text('Cancelled'), findsOneWidget);
    expect(find.byType(OutlinedButton), findsOneWidget);
  });

  testWidgets('order list fits a narrow phone screen', (tester) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: OrderPage()));

    expect(tester.takeException(), isNull);
  });
}
