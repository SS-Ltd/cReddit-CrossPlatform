import 'package:flutter/material.dart';
import 'package:reddit_clone/features/home_page/post.dart';

enum TabSelection { posts, comments, about }

/// A widget that represents the user feed.
class UserFeed extends StatefulWidget {
  final TabSelection tabSelection;

  /// Constructs a [UserFeed] widget.
  ///
  /// The [tabSelection] parameter is required and specifies the current tab selection.
  const UserFeed({
    required this.tabSelection,
    Key? key,
  }) : super(key: key);

  @override
  State<UserFeed> createState() => _UserState();
}

class _UserState extends State<UserFeed> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return mockPost();
          }),
    );
  }

  /// Builds a mock post widget.
  Widget mockPost() {
    return Column(
      children: [
        Post(
          communityName: 'Entrepreneur',
          userName: 'throwaway123',
          title: 'Escaping corporate Hell and finding freedom',
          postType: "Normal",
          content:
              'Man, let me have a  vent for a minute. Just got out of the shittiest '
              'gig ever – being a "marketing specialist" for the supposed big boys'
              ' over at Microsoft. Let me tell you, it was not bad.',
          commentNumber: 0,
          shareNumber: 0,
          timeStamp: DateTime.now(),
          profilePicture:
              'https://qph.cf2.quoracdn.net/main-qimg-e0b7b0c38b6cecad120db23705ccc4f3-pjlq',
          isHomePage: true,
          isSubRedditPage: false,
          postId: '123',
          votes: 0,
          isDownvoted: false,
          isUpvoted: false,
        ),
        const Divider(height: 1, thickness: 1), // Add a thin horizontal line
      ],
    );
  }
}
