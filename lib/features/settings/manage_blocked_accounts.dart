import 'package:flutter/material.dart';
import 'package:reddit_clone/common/CustomSnackBar.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:provider/provider.dart';

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
    return FutureBuilder(
      future: context.read<NetworkService>().getUserSettings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final settings = context.read<NetworkService>().userSettings;
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
                  Expanded(
                    child: ListView.builder(
                      itemCount: settings!.safetyAndPrivacy.blockedUsers.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                              radius: 10,
                              backgroundImage: NetworkImage(settings
                                  .safetyAndPrivacy
                                  .blockedUsers[index]
                                  .profilePicture)),
                          title: Text(settings
                              .safetyAndPrivacy.blockedUsers[index].username),
                          trailing: ElevatedButton(
                            onPressed: () async {
                              print("saadasdas");
                              bool unBlock = await context
                                  .read<NetworkService>()
                                  .unBlockUser(settings.safetyAndPrivacy
                                      .blockedUsers[index].username);
                              if (unBlock) {
                                setState(() {
                                  settings.safetyAndPrivacy.blockedUsers
                                      .removeAt(index);
                                });
                                CustomSnackBar(
                                    context: context,
                                    content:
                                        "${settings.safetyAndPrivacy.blockedUsers[index].username} unblocked",
                                    backgroundColor: Colors.green).show();
                              }
                            },
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
      },
    );
  }
}
