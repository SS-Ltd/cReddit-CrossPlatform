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
class CustomNavigationBar extends StatefulWidget {
  /// Creates a custom navigation bar widget.
  ///
  /// The [key] parameter is used to provide a global key for the widget.
  CustomNavigationBar({super.key, required this.isProfile, this.myuser});

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
      chatInfo: [
        {
          'id': 'user1',
          'name': 'User One',
          'lastMessage': 'Hey, how are you?',
          'time': '10:45 PM',
          'unread': true,
          'profilePic': 'https://picsum.photos/240'
        },
        {
          'id': 'user2',
          'name': 'User Two',
          'lastMessage': 'Let\'s meet tomorrow',
          'time': '9:15 PM',
          'unread': true,
          'profilePic': 'https://picsum.photos/200'
        },
        {
          'id': 'user3',
          'name': 'User Three',
          'lastMessage': 'Thank you!',
          'time': '8:03 PM',
          'unread': false,
          'profilePic': 'https://picsum.photos/201'
        },
      ],
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
  Widget build(BuildContext context) {
    final menuState = Provider.of<MenuState>(context, listen: false);

    final user = context.read<NetworkService>().user;
    Set<Subreddit>? recentlyvisited = user?.recentlyVisited;
    List<Subreddit>? listRecentlyVisited = recentlyvisited?.toList();
    int listsize = listRecentlyVisited?.length ?? 0;
    String selectedMenuItem = "Hot"; // Store the selected menu item here

    print('User is logged in: ${user?.isLoggedIn}');
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
                  showrecently
                      ? SingleChildScrollView(
                          padding: EdgeInsets.zero,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: (listRecentlyVisited != null &&
                                    listRecentlyVisited.length > 3 &&
                                    showall == false)
                                ? 3
                                : (listRecentlyVisited?.length ?? 0),
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(listRecentlyVisited != null
                                    ? listRecentlyVisited[
                                            listRecentlyVisited.length -
                                                1 -
                                                index]
                                        .name
                                    : ''),
                              );
                            },
                          ),
                        )
                      : const SizedBox(),
                  const Divider(
                    height: 30,
                    thickness: 1,
                    color: Colors.white,
                  ),
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
                                builder: (context) => NewChatPage()),
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
                            icon: const Icon(Icons.search, size: 30.0),
                          ),
                    IconButton(
                      onPressed: () =>
                          _scaffoldKey.currentState!.openEndDrawer(),
                      icon: const Icon(Icons.reddit, size: 30.0),
                    ),
                  ],
                )
              : null,
      endDrawer: widget.isProfile ? null : const Rightsidebar(),
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
              isOwnProfile: true,)
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
                    icon: Icon(Icons.notifications), label: 'Inbox'),
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
            return Container(
              child: Wrap(
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
                    child: Container(
                      width: 400,
                      child: ElevatedButton(
                        child: const Text('Done'),
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
