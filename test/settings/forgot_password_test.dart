// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:reddit_clone/MockNetworkService.dart';
// import 'package:reddit_clone/features/settings/forgot_password.dart';
// import 'package:reddit_clone/services/networkServices.dart';

// void main() {
//   testWidgets('Forgot Password', (WidgetTester tester) async {
//     await tester.pumpWidget(
//       ChangeNotifierProvider<NetworkService>(
//         create: (_) => MockNetworkService(),
//         child: const MaterialApp(
//           home: ForgotPassword(),
//         ),
//       ),
//     );

//     expect(find.text('Update email address'), findsOneWidget);

//     Finder newemail = find.byType(TextField).at(0);
//     expect(newemail, findsOneWidget);
//     await tester.enterText(newemail, 'usama.nn201@gmail.com');
//     expect(find.text('usama.nn201@gmail.com'), findsOneWidget);

//     Finder currentpassword = find.byType(TextField).at(0);
//     expect(currentpassword, findsOneWidget);
//     await tester.enterText(currentpassword, '12234556');
//     expect(find.text('12234556'), findsOneWidget);

//     Finder savebutton = find.byKey(const Key('SaveButton'));
//     await tester.tap(savebutton);
//     expect(find.byType(UpdateEmail), findsOneWidget);

//     // Finder forgotpassword = find.byKey(const Key('forgotpassword'));
//     // await tester.tap(forgotpassword);
//     // expect(find.byType(ForgotPassword), findsOneWidget);

//     // Finder cancelbutton = find.byKey(const Key('CancelButton'));
//     // await tester.tap(cancelbutton);
//     // expect(find.byType(AccountSettings), findsOneWidget);

//   });
// }
