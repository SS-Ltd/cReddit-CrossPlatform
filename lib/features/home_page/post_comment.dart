import 'package:flutter/material.dart';
import 'package:reddit_clone/features/home_page/post.dart';

/// FILEPATH: /D:/College/Senior-1/Software/cReddit-CrossPlatform/lib/features/home_page/post_comment.dart
///
/// This file contains the implementation of the [PostComment] widget, which is a stateful widget
/// responsible for displaying a post comment section. It also defines the [Menu] enum, which represents
/// the different options available in the popup menu.
///
/// The [PostComment] widget is used in the home page of the cReddit app to display the comment section
/// for a post. It includes an app bar with various actions, such as search, sort, and a popup menu for
/// additional options. The body of the widget contains a mock post for demonstration purposes.
///
/// The [mockPost] function returns a [Column] widget containing a single [Post] widget, which represents
/// a post in the comment section. The [Post] widget displays information about the post, such as the
/// community name, user name, title, content, and number of comments and shares.
///
/// The [menuitems] function returns a list of [PopupMenuEntry] widgets, which are used to populate the
/// items in the popup menu. Each item represents a different option from the [Menu] enum, such as share,
/// subscribe, save, copy text, edit, and more.
enum Menu {
  share,
  subscribe,
  save,
  copytext,
  edit,
  addpostflair,
  markspoiler,
  markNSFW,
  markasbrandaffiliate,
  report,
  block,
  hide,
  delete
}

/// The [PostComment] widget is a stateful widget responsible for displaying a post comment section.
class PostComment extends StatefulWidget {
  const PostComment({super.key});

  @override
  State<PostComment> createState() {
    return _PostCommentState();
  }
}

class _PostCommentState extends State<PostComment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: _scaffoldKey,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, size: 30.0),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.sort, size: 30.0),
          ),
          PopupMenuButton(
              onSelected: (Menu item) {},
              itemBuilder: (BuildContext context) => menuitems()),
          IconButton(
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
            icon: const Icon(Icons.reddit, size: 30.0),
          ),
        ],
      ),
      body: mockPost(),
    );
  }
}

/// The [mockPost] function returns a [Column] widget containing a single [Post] widget.
///
/// The [Post] widget represents a post in the comment section. It displays information about the post,
/// such as the community name, user name, title, content, and number of comments and shares.
Widget mockPost() {
  return Column(
    children: [
      Post(
        communityName: 'Entrepreneur',
        profilePicture:
            'https://qph.cf2.quoracdn.net/main-qimg-e0b7b0c38b6cecad120db23705ccc4f3-pjlq',
        userName: 'throwaway123',
        title: 'Escaping corporate Hell and finding freedom',
        postType: 'Normal',
        content:
            'Man, let me have a  vent for a minute. Just got out of the shittiest '
            'gig ever – being a "marketing specialist" for the supposed big boys'
            ' over at Microsoft. Let me tell you, it was not bad.',
        commentNumber: 0,
        shareNumber: 0,
        timeStamp: DateTime.now(),

        isHomePage: false,
        isSubRedditPage: false,
        postId: '1',
        votes: 0,
        isDownvoted: false,
        isUpvoted: false,
      ),
    ],
  );
}

/// The [menuitems] function returns a list of [PopupMenuEntry] widgets.
///
/// Each [PopupMenuEntry] represents an item in the popup menu. The items are created using the [PopupMenuItem]
/// widget and are populated with icons and titles based on the [Menu] enum values.
List<PopupMenuEntry<Menu>> menuitems() {
  return <PopupMenuEntry<Menu>>[
    const PopupMenuItem<Menu>(
        value: Menu.share,
        child: ListTile(
          leading: Icon(Icons.share),
          title: Text('Share'),
        )),
    const PopupMenuItem<Menu>(
        value: Menu.subscribe,
        child: ListTile(
          leading: Icon(Icons.add_alert),
          title: Text('Subscribe'),
        )),
    const PopupMenuItem<Menu>(
        value: Menu.save,
        child: ListTile(
          leading: Icon(Icons.bookmark_add_outlined),
          title: Text('Share'),
        )),
    const PopupMenuItem<Menu>(
        value: Menu.copytext,
        child: ListTile(
          leading: Icon(Icons.copy),
          title: Text('Copy text'),
        )),
    const PopupMenuItem<Menu>(
        value: Menu.edit,
        child: ListTile(
          leading: Icon(Icons.edit),
          title: Text('Edit'),
        )),
    const PopupMenuItem<Menu>(
        value: Menu.addpostflair,
        child: ListTile(
          leading: Icon(Icons.add),
          title: Text('Add post flair'),
        )),

    const PopupMenuItem<Menu>(
        value: Menu.markspoiler,
        child: ListTile(
          leading: Icon(Icons.warning),
          title: Text('Mark spoiler'),
        )),
    const PopupMenuItem<Menu>(
        value: Menu.markNSFW,
        child: ListTile(
          leading: Icon(Icons.warning),
          title: Text('Mark NSFW'),
        )),
    const PopupMenuItem<Menu>(
        value: Menu.markasbrandaffiliate,
        child: ListTile(
          leading: Icon(Icons.warning),
          title: Text('Mark as brand affiliate'),
        )),
    const PopupMenuItem<Menu>(
        value: Menu.report,
        child: ListTile(
          leading: Icon(Icons.warning),
          title: Text('Report'),
        )),
  ];
}
