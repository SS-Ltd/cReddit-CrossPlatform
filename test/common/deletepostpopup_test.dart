import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/common/delete_post_pop_up.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/services/networkServices.dart';

void main() {
  testWidgets('DeletePostPopUp renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      Provider<NetworkService>(
        create: (_) => NetworkService(),
        child: const MaterialApp(
          home: Scaffold(
            body: DeletePostPopUp(postId: 'testPostId'),
          ),
        ),
      ),
    );
    await tester.pump(); // Wait for any animations or async tasks to complete

//     await tester.tap(find.byType(ElevatedButton));
// await tester.pumpAndSettle();

// // Now check for the AlertDialog
// expect(find.byType(AlertDialog), findsOneWidget);

    // Verify that the Text widgets are rendered
    expect(find.byType(Text), findsNWidgets(4));
    // Verify that the text is rendered correctly
    expect(find.text('Are you sure?'), findsOneWidget);
    expect(find.text('You cannot restore posts that have been deleted.'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);

    // Verify that the ElevatedButton widgets are rendered
    expect(find.byType(ElevatedButton), findsNWidgets(2));
  });
}