import 'package:flutter/material.dart';

/// A list of dummy users for testing purposes.
final dummyusers = [];

/// A screen for managing blocked accounts.
class ManageBlockedAccounts extends StatefulWidget {
  const ManageBlockedAccounts({super.key});

  @override
  State<ManageBlockedAccounts> createState() {
    return _ManageBlockedAccountsState();
  }
}

class _ManageBlockedAccountsState extends State<ManageBlockedAccounts> {
  final _userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Blocked accounts'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: TextField(
                controller: _userNameController,
                decoration: InputDecoration(
                  hintText: 'Block new account',
                  suffixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40)),
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                //itemCount: dummyusers.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    //tileColor: ,
                    leading: const CircleAvatar(),
                    //title: Text(dummyusers[index].username),
                    trailing: ElevatedButton(
                      onPressed: () {},
                      child: const Text("Unblock"),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
