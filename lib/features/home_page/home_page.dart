import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/features/home_page/post.dart';
import 'package:reddit_clone/features/home_page/rightsidebar.dart';
import 'package:reddit_clone/features/home_page/select_item.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/services/NetworkServices.dart';

import '../../models/post_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> menuItems = ['Hot', 'Top', 'New'];
  String selectedMenuItem = 'Hot'; // Store the selected menu item here
  String lastType = "Hot";
  List<PostModel> posts = [];
  bool isLoading = false;
  int page = 1;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getPosts(selectedMenuItem);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> getPosts(String selectedItem) async {
    if (selectedMenuItem != lastType) {
      posts.clear();
      page = 1;
      lastType = selectedItem;
    }
    setState(() {
      isLoading = true;
    });
    List<PostModel>? fetchedPosts = await context
        .read<NetworkService>()
        .fetchUserPosts(page: page, sort: selectedItem.toLowerCase());
    if (fetchedPosts != null && mounted) {
      setState(() {
        posts.addAll(fetchedPosts);
        isLoading = false;
        page++; // Increment page for the next fetch
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoading) {
      getPosts(selectedMenuItem); // Fetch more posts when user reaches end
    }
  }

  Future<void> _refreshData() async {
    await getPosts(selectedMenuItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.menu, size: 30.0),
            ),
            SelectItem(
              menuItems: menuItems,
              onMenuItemSelected: (String selectedItem) {
                // Handle menu item selection here
                setState(() {
                  selectedMenuItem = selectedItem;
                });
                getPosts(
                    selectedItem); // Fetch posts for the selected menu item
                print('Selected: $selectedItem');
              },
            ),
          ],
        ),
        leadingWidth: 150,
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
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: ListView.builder(
          controller: _scrollController, // Attach ScrollController here
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts![index];
            return Column(
              children: [
                Post(
                  communityName: post.communityName ?? '',
                  userName: post.username,
                  title: post.title,
                  postType: post.type,
                  content: post.content,
                  commentNumber: post.commentCount,
                  shareNumber: 0,
                  timeStamp: post.uploadDate ?? DateTime.now(),
                  pollOptions: post.pollOptions,
                  isSubRedditPage: false,
                  profilePicture: post.profilePicture,
                  isHomePage: true,
                  postId: post.postId,
                  votes: post.netVote,
                  isDownvoted: post.isDownvoted,
                  isUpvoted: post.isUpvoted,
                ),
                const Divider(
                    height: 200, thickness: 1), // Add a thin horizontal line
              ],
            );
          },
        ),
      ),
    );
  }
}

// Widget mockPost() {
//   return Column(
//     children: [
//       Post(
//         communityName: 'Entrepreneur',
//         userName: 'throwaway123',
//         title: 'Escaping corporate Hell and finding freedom',
//         imageUrl:
//             'https://qph.cf2.quoracdn.net/main-qimg-e0b7b0c38b6cecad120db23705ccc4f3-pjlq',
//         // '',
//         content:
//             'Man, let me have a  vent for a minute. Just got out of the shittiest '
//             'gig ever – being a "marketing specialist" for the supposed big boys'
//             ' over at Microsoft. Let me tell you, it was not bad.',
//         commentNumber: 0,
//         shareNumber: 0,
//         timeStamp: DateTime.now(),
//         profilePicture:
//             'https://qph.cf2.quoracdn.net/main-qimg-e0b7b0c38b6cecad120db23705ccc4f3-pjlq',
//         isHomePage: true,
//         postId: '123',
//         votes: 0,
//         isDownvoted: false,
//         isUpvoted: false,
//       ),
//       const Divider(height: 1, thickness: 1), // Add a thin horizontal line
//     ],
//   );
// }

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