import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:reddit_clone/features/User/edit_button.dart';
import 'package:reddit_clone/features/User/profile_settings.dart';

void main() {
  // Helper function to create a testable widget
  Widget createTestableWidget(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  testWidgets('EditButton displays with correct text and style',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget(EditButton(
      userName: 'user123',
      profilePictureUrl: 'https://example.com/profile.jpg',
      bannerUrl: 'https://example.com/banner.jpg',
      displayName: 'John Doe',
      about: 'Sample bio',
    )));

    // Verify the button's text and style
    final elevatedButton = find.byType(ElevatedButton);
    expect(elevatedButton, findsOneWidget);
    expect(find.text('Edit'), findsOneWidget);
    expect(
        (tester.firstWidget(elevatedButton) as ElevatedButton)
            .style!
            .backgroundColor!
            .resolve({}),
        Colors.transparent);
    expect(
        (tester.firstWidget(elevatedButton) as ElevatedButton)
            .style!
            .shape!
            .resolve({}),
        isA<RoundedRectangleBorder>());
  });

  testWidgets('Pressing EditButton navigates to ProfileSettings',
      (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget(const EditButton(
      userName: 'user123',
      profilePictureUrl: 'assets/hehe.png',
      bannerUrl: 'assets/hehe.png',
      displayName: 'John Doe',
      about: 'Sample bio',
    )));

    // Tap the Edit button
    await tester.tap(find.byType(ElevatedButton));
    await tester
        .pumpAndSettle(); // Finish the animations and scheduled microtasks

    // Verify that the ProfileSettings page was pushed
    expect(find.byType(ProfileSettings), findsOneWidget);

    // Additionally, check if the passed parameters are correct
    final profileSettingsWidget =
        tester.widget<ProfileSettings>(find.byType(ProfileSettings));
    expect(profileSettingsWidget.userName, 'user123');
    expect(profileSettingsWidget.profilePictureUrl, 'assets/hehe.png');
    expect(profileSettingsWidget.bannerUrl, 'assets/hehe.png');
    expect(profileSettingsWidget.displayName, 'John Doe');
    expect(profileSettingsWidget.about, 'Sample bio');
  });
}
