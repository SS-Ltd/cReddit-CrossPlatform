import 'package:flutter/material.dart';
import 'package:reddit_clone/common/arrow_button.dart';
import 'package:reddit_clone/features/moderator/add_moderator.dart';
import 'package:reddit_clone/theme/palette.dart';

class Moderator extends StatefulWidget {
  const Moderator({super.key, required this.communityName});

  final String communityName;

  @override
  State<Moderator> createState() {
    return _ModeratorState();
  }
}

class _ModeratorState extends State<Moderator>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Moderators'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => AddModerator(communityName: widget.communityName,)));
            },
            icon: const Icon(Icons.add),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              text: 'All',
            ),
            Tab(text: 'Editable'),
          ],
          labelStyle: const TextStyle(fontSize: 16),
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(width: 2.0, color: Palette.blueColor),
            insets: EdgeInsets.symmetric(horizontal: -50),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          ListView.builder(
            //itemCount: postsResults.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    onTap: () {},
                    //                     leading: CircleAvatar(
                    //   backgroundImage: NetworkImage(
                    //       peopleResults[index].profilePicture),
                    // ),
                    //                 title: Text(
                    // 'u/${peopleResults[index].username}'),
                    subtitle: const Text('cake'),
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                ],
              );
            },
          ),
          ListView.builder(
            //itemCount: postsResults.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    onTap: () {},
                    //                     leading: CircleAvatar(
                    //   backgroundImage: NetworkImage(
                    //       peopleResults[index].profilePicture),
                    // ),
                    //                 title: Text(
                    // 'u/${peopleResults[index].username}'),
                    subtitle: const Text('cake'),
                    trailing: IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                BottomSheet(
                                  onClosing: () {},
                                  builder: (context) => Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 20, 10, 20),
                                    child: Column(
                                      children: [
                                        ArrowButton(
                                            onPressed: () {},
                                            buttonText: "Edit permissions",
                                            buttonIcon: Icons.edit),
                                        ArrowButton(
                                            onPressed: () {},
                                            buttonText: "View profile",
                                            buttonIcon: Icons.person,
                                            hasarrow: false),
                                        ArrowButton(
                                            onPressed: () {},
                                            buttonText: "Remove",
                                            buttonIcon: Icons.close,
                                            hasarrow: false),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.more_vert),
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
