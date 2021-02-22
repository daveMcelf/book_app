// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:book_app/app/helper/star_rating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget _wrapWithMaterialApp(Widget testWidget) {
    return MaterialApp(
      home: Scaffold(body: testWidget),
    );
  }

  testWidgets('when star is 0', (WidgetTester tester) async {
    // Test code goes here.
    await tester.pumpWidget(_wrapWithMaterialApp(StarRatingWidget(
      star: 0,
    )));

    final emptyStarFinder = find.byIcon(Icons.star_border);
    final starFinder = find.byIcon(Icons.star);

    expect(emptyStarFinder, findsNWidgets(5));
    expect(starFinder, findsNWidgets(0));
  });

  testWidgets('when star is in range 1-5', (WidgetTester tester) async {
    // Test code goes here.
    await tester.pumpWidget(_wrapWithMaterialApp(StarRatingWidget(
      star: 3,
    )));

    final emptyStarFinder = find.byIcon(Icons.star_border);
    final starFinder = find.byIcon(Icons.star);

    expect(emptyStarFinder, findsNWidgets(2));
    expect(starFinder, findsNWidgets(3));
  });

  testWidgets('when star less than 0, star should be 0',
      (WidgetTester tester) async {
    // Test code goes here.
    await tester.pumpWidget(_wrapWithMaterialApp(StarRatingWidget(
      star: -1,
    )));

    final emptyStarFinder = find.byIcon(Icons.star_border);
    final starFinder = find.byIcon(Icons.star);

    expect(emptyStarFinder, findsNWidgets(5));
    expect(starFinder, findsNWidgets(0));
  });

  testWidgets('when star larger than 5, star should display 5',
      (WidgetTester tester) async {
    // Test code goes here.
    await tester.pumpWidget(_wrapWithMaterialApp(StarRatingWidget(
      star: 10,
    )));

    final emptyStarFinder = find.byIcon(Icons.star_border);
    final starFinder = find.byIcon(Icons.star);

    expect(emptyStarFinder, findsNWidgets(0));
    expect(starFinder, findsNWidgets(5));
  });
}
