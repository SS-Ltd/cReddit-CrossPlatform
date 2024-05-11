import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/MockNetworkService.dart';
import 'package:reddit_clone/features/post/edit_post.dart';
import 'package:reddit_clone/services/networkServices.dart';

void main() {
  testWidgets('EditPost interacts correctly with NetworkService',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: Builder(
          builder: (context) => MaterialApp(
            home: EditPost(
              postId: '123',
            ),
          ),
        ),
      ),
    );
    final textField = find.byType(TextField);
    expect(textField, findsOneWidget);
    await tester.enterText(textField, "xyz");
    await tester.pumpAndSettle(); // Rebuild the widget with the new text

    // Tap the 'Save' button
    final saveButton = find.text('Save');
    expect(saveButton, findsOneWidget);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();
  });
}
