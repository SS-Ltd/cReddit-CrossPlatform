import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/features/home_page/moderator_pop_up.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:reddit_clone/MockNetworkService.dart';

void main() {
  final postModel = PostModel(
    title: 'Test Post',
    postId: 'test_post_id',
    type: 'Post',
    username: 'test_user',
    communityName: 'test_community',
    content: 'This is a test post for moderator actions',
    pollOptions: [],
    expirationDate: null,
    netVote: 0,
    isSpoiler: false,
    isLocked: false,
    isApproved: false,
    isEdited: false,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    profilePicture: '',
    commentCount: 0,
    isDeletedUser: false,
    isUpvoted: false,
    isDownvoted: false,
    isSaved: false,
    isHidden: false,
    isJoined: false,
    isModerator: true,
    isBlocked: false,
    isNSFW: false,
  );

  testWidgets('ModeratorPopUP displays correct moderation options', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: MaterialApp(
          home: ModeratorPopUP(postModel: postModel),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Ensure the dialog displays the expected moderation options
    expect(find.text('Approve post'), findsOneWidget);
    expect(find.text('Remove post'), findsOneWidget);
    expect(find.text('Remove as spam'), findsOneWidget);
    expect(find.text('Lock comments'), findsOneWidget);
    expect(find.text('Mark as spoiler'), findsOneWidget);
    expect(find.text('Mark as NSFW'), findsOneWidget);
  });

  testWidgets('Test approval action', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: MaterialApp(
          home: ModeratorPopUP(postModel: postModel),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('Approve post')); // Approve post
    await tester.pumpAndSettle();

    // Verify the approval action was successful (based on MockNetworkService)
    expect((await Provider.of<NetworkService>(tester.element(find.byType(MaterialApp)), listen: false).approvePost('test_post_id', true)), true);
  });

  testWidgets('Test removal action', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: MaterialApp(
          home: ModeratorPopUP(postModel: postModel),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('Remove post')); // Remove post
    await tester.pumpAndSettle();

    // Verify the removal action
    expect((await Provider.of<NetworkService>(tester.element(find.byType(MaterialApp)), listen: false).removePost('test_post_id', true)), true);

    // Check if the dialog is closed after removing the post
    expect(find.byType(ModeratorPopUP), findsNothing); // Dialog should close
  });

  testWidgets('Test lock comments action', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: MaterialApp(
          home: ModeratorPopUP(postModel: postModel),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('Lock comments')); // Lock comments
    await tester.pumpAndSettle();

    // Verify the lock comments action
    expect((await Provider.of<NetworkService>(tester.element(find.byType(MaterialApp)), listen: false).lockpost('test_post_id', true)), true);
  });

  testWidgets('Test mark as NSFW action', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: MaterialApp(
          home: ModeratorPopUP(postModel: postModel),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('Mark as NSFW')); // Mark as NSFW
    await tester.pumpAndSettle();

    // Verify the mark as NSFW action
    expect((await Provider.of<NetworkService>(tester.element(find.byType(MaterialApp)), listen: false).markAsNSFW('test_post_id', true)), true);
  });

  testWidgets('Test mark as spoiler action', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: MaterialApp(
          home: ModeratorPopUP(postModel: postModel),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('Mark as spoiler')); // Mark as spoiler
    await tester.pumpAndSettle();

    // Verify the mark as spoiler action
    expect((await Provider.of<NetworkService>(tester.element(find.byType(MaterialApp)), listen: false).markAsSpoiler('test_post_id', true)), true);
  });
}



// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:provider/provider.dart';
// import 'package:reddit_clone/MockNetworkService.dart';
// import 'package:reddit_clone/features/home_page/moderator_pop_up.dart';
// import 'package:reddit_clone/models/post_model.dart';
// import 'package:reddit_clone/services/networkServices.dart';

// void main() {
//   final postModel = PostModel(
//     title: 'Moderator Test Post',
//     postId: 'test_post_id',
//     type: 'Post',
//     username: 'moderator_user',
//     communityName: 'test_community',
//     content: 'This is a test post for moderator actions',
//     pollOptions: [],
//     expirationDate: null,
//     netVote: 0,
//     isSpoiler: false,
//     isLocked: false,
//     isApproved: false,
//     isEdited: false,
//     createdAt: DateTime.now(),
//     updatedAt: DateTime.now(),
//     profilePicture: '',
//     commentCount: 0,
//     isDeletedUser: false,
//     isUpvoted: false,
//     isDownvoted: false,
//     isSaved: false,
//     isHidden: false,
//     isJoined: false,
//     isModerator: true,
//     isBlocked: false,
//     isNSFW: false,
//   );

// void main() {
//   testWidgets("Displays all moderation options'",(WidgetTester tester) async {
//     await tester.pumpWidget(
//       ChangeNotifierProvider<NetworkService>(
//         create: (_) => MockNetworkService(),
//         child: MaterialApp(
//           home: ModeratorPopUP(postModel: postModel),
//         ),
//       ),
//     );

//     await tester.pumpAndSettle();

//     expect(find.text('Approve post'), findsOneWidget);
//     expect(find.text('Remove post'), findsOneWidget);
//     expect(find.text('Remove as spam'), findsOneWidget);
//     expect(find.text('Lock comments'), findsOneWidget);
//     expect(find.text('Mark as spoiler'), findsOneWidget);
//     expect(find.text('Mark as NSFW'), findsOneWidget);
//   });
// }




  //   testWidgets('Displays all moderation options', (WidgetTester tester) async {
  //     await tester.pumpWidget(
  //       ChangeNotifierProvider<NetworkService>(
  //         create: (_) => MockNetworkService(),
  //         child: MaterialApp(
  //           home: ModeratorPopUP(postModel: postModel),
  //         ),
  //       ),
  //     );

  //     await tester.pumpAndSettle();

  //     // Verify all buttons are displayed
  //     expect(find.text('Approve post'), findsOneWidget);
  //     expect(find.text('Remove post'), findsOneWidget);
  //     expect(find.text('Remove as spam'), findsOneWidget);
  //     expect(find.text('Lock comments'), findsOneWidget);
  //     expect(find.text('Mark as spoiler'), findsOneWidget);
  //     expect(find.text('Mark as NSFW'), findsOneWidget);
  //   }),

  //   testWidgets('Test approval action', (WidgetTester tester) async {
  //     await tester.pumpWidget(
  //       ChangeNotifierProvider<NetworkService>(
  //         create: (_) => MockNetworkService(),
  //         child: MaterialApp(
  //           home: ModeratorPopUP(postModel: postModel),
  //         ),
  //       ),
  //     );

  //     await tester.pumpAndSettle();

  //     await tester.tap(find.text('Approve post')); // Tap the approve button
  //     await tester.pumpAndSettle();

  //     // Verify that the NetworkService's approvePost method is called
  //     expect(
  //       (tester
  //           .widgetList(find.byType(Provider<NetworkService>))
  //           .first as Provider<NetworkService>)
  //           .create()
  //           .approvePost('test_post_id', true),
  //       true,
  //     );
  //   }),

  //   testWidgets('Test removal action', (WidgetTester tester) async {
  //     await tester.pumpWidget(
  //       ChangeNotifierProvider<NetworkService>(
  //         create: (_) => MockNetworkService(),
  //         child: MaterialApp(
  //           home: ModeratorPopUP(postModel: postModel),
  //         ),
  //       ),
  //     );

  //     await tester.pumpAndSettle();

  //     await tester.tap(find.text('Remove post')); // Tap the remove button
  //     await tester.pumpAndSettle();

  //     // Verify the NetworkService's removePost method is called
  //     expect(
  //       (tester
  //           .widgetList(find.byType(Provider<NetworkService>))
  //           .first as Provider<NetworkService>)
  //           .create()
  //           .removePost('test_post_id', true),
  //       true,
  //     );

  //     // Ensure the dialog returns 'removed' when removing the post
  //     expect(find.byType(AlertDialog), findsNothing); // Dialog should close
  //   }),

  //   testWidgets('Test locking comments', (WidgetTester tester) async {
  //     await tester.pumpWidget(
  //       ChangeNotifierProvider<NetworkService>(
  //         create: (_) => MockNetworkService(),
  //         child: MaterialApp(
  //           home: ModeratorPopUP(postModel: postModel),
  //         ),
  //       ),
  //     );

  //     await tester.pumpAndSettle();

  //     await tester.tap(find.text('Lock comments')); // Tap the lock button
  //     await tester.pumpAndSettle();

  //     // Verify the NetworkService's lockpost method is called
  //     expect(
  //       (tester
  //           .widgetList(find.byType(Provider<NetworkService>))
  //           .first as Provider<NetworkService>)
  //           .create()
  //           .lockpost('test_post_id', true),
  //       true,
  //     );
  //   }),

  //   testWidgets('Test marking as NSFW', (WidgetTester tester) async {
  //     await tester.pumpWidget(
  //       ChangeNotifierProvider<NetworkService>(
  //         create: (_) => MockNetworkService(),
  //         child: MaterialApp(
  //           home: ModeratorPopUP(postModel: postModel),
  //         ),
  //       ),
  //     );

  //     await tester.pumpAndSettle();

  //     await tester.tap(find.text('Mark as NSFW')); // Tap NSFW button
  //     await tester.pumpAndSettle();

  //     // Verify the NetworkService's markAsNSFW method is called
  //     expect(
  //       (tester
  //           .widgetList(find.byType(Provider<NetworkService>))
  //           .first as Provider<NetworkService>)
  //           .create()
  //           .markAsNSFW('test_post_id', true),
  //       true,
  //     );
  //   }),

  //   testWidgets('Test marking as spoiler', (WidgetTester tester) async {
  //     await tester.pumpWidget(
  //       ChangeNotifierProvider<NetworkService>(
  //         create: (_) => MockNetworkService(),
  //         child: MaterialApp(
  //           home: ModeratorPopUP(postModel: postModel),
  //         ),
  //       ),
  //     );

  //     await tester.pumpAndSettle();

  //     await tester.tap(find.text('Mark as spoiler')); // Tap spoiler button
  //     await tester.pumpAndSettle();

  //     // Verify the NetworkService's markAsSpoiler method is called
  //     expect(
  //       (tester
  //           .widgetList(find.byType(Provider<NetworkService>))
  //           .first as Provider<NetworkService>)
  //           .create()
  //           .markAsSpoiler('test_post_id', true),
  //       true,
  //     );
  //   }),
  // });

