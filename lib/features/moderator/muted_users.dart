import 'package:flutter/material.dart';
import 'package:reddit_clone/features/moderator/add_moderator.dart';

class MutedUser extends StatefulWidget {
  const MutedUser({super.key});

  @override
  State<MutedUser> createState() {
    return _MutedUserState();
  }
}

class _MutedUserState extends State<MutedUser> {
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
          title: const Text('Muted users'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => const AddModerator()));
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
