import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/features/Inbox/inbox_notifications.dart';
import 'package:reddit_clone/features/home_page/home_page.dart';
import 'package:reddit_clone/features/home_page/menu_notifier.dart';
import 'package:reddit_clone/features/home_page/rightsidebar.dart';
import 'package:reddit_clone/features/home_page/select_item.dart';
import 'package:reddit_clone/models/subreddit.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:reddit_clone/features/Community/community_page.dart';
import 'package:reddit_clone/features/post/create_post.dart';
import 'package:reddit_clone/theme/palette.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({super.key});

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

    print(showrecently);
    print('User is logged in: ${user?.isLoggedIn}');
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
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
                                      listRecentlyVisited.length - 1 - index]
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
      appBar: (_currentIndex != 2)
          ? AppBar(
              title: (_currentIndex == 0)
                  ? SelectItem(
                      menuItems: menuItems,
                      onMenuItemSelected: (String selectedItem) {
                        if (menuState.selectedMenuItem != selectedItem) {
                          menuState.setSelectedMenuItem(selectedItem);
                        }
                        print('Selected: $selectedItem');
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
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search, size: 30.0),
                ),
                IconButton(
                  onPressed: () => _scaffoldKey.currentState!.openEndDrawer(),
                  icon: Semantics(
                      label: 'Open right sidebar',
                      identifier: 'Open right sidebar',
                      child: const Icon(Icons.reddit, size: 30.0)),
                ),
              ],
            )
          : null,
      endDrawer: const Rightsidebar(),
      body: _pages[_currentIndex],
      bottomNavigationBar: (_currentIndex != 2)
          ? BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _currentIndex,
              onTap: (int index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              selectedFontSize: 12, // Adjust the selected font size
              unselectedFontSize: 12, // Adjust the unselected font size
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
}
