import 'package:flutter/material.dart';

class Moderator extends StatefulWidget {
  const Moderator({super.key});

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
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(text: 'All'),
            Tab(text: 'Editable'),
          ],
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
                    //trailing: ,
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
