import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/features/Inbox/inbox_notifications.dart';
import 'package:reddit_clone/features/home_page/home_page.dart';
import 'package:reddit_clone/features/home_page/rightsidebar.dart';
import 'package:reddit_clone/services/NetworkServices.dart';
import 'package:reddit_clone/theme/palette.dart';
import 'package:reddit_clone/create_post.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({super.key});

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  bool isprofile = false;
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _pages = [
    const HomePage(),
    const CreatePost(profile: false),
    const InboxNotificationPage(),

    // CommunitiesPage(),
    // CreatePage(),
    // ChatPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final user = context.read<NetworkService>().user;
    print('User is logged in: ${user?.isLoggedIn}');
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            Divider(
              height: 20,
              thickness: 1,
              color: Colors.white,
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: (_currentIndex == 0)
            ? ElevatedButton(
                onPressed: () {},
                child: const Text('Home'),
              )
            : (_currentIndex == 1) ? Title(
                color: Palette.whiteColor,
                child: const Text('Communities'),
              ) : (_currentIndex == 3) ? Title(
                color: Palette.whiteColor,
                child: const Text('Chat'),
              ) : Title(
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
            icon: const Icon(Icons.reddit, size: 30.0),
          ),
        ],
      ),
      endDrawer: const Rightsidebar(),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
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
      ),
    );
  }
}
