import 'package:flutter/material.dart';
import 'package:reddit_clone/features/moderator/add_approved.dart';

class ApprovedUser extends StatefulWidget {
  const ApprovedUser({super.key});

  @override
  State<ApprovedUser> createState() {
    return _ApprovedUserState();
  }
}

class _ApprovedUserState extends State<ApprovedUser> {
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
          title: const Text('Approved users'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => const AddApproved()));
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
