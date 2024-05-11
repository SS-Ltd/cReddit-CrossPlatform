import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/features/moderator/location.dart';

void main() {
  testWidgets('Location widget test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Location()));

    expect(find.text('Location'), findsOneWidget);
    expect(find.text("Adding a location helps your community show up in search results and recommendations and helps local redditors find it easier."), findsOneWidget);
    expect(find.text('Region'), findsOneWidget);
    expect(find.text('City, state or zip code'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.byType(IconButton), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'test');
  });
}
