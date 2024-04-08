import 'package:flutter/material.dart';
import 'package:reddit_clone/features/home_page/post.dart';
import 'package:reddit_clone/features/home_page/rightsidebar.dart';
import 'package:reddit_clone/features/home_page/select_item.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> menuItems = ['Home', 'Popular', 'Watch', 'Latest'];
  bool isSelectItemClicked = false;

  Future<void> _refreshData() async {
    // Simulate loading data asynchronously
    await Future.delayed(Duration(seconds: 2));
    // Add your code to reload the data here

    // Once data is loaded, update the UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: const Icon(Icons.menu, size: 30.0),
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
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return mockPost();
        },
      ),
    );
  }
}

Widget mockPost() {
  return Column(
    children: [
      Post(
        communityName: 'Entrepreneur',
        userName: 'throwaway123',
        title: 'Escaping corporate Hell and finding freedom',
        imageUrl:
            'https://qph.cf2.quoracdn.net/main-qimg-e0b7b0c38b6cecad120db23705ccc4f3-pjlq',
        // '',
        content:
            'Man, let me have a  vent for a minute. Just got out of the shittiest '
            'gig ever – being a "marketing specialist" for the supposed big boys'
            ' over at Microsoft. Let me tell you, it was not bad.',
        commentNumber: 0,
        shareNumber: 0,
        timeStamp: DateTime.now(),
        isHomePage: true,
      ),
      const Divider(height: 1, thickness: 1), // Add a thin horizontal line
    ],
  );
}

// DropdownButton(
//             value: shownvalue,
//             icon: const Icon(Icons.arrow_downward),
//             onChanged: (value) {
//               setState(() {
//                 shownvalue = value;
//               });
//             },
//             items: list.map<DropdownMenuItem<String>>((String value) {
//               return DropdownMenuItem<String>(value: value, child: Text(value));
//             }).toList(),
//           ),
// DropdownButton(
//             value: shownvalue,
//             icon: const Icon(Icons.arrow_downward),
//             onChanged: (value) {
//               setState(() {
//                 shownvalue = value;
//               });
//             },
//             items: list.map<DropdownMenuItem<String>>((String value) {
//               return DropdownMenuItem<String>(value: value, child: Text(value));
//             }).toList(),
//           ),