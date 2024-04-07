import 'package:flutter/material.dart';
import 'package:reddit_clone/rightsidebar.dart';
import 'package:reddit_clone/post_options_menu.dart';
import 'package:intl/intl.dart';
// import 'block_button.dart';
import 'follow_unfollow_button.dart';
import 'chat_button.dart';
import 'package:reddit_clone/features/User/edit_button.dart';

class Profile extends StatefulWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String userName;
  final String profileName;
  final String displayName;
  final String about;
  final String profilePicture;
  final String bannerPicture;
  final int followerCount;
  final String cakeDay;
  final bool isOwnProfile;

  Profile({
    required this.userName,
    required this.profileName,
    required this.displayName,
    required this.about,
    required this.profilePicture,
    required this.bannerPicture,
    required this.followerCount,
    required this.cakeDay,
    this.isOwnProfile = false,
    super.key,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String _formattedCakeDay(String cakeDay) {
    DateTime parsedDate = DateTime.parse(cakeDay);
    return DateFormat('dd MMM yyyy').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget._scaffoldKey,
      endDrawer: const Rightsidebar(),
      body: Stack(
        children: [
          _buildBackground(),
          _buildProfileContent(),
          _buildAppBar(),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Stack(
      children: [
        Container(
          height: 300,
          padding: const EdgeInsets.only(top: 100, left: 8.0, right: 8.0),
          decoration: BoxDecoration(
            image: widget.bannerPicture.isNotEmpty
              ? DecorationImage(
                  image: NetworkImage(widget.bannerPicture),
                  fit: BoxFit.cover,
                )
              : null,
          ),
        ),
        Container(
          height: 300,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: widget.bannerPicture.isNotEmpty
                ? [Colors.transparent, Colors.black]
                : [Colors.blue, Colors.black],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileContent() {
    return Padding(
      padding: const EdgeInsets.only(top: 100, left: 8.0, right: 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.profilePicture),
                radius: 50,
              ),
              widget.isOwnProfile
                ? Align(
                    alignment: Alignment.bottomRight,
                    child: EditButton(
                      userName: widget.userName,
                    ),
                  ) 
                : Row(
                    children: [
                      ChatButton(
                        userName: widget.userName,
                        profileName: widget.displayName,
                      ),
                      FollowButton(
                        userName: widget.userName,
                        profileName: widget.profileName,
                      ),
                    ],
                  ),
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.displayName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'u/${widget.profileName} . ${_formattedCakeDay(widget.cakeDay)}',
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.about,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent, 
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search, size: 30.0),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.share, size: 30.0),
        ),
        PopupMenuButton<Menu>(
          onSelected: (Menu item) {},
          itemBuilder: (BuildContext context) => menuitems(),
        ),
      ],
    );
  }
}

List<PopupMenuEntry<Menu>> menuitems() {
  return <PopupMenuEntry<Menu>>[
    const PopupMenuItem<Menu>(
      value: Menu.share,
      child: ListTile(
        leading: Icon(Icons.share),
        title: Text('Share'),
      ),
    ),
    const PopupMenuItem<Menu>(
      value: Menu.subscribe,
      child: ListTile(
        leading: Icon(Icons.add_alert),
        title: Text('Subscribe'),
      ),
    ),
    const PopupMenuItem<Menu>(
      value: Menu.save,
      child: ListTile(
        leading: Icon(Icons.bookmark_add_outlined),
        title: Text('Save'),
      ),
    ),
    const PopupMenuItem<Menu>(
      value: Menu.copytext,
      child: ListTile(
        leading: Icon(Icons.copy),
        title: Text('Copy text'),
      ),
    ),
    const PopupMenuItem<Menu>(
      value: Menu.edit,
      child: ListTile(
        leading: Icon(Icons.edit),
        title: Text('Edit'),
      ),
    ),
    const PopupMenuItem<Menu>(
      value: Menu.addpostflair,
      child: ListTile(
        leading: Icon(Icons.add),
        title: Text('Add post flair'),
      ),
    ),
    const PopupMenuItem<Menu>(
      value: Menu.markspoiler,
      child: ListTile(
        leading: Icon(Icons.warning),
        title: Text('Mark spoiler'),
      ),
    ),
    const PopupMenuItem<Menu>(
      value: Menu.markNSFW,
      child: ListTile(
        leading: Icon(Icons.warning),
        title: Text('Mark NSFW'),
      ),
    ),
    const PopupMenuItem<Menu>(
      value: Menu.markasbrandaffiliate,
      child: ListTile(
        leading: Icon(Icons.warning),
        title: Text('Mark as brand affiliate'),
      ),
    ),
    const PopupMenuItem<Menu>(
      value: Menu.report,
      child: ListTile(
        leading: Icon(Icons.warning),
        title: Text('Report'),
      ),
    ),
  ];
}
