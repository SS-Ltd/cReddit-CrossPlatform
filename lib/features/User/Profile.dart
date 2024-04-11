import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:reddit_clone/features/home_page/post.dart';
import 'package:reddit_clone/features/home_page/select_item.dart';
// import 'package:reddit_clone/rightsidebar.dart';
import 'package:reddit_clone/post_options_menu.dart';
import 'package:intl/intl.dart';
// import 'block_button.dart';
import 'follow_unfollow_button.dart';
import 'chat_button.dart';
import 'package:reddit_clone/features/User/edit_button.dart';

enum TabSelection { posts, comments, about }

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
  TabSelection selectedTab = TabSelection.posts;
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
  // final List<String> feedMenuItems = ['hot', 'top', 'new'];
  String _formattedCakeDay(String cakeDay) {
    DateTime parsedDate = DateTime.parse(cakeDay);
    return DateFormat('dd MMM yyyy').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget._scaffoldKey,
      body: _buildProfileContent(),
    );
  }

  Widget _buildProfileContent() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          flexibleSpace: Stack(
            children: [
              FlexibleSpaceBar(
                title: Text(
                  widget.displayName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          floating: false,
          pinned: true,
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
        ),
        SliverToBoxAdapter(
          child: Stack(
            children: [
              Container(
                height: 190,
                decoration: widget.bannerPicture.isNotEmpty
                    ? BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(widget.bannerPicture),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.7),
                            BlendMode.dstATop,
                          ),
                        ),
                      )
                    : const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.blue, Colors.black],
                        ),
                      ),
              ),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black],
                  ),
                ),
                height: 190,
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, left: 8.0, right: 8.0),
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
                      child: widget.about.isNotEmpty
                          ? Text(
                              widget.about,
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 10.0),
                  ],
                ),
              ),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            color: const Color.fromARGB(255, 21, 21, 27),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.selectedTab = TabSelection.posts;
                          });
                        },
                        child: Text(
                          'Posts',
                          style: TextStyle(
                            color: widget.selectedTab == TabSelection.posts
                                ? Colors.blue
                                : Colors.white,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.selectedTab = TabSelection.comments;
                          });
                        },
                        child: Text(
                          'Comments',
                          style: TextStyle(
                            color: widget.selectedTab == TabSelection.comments
                                ? Colors.blue
                                : Colors.white,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.selectedTab = TabSelection.about;
                          });
                        },
                        child: Text(
                          'About',
                          style: TextStyle(
                            color: widget.selectedTab == TabSelection.about
                                ? Colors.blue
                                : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        if (widget.selectedTab == TabSelection.posts) ...[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return mockPost();
              },
              childCount: 5,
            ),
          ),
        ],
        if (widget.selectedTab == TabSelection.comments) ...[
          SliverToBoxAdapter(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: const Text("Comments content here"),
            ),
          ),
        ],
        if (widget.selectedTab == TabSelection.about) ...[
          SliverToBoxAdapter(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: const Text("About content here"),
            ),
          ),
        ],
      ],
    );
  }

  Widget postsFeed(){
    return Column(
      children: [
        // SelectItem(
        //   menuItems: feedMenuItems,
        //     onMenuItemSelected: (String selectedItem) {
        //       // Handle menu item selection here
        //       setState(() {
                
        //       });
        //       print('Selected: $selectedItem');
        //     },
        // ),

      ],
    );
  }

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


// class DropdownButton extends StatefulWidget {
//   const DropdownButton({super.key, required String value, required Icon icon});

//   @override
//   State<DropdownButton> createState() => _DropdownButtonState();
// }

// const List<String> list = <String>['top', 'hot', 'new'];
// class _DropdownButtonState extends State<DropdownButton> {
//   String dropdownValue = list.first;

//   @override
//   Widget build(BuildContext context) {
//     return DropdownButton(
//       value: dropdownValue,
//       icon: const Icon(Icons.arrow_downward),
//       elevation: 16,
//       style: const TextStyle(color: Colors.deepPurple),
//       underline: Container(
//         height: 2,
//         color: Colors.deepPurpleAccent,
//       ),
//       onChanged: (String? value) {
//         // This is called when the user selects an item.
//         setState(() {
//           dropdownValue = value!;
//         });
//       },
//       items: list.map<DropdownMenuItem<String>>((String value) {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: Text(value),
//         );
//       }).toList(),
//     );
//   }
// }
