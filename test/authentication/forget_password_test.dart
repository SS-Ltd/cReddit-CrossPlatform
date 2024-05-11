import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/MockNetworkService.dart';
import 'package:reddit_clone/common/CustomTextField.dart';
import 'package:reddit_clone/features/Authentication/forget_password.dart';
import 'package:reddit_clone/services/networkServices.dart';

void main() {
  testWidgets('ForgetPassword Widget Test', (WidgetTester tester) async {
    // Build the ResetPasswordDone widget
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: const MaterialApp(
          home: ForgetPassword(),
        ),
      ),
    );

    // Verify that the ForgetPassword widget is displayed
    expect(find.text('Reset your Password'), findsOneWidget);
    expect(find.text('Enter your email address or username and we\'ll send you a link to reset your password'), findsOneWidget);
    expect(find.byType(CustomTextField), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);

    // Tap the ElevatedButton
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify that the AppBar is displayed with the correct widgets
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(IconButton), findsOneWidget);
    expect(find.byType(SvgPicture), findsOneWidget);
    expect(find.byType(RichText), findsAny);

    // Tap the IconButton to test the back navigation
    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    // Verify that the back navigation works
    expect(find.byType(ForgetPassword), findsNothing);

  });
}