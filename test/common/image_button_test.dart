import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/common/ImageButton.dart';

void main() {
  testWidgets('ImageButton renders correctly', (WidgetTester tester) async {
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
    await tester.pump();

    expect(find.text('Test Button'), findsOneWidget);

    expect(find.byType(SvgPicture), findsOneWidget);

  });
}
