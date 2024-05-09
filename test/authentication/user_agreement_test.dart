import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:reddit_clone/features/Authentication/widgets/user_agreement.dart';

void main() {
  testWidgets('AgreementText Widget Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: AgreementText()));

    // Verify that the text is displayed.
    expect(
      find.byWidgetPredicate(
        (Widget widget) =>
            widget is RichText &&
            widget.text.toPlainText().contains('User Agreement '),
      ),
      findsOneWidget,
    );

    // Verify that the links are clickable.
  });
}
