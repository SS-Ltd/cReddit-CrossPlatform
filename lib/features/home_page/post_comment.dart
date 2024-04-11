import 'package:flutter/material.dart';
import 'package:reddit_clone/features/home_page/post.dart';
import 'package:reddit_clone/features/comments/comment_page.dart';
import 'package:reddit_clone/post_options_menu.dart';

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
        // leading: const Icon(Icons.menu, size: 30.0),
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

List<PopupMenuEntry<Menu>> menuitems() {
  return <PopupMenuEntry<Menu>>[
    //////////////////////////////////////////
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
