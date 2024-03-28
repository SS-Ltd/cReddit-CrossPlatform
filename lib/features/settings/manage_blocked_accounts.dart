import 'package:flutter/material.dart';
import 'package:reddit_clone/features/settings/blocked_user_model.dart';

final dummyusers = [
  BlockedUserModel(onPressed: () {}, username: 'Osama', userphoto: 'qwdasdass'),
  BlockedUserModel(
      onPressed: () {}, username: 'Mohamed', userphoto: 'qwdasdass'),
];

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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
              // ListView.builder(
              //     itemCount: dummyusers.length,
              //     itemBuilder: (ctx, index) {
              //       return BlockedUser(
              //         onPressed: () {},
              //         username: dummyusers[index].username,
              //         userphoto: dummyusers[index].userphoto,
              //       );
              //     }),
            ],
          ),
        ),
      ),
    );
  }
}
