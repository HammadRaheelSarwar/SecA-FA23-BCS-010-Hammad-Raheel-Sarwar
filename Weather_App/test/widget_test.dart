// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:weather_app/main.dart';

void main() {
  testWidgets('WeatherApp shows app bar title', (WidgetTester tester) async {
    // Build the app and wait for frames to settle.
    await tester.pumpWidget(const WeatherApp());
    await tester.pumpAndSettle();

    // Verify the app bar title is present.
    expect(find.text('Weather'), findsOneWidget);
  });
}
