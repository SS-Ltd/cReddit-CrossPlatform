import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/common/ImageButton.dart';
import 'package:reddit_clone/theme/palette.dart';

void main() {
  testWidgets('ImageButton renders correctly', (WidgetTester tester) async {
    // Build our widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ImageButton(
            text: 'Test Button',
            onPressed: () {},
            iconPath: 'assets/svgs/reddit_icon.svg',
          ),
        ),
      ),
    );
    await tester.pump(); // Wait for any animations or async tasks to complete

    // Verify that the text is rendered
    expect(find.text('Test Button'), findsOneWidget);

    // Verify that the icon is rendered
    expect(find.byType(SvgPicture), findsOneWidget);

  });
}
