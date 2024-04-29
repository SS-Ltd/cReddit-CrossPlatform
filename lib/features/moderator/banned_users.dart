import 'package:flutter/material.dart';
import 'package:reddit_clone/features/moderator/add_banned.dart';
import 'package:reddit_clone/features/moderator/add_moderator.dart';

class BannedUser extends StatefulWidget {
  const BannedUser({super.key});

  @override
  State<BannedUser> createState() {
    return _BannedUserState();
  }
}

class _BannedUserState extends State<BannedUser> {
  @override
  void initState() {
    super.initState();
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
          title: const Text('Banned users'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => const Addbanned()));
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: ListView.builder(
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
        ));
  }
}
