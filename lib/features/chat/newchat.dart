import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/features/home_page/custom_navigation_bar.dart';
import 'package:reddit_clone/models/search.dart';
import 'package:reddit_clone/services/networkServices.dart';

class NewChatPage extends StatefulWidget {
  @override
  _NewChatPageState createState() => _NewChatPageState();
}

class _NewChatPageState extends State<NewChatPage> {
  List<String> selectedUsers = [];
  List<SearchUsers> peopleResults = [];
  String groupName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Chat'),
        actions: [
          TextButton(
            onPressed: selectedUsers.isEmpty
                ? null
                : () async {
                    if (selectedUsers.length > 1) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Enter group name'),
                          content: TextField(
                            onChanged: (value) {
                              groupName = value;
                            },
                          ),
                          actions: [
                            TextButton(
                              child: const Text('Create'),
                              onPressed: () async {
                                if (groupName.isNotEmpty) {
                                  // Create group chat
                                  bool created =
                                      await Provider.of<NetworkService>(context,
                                              listen: false)
                                          .createGroupChatRoom(
                                              groupName, selectedUsers);
                                  if (created) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CustomNavigationBar(
                                                  isProfile: false,
                                                  navigateToChat: true,
                                                )));
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    } else {
                      // Create single chat
                      bool created = await Provider.of<NetworkService>(context,
                              listen: false)
                          .createPrivateChatRoom(selectedUsers);

                      if (created) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CustomNavigationBar(
                                      isProfile: false,
                                      navigateToChat: true,
                                    )));
                      }
                    }
                  },
            child: const Text(
              'Create',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Wrap(
            children: selectedUsers
                .map((user) => Chip(
                      label: Text(user),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      onDeleted: () {
                        setState(() {
                          selectedUsers.remove(user);
                        });
                      },
                    ))
                .toList(),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Search for people by username to chat with them.'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search username',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) async {
                // Search for users
                peopleResults =
                    await Provider.of<NetworkService>(context, listen: false)
                        .getSearchUsers(value);
                setState(() {
                  peopleResults = peopleResults;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: peopleResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(peopleResults[index].username),
                  trailing: Checkbox(
                    value:
                        selectedUsers.contains(peopleResults[index].username),
                    onChanged: null,
                  ),
                  onTap: () {
                    setState(() {
                      if (selectedUsers
                          .contains(peopleResults[index].username)) {
                        selectedUsers.remove(peopleResults[index].username);
                      } else {
                        selectedUsers.add(peopleResults[index].username);
                      }
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
