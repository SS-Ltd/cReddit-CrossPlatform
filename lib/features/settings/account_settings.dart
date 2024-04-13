import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cReddit/common/arrow_button.dart';
import 'package:cReddit/features/settings/change_password.dart';
import 'package:cReddit/features/settings/chat_messages_permissions.dart';
import 'package:cReddit/common/heading.dart';
import 'package:cReddit/features/settings/muted_communities.dart';
import 'package:cReddit/features/settings/update_email.dart';
import 'package:cReddit/features/settings/manage_blocked_accounts.dart';
import 'package:cReddit/services/networkServices.dart';

class AccountSettings extends StatelessWidget {
  const AccountSettings({super.key});

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
            return Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: const Text('Account settings'),
                ),
                body: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        const Heading(text: 'BASIC SETTINGS'),
                        ArrowButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    fullscreenDialog: true,
                                    builder: (context) => const UpdateEmail()));
                          },
                          buttonText: 'Update email address',
                          buttonIcon: Icons.settings,
                          optional: settings!.account.email,
                        ),
                        ArrowButton(
                          onPressed: () {},
                          buttonText: 'Update phone number',
                          buttonIcon: Icons.smartphone,
                          optional: '+923000000000',
                        ),
                        ArrowButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      fullscreenDialog: true,
                                      builder: (context) =>
                                          const ChangePassword()));
                            },
                            buttonText: 'Change password',
                            buttonIcon: Icons.settings),
                        ArrowButton(
                            onPressed: () {},
                            buttonText: 'Location customization',
                            buttonIcon: Icons.location_on_outlined,
                            optional: 'Use approximate location (based on IP)'),
                        const Heading(text: 'CONNECTED ACCOUNTS'),
                        const Heading(text: 'CONTACT SETTINGS'),
                        ArrowButton(
                            onPressed: () {},
                            buttonText: 'Manage notifications',
                            buttonIcon: Icons.notifications_none),
                        ArrowButton(
                            onPressed: () {},
                            buttonText: 'Manage emails',
                            buttonIcon: Icons.email_outlined),
                        const Heading(text: 'Safety'),
                        ArrowButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      fullscreenDialog: true,
                                      builder: (context) =>
                                          const ManageBlockedAccounts()));
                            },
                            buttonText: 'Manage blocked Accounts',
                            buttonIcon: Icons.block_flipped),
                        ArrowButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      fullscreenDialog: true,
                                      builder: (context) =>
                                          const MutedCommunities()));
                            },
                            buttonText: 'Manage muted communities',
                            buttonIcon: Icons.volume_off),
                        ArrowButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      fullscreenDialog: true,
                                      builder: (context) =>
                                          const ChatMessagesPermissions()));
                            },
                            buttonText: 'Chat and messaging permissions',
                            buttonIcon: Icons.message),
                        const Heading(text: 'PRIVACY'),
                      ],
                    ),
                  ),
                ));
          }
        });
  }
}
