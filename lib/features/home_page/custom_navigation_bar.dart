import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/features/Inbox/inbox_notifications.dart';
import 'package:reddit_clone/features/User/Profile.dart';
import 'package:reddit_clone/features/chat/chat_list.dart';
import 'package:reddit_clone/features/chat/newchat.dart';
import 'package:reddit_clone/features/home_page/home_page.dart';
import 'package:reddit_clone/features/home_page/menu_notifier.dart';
import 'package:reddit_clone/features/home_page/rightsidebar.dart';
import 'package:reddit_clone/features/home_page/select_item.dart';
import 'package:reddit_clone/models/subreddit.dart';
import 'package:reddit_clone/features/search/home_search.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:reddit_clone/features/Community/community_page.dart';
import 'package:reddit_clone/features/post/create_post.dart';
import 'package:reddit_clone/theme/palette.dart';
import 'package:reddit_clone/models/user.dart';
import 'package:badges/badges.dart' as badges;

/// A custom navigation bar widget that displays different pages based on the selected menu item.
///
/// This widget is used in the home page of the cReddit-CrossPlatform app.
/// It provides a navigation bar at the bottom of the screen and a drawer on the side.
/// The navigation bar allows the user to switch between different pages, such as the home page, communities page, create post page, inbox notification page, and chat page.
/// The drawer displays a list of recently visited subreddits and provides options to show all recently visited subreddits or hide them.
///
/// Example usage:
///
/// ```dart
/// CustomNavigationBar(
///   key: GlobalKey(),
/// )
/// ```
// ignore: must_be_immutable
class CustomNavigationBar extends StatefulWidget {
  /// Creates a custom navigation bar widget.
  ///
  /// The [key] parameter is used to provide a global key for the widget.

  final String? fcmToken;
  CustomNavigationBar(
      {super.key,
      required this.isProfile,
      this.myuser,
      this.navigateToChat,
      this.fcmToken});

  bool? navigateToChat;
  bool isProfile;
  final UserModel? myuser;

  @override
  State<StatefulWidget> createState() {
    return _CustomNavigationBarState();
  }
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  bool showrecently = true;
  bool showall = false;
  bool isprofile = false;
  int _currentIndex = 0;

  final List<String> menuItems = ['Hot', 'Top', 'New'];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Widget> _pages = [
    const HomePage(),
    const CommunityPage(),
    const CreatePost(profile: false),
    const ChatListScreen(
      channelInfo: [
        {
          'name': 'Channel One',
          'subredditName': 'r/Wholesome',
          'description': 'Wholesome & Heartwarming',
          'profilePic': 'https://picsum.photos/202'
        },
        {
          'name': 'Channel Two',
          'subredditName': 'r/Heartwarming',
          'description': 'Heartwarming stories',
          'profilePic': 'https://picsum.photos/203'
        },
        {
          'name': 'Channel Three',
          'subredditName': 'r/FeelGood',
          'description': 'Feel good, positive news',
          'profilePic': 'https://picsum.photos/204'
        },
      ],
    ),
    const InboxNotificationPage(),
  ];

  @override
  void initState() {
    super.initState();

    if (widget.navigateToChat != null && widget.navigateToChat!) {
      _currentIndex = 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    final menuState = Provider.of<MenuState>(context, listen: false);

    final user = context.read<NetworkService>().user;
    Set<Subreddit>? recentlyvisited = user?.recentlyVisited;
    List<Subreddit>? listRecentlyVisited = recentlyvisited?.toList();

    return Scaffold(
      key: _scaffoldKey,
      drawer: widget.isProfile
          ? null
          : Drawer(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const Divider(
                    height: 30,
                    thickness: 1,
                    color: Colors.white,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            showrecently = !showrecently;
                          });
                        },
                        child: const Text('Recently Visited'),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            showall = !showall;
                          });
                        },
                        child: const Text('See all'),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: showrecently,
                    child: buildRecentlyVisited(listRecentlyVisited),
                  ),
                  const Divider(
                    height: 30,
                    thickness: 1,
                    color: Colors.white,
                  ),
                  buildModeratingSection(context),
                  const Divider(
                    height: 30,
                    thickness: 1,
                    color: Colors.white,
                  ),
                  buildYourCommunitiesSection(context),
                ],
              ),
            ),
      appBar: widget.isProfile
          ? null
          : (_currentIndex != 2)
              ? AppBar(
                  backgroundColor: Palette.appBar,
                  elevation: 2.6,
                  title: (_currentIndex == 0)
                      ? SelectItem(
                          menuItems: menuItems,
                          onMenuItemSelected: (String selectedItem) {
                            if (menuState.selectedMenuItem != selectedItem) {
                              menuState.setSelectedMenuItem(selectedItem);
                            }
                          },
                        )
                      : (_currentIndex == 1)
                          ? Title(
                              color: Palette.whiteColor,
                              child: const Text('Communities'),
                            )
                          : (_currentIndex == 3)
                              ? Title(
                                  color: Palette.whiteColor,
                                  child: const Text('Chat'),
                                )
                              : Title(
                                  color: Palette.whiteColor,
                                  child: const Text('Inbox'),
                                ),
                  actions: [
                    if (_currentIndex == 3)
                      IconButton(
                        icon: const Icon(Icons.message),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NewChatPage()),
                          );
                        },
                      ),
                    _currentIndex == 3
                        ? IconButton(
                            icon: const Icon(Icons.sort),
                            onPressed: () {
                              _showFilterModal(context);
                            },
                          )
                        : IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  fullscreenDialog: true,
                                  builder: (context) => const HomeSearch(),
                                ),
                              );
                            },
                            icon: Semantics(
                                label: 'Open search',
                                identifier: 'Open search',
                                child: const Icon(Icons.search, size: 30.0)),
                          ),
                    IconButton(
                      onPressed: () =>
                          _scaffoldKey.currentState!.openEndDrawer(),
                      icon: Semantics(
                          label: 'Open right sidebar',
                          identifier: 'Open right sidebar',
                          child: const Icon(Icons.reddit, size: 30.0)),
                    ),
                  ],
                )
              : null,
      endDrawer:
          widget.isProfile ? null : Rightsidebar(fcmToken: widget.fcmToken),
      body: widget.isProfile
          ? Profile(
              userName: widget.myuser!.username,
              profileName: widget.myuser!.username,
              displayName: widget.myuser!.displayName,
              about: 'about',
              profilePicture: widget.myuser!.profilePicture,
              bannerPicture: 'bannerPicture',
              followerCount: widget.myuser!.followers,
              cakeDay: '2024-03-25T15:37:33.339+00:00',
              isOwnProfile: true,
            )
          : _pages[_currentIndex],
      bottomNavigationBar: (_currentIndex != 2)
          ? BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _currentIndex,
              onTap: (int index) {
                setState(() {
                  _currentIndex = index;
                  widget.isProfile = false;
                });
              },
              selectedFontSize: 11, // Adjust the selected font size
              unselectedFontSize: 11, // Adjust the unselected font size
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.group), label: 'Communities'),
                BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Create'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.chat_outlined), label: 'Chat'),
                BottomNavigationBarItem(
                    icon: badges.Badge(
                      badgeContent: Text('3'),
                      child: Icon(Icons.notifications),
                    ),
                    label: 'Inbox'),
              ],
            )
          : null,
    );
  }

  bool isChatChannelsApplied = false;
  bool isGroupChatsApplied = false;
  bool isDirectChatsApplied = false;

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Wrap(
              children: <Widget>[
                const ListTile(
                  title: Text('Filter Chats'),
                ),
                const Divider(),
                CheckboxListTile(
                  title: const Text('Chat Channels'),
                  value: isChatChannelsApplied,
                  onChanged: (bool? newValue) {
                    setState(() {
                      isChatChannelsApplied = newValue ?? false;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Group Chats'),
                  value: isGroupChatsApplied,
                  onChanged: (bool? newValue) {
                    setState(() {
                      isGroupChatsApplied = newValue ?? false;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Direct Chats'),
                  value: isDirectChatsApplied,
                  onChanged: (bool? newValue) {
                    setState(() {
                      isDirectChatsApplied = newValue ?? false;
                    });
                  },
                ),
                Center(
                  child: SizedBox(
                    width: 400,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text('Done'),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

Widget buildRecentlyVisited(List<Subreddit>? subreddits) {
  return ListView.builder(
    padding: EdgeInsets.zero,
    shrinkWrap: true,
    itemCount: subreddits?.length ?? 0,
    itemBuilder: (context, index) {
      return ListTile(
        title: Text(subreddits![index].name),
      );
    },
  );
}

Widget buildModeratingSection(BuildContext context) {
  return ExpansionTile(
    title: const Text("Moderating"),
    children: [
      ListTile(
        title: const Text("Mod Feed"),
        onTap: () {},
      ),
      ListTile(
        title: const Text("Queues"),
        onTap: () {},
      ),
      ListTile(
        title: const Text("Modmail"),
        onTap: () {},
      ),
    ],
  );
}

Widget buildYourCommunitiesSection(BuildContext context) {
  return ExpansionTile(
    title: const Text("Your communities"),
    children: [
      ListTile(
        title: const Text("+ Create a community"),
        onTap: () {},
      ),
    ],
  );
}
