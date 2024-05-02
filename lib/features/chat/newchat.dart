import 'package:flutter/material.dart';

class NewChatPage extends StatefulWidget {
  @override
  _NewChatPageState createState() => _NewChatPageState();
}

class _NewChatPageState extends State<NewChatPage> {
  List<String> selectedUsers = [];
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
              : () {
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
                            onPressed: () {
                              if (groupName.isNotEmpty) {
                                // Create group chat
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  } else {
                    // Create single chat
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
          children: selectedUsers.map((user) => Chip(
            label: Text(user),
            onDeleted: () {
              setState(() {
                selectedUsers.remove(user);
              });
            },
          )).toList(),
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
            onChanged: (value) {
              // Search for users
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 10, // Replace with your user list length
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('User $index'), // Replace with your user name
                trailing: Checkbox(
                  value: selectedUsers.contains('User $index'),
                  onChanged: (checked) {
                    setState(() {
                      if (checked == true) {
                        selectedUsers.add('User $index');
                      } else {
                        selectedUsers.remove('User $index');
                      }
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}
}
