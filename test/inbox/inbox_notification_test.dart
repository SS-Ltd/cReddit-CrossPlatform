import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/MockNetworkService.dart';
import 'package:reddit_clone/common/CustomLoadingIndicator.dart';
import 'package:reddit_clone/features/Inbox/inbox_notifications.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:reddit_clone/utils/utils_time.dart';

void main() {
  testWidgets('inbox notifications', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: const MaterialApp(
          home: InboxNotificationPage(),
        ),
      ),
    );

    // Verify that a loading indicator is shown initially
    expect(find.byType(CustomLoadingIndicator), findsOneWidget);
    // Pump to settle the asynchronous operations
    await tester.pumpAndSettle();

// // Now you can add assertions for the Messages data
     //expect(find.text('u/from0 • ${formatTimestamp(DateTime.now())}'), findsOneWidget);
//     expect(find.text('subject0'), findsOneWidget);
//     expect(find.text('text0'), findsOneWidget);

//      expect(find.text('user1'), findsOneWidget);
//   expect(find.text('notificationFrom1'), findsOneWidget);
//   expect(find.text('type1'), findsOneWidget);
//   expect(find.text('resourceId1'), findsOneWidget);
//   expect(find.text('title1'), findsOneWidget);
//   expect(find.text('content1'), findsOneWidget);
//   expect(find.byIcon(Icons.done), findsNWidgets(5)); // Assuming Icons.done is used for read notifications
//   expect(find.byType(Image), findsOneWidget); // Assuming Image widget is used for profilePic
  });
}

