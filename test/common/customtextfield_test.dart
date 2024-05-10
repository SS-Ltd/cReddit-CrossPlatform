import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:reddit_clone/common/CustomTextField.dart';

void main() {
  final TextEditingController controller = TextEditingController();
  final ValueNotifier<int> isValidNotifier = ValueNotifier<int>(0);

  Widget makeTestableWidget({required Widget child}) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }

  testWidgets('CustomTextField renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget(
      child: CustomTextField(
        controller: controller,
        isValidNotifier: isValidNotifier,
        labelText: 'Test',
        invalidText: 'Invalid input',
      ),
    ));

    expect(find.byType(CustomTextField), findsOneWidget);
  });

  testWidgets('CustomTextField updates text and validation status', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget(
      child: CustomTextField(
        controller: controller,
        isValidNotifier: isValidNotifier,
        labelText: 'Test',
        invalidText: 'Invalid input',
      ),
    ));

    await tester.enterText(find.byType(TextFormField), 'test input');
    await tester.pump();

    expect(controller.text, equals('test input'));

    expect(isValidNotifier.value, equals(-1));
  });

  testWidgets('CustomTextField clears text and resets validation status when clear button is pressed', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget(
      child: CustomTextField(
        controller: controller,
        isValidNotifier: isValidNotifier,
        labelText: 'Test',
        invalidText: 'Invalid input',
      ),
    ));
  
    await tester.enterText(find.byType(TextFormField), 'test input');
    await tester.pump();
  
    await tester.tap(find.byIcon(Icons.clear));
    await tester.pump();
  
    expect(controller.text, equals(''));
  
    expect(isValidNotifier.value, equals(0));
  });
}