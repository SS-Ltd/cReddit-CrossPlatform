import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/common/CustomLoadingIndicator.dart';
import 'package:reddit_clone/features/moderator/add_banned.dart';
import 'package:reddit_clone/models/bannedusers.dart';
import 'package:reddit_clone/services/networkServices.dart';

class BannedUser extends StatefulWidget {
  final String communityName;
  const BannedUser({super.key, required this.communityName});

  @override
  State<BannedUser> createState() {
    return _BannedUserState();
  }
}

class _BannedUserState extends State<BannedUser> {
  late BannedUserList? bannedUsers;

  @override
  void initState() {
    super.initState();
    fetchUnbannedUsers();
  }

  Future<BannedUserList?> fetchUnbannedUsers() async {
    final fetchedbannedUsers = await context
        .read<NetworkService>()
        .getBannedUsers(widget.communityName);
    bannedUsers = fetchedbannedUsers;
    print(bannedUsers?.bannedUsers.length);
    return bannedUsers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            key: const Key('backButton'),
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('Banned users'),
          actions: [
            IconButton(
              key: const Key('addButton'),
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
        body: FutureBuilder<BannedUserList?>(
          future: fetchUnbannedUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CustomLoadingIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final bannedUsers = snapshot.data?.bannedUsers ?? [];
              return ListView.builder(
                itemCount: bannedUsers.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        onTap: () {},
                        title: Text('u/${bannedUsers[index].name}'),
                        subtitle: Text(
                            'days: ${bannedUsers[index].days}'),
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                    ],
                  );
                },
              );
            }
          },
        ));
  }
}
