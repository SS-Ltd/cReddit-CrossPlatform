import 'package:flutter/material.dart';
import 'package:reddit_clone/common/heading.dart';
import 'package:reddit_clone/common/switch_button.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:provider/provider.dart';

class ManageEmails extends StatefulWidget {
  const ManageEmails({super.key});

  @override
  State<ManageEmails> createState() {
    return _ManageEmailsState();
  }
}

class _ManageEmailsState extends State<ManageEmails> {
  bool? chatRequests;
  bool? newFollowers;

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
            chatRequests = settings!.emailSettings.chatEmail;
            newFollowers = settings.emailSettings.followEmail;
            return StatefulBuilder(builder: (context, setState) {
              return Dialog.fullscreen(
                child: Scaffold(
                  appBar: AppBar(
                    title: const Text("Emails"),
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  body: Column(
                    children: [
                      const Heading(text: "MESSAGES"),
                      SwitchButton(
                          buttonText: "Chat requests",
                          buttonicon: Icons.chat,
                          onPressed: (value) {
                            setState(() {
                              chatRequests = value;
                            });
                          },
                          switchvalue: chatRequests ?? true),
                      const Heading(text: "ACTIVITY"),
                      SwitchButton(
                        buttonText: "New followers",
                        buttonicon: Icons.notifications,
                        onPressed: (value) {
                          setState(() {
                            newFollowers = value;
                          });
                        },
                        switchvalue: newFollowers ?? true,
                      )
                    ],
                  ),
                ),
              );
            });
          }
        });
  }
}
