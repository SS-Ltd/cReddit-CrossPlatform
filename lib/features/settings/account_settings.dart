import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/common/arrow_button.dart';
import 'package:reddit_clone/features/settings/change_password.dart';
import 'package:reddit_clone/features/settings/chat_messages_permissions.dart';
import 'package:reddit_clone/common/heading.dart';
import 'package:reddit_clone/features/settings/muted_communities.dart';
import 'package:reddit_clone/features/settings/update_email.dart';
import 'package:reddit_clone/features/settings/manage_blocked_accounts.dart';
import 'package:reddit_clone/common/selection_button.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:reddit_clone/common/switch_button.dart';
import 'package:reddit_clone/theme/palette.dart';
import 'package:reddit_clone/features/settings/manage_notifications.dart';

/// A widget that represents the account settings screen.
///
/// This widget displays various settings related to the user's account,
/// such as updating email address, phone number, changing password,
/// managing connected accounts, contact settings, safety settings,
/// privacy settings, etc.
///
/// The [AccountSettings] widget uses a [FutureBuilder] to asynchronously
/// fetch the user settings from the network service. While the settings
/// are being fetched, a loading indicator is displayed. If there is an
/// error during the fetch, an error message is displayed. Once the settings
/// are fetched successfully, the settings are displayed in a [Scaffold]
/// with an [AppBar] and a [SingleChildScrollView] containing various
/// settings options.
///
/// Example usage:
///
/// ```dart
/// AccountSettings(
///   key: Key('accountSettings'),
/// )
/// ```
class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() {
    return _AccountSettingsState();
  }
}

class _AccountSettingsState extends State<AccountSettings> {
  String gender = '';
  String chosenGender = '';
  bool allowFollow = true;
  bool showCount = false;

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
          gender = settings!.account.gender;
          return Scaffold(
            backgroundColor: Palette.appBar,
            appBar: AppBar(
              backgroundColor: Palette.appBar,
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
                      optional: gender,
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
                    SelectionButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                BottomSheet(
                                  onClosing: () {},
                                  builder: (context) => Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            20, 10, 10, 0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Gender",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            // TextButton(
                                            //   onPressed: () {
                                            //     setState(() {
                                            //       gender = chosenGender;
                                            //     });
                                            //     Navigator.pop(context);
                                            //   },
                                            //   child: const Text("Done"),
                                            // ),
                                          ],
                                        ),
                                      ),
                                      RadioListTile(
                                        title: const Text("Man"),
                                        value: 'Man',
                                        groupValue: gender,
                                        onChanged: (value) {
                                          setState(
                                            () {
                                              gender = value.toString();
                                            },
                                          );
                                          Navigator.pop(context);
                                        },
                                      ),
                                      RadioListTile(
                                        title: const Text("Woman"),
                                        value: 'Woman',
                                        groupValue: gender,
                                        onChanged: (value) {
                                          setState(
                                            () {
                                              gender = value.toString();
                                            },
                                          );
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      buttonText: "Gender",
                      buttonIcon: Icons.person,
                      selectedtext: gender,
                    ),
                    const Heading(text: 'CONNECTED ACCOUNTS'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Google'),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                                onPressed: () {}, child: const Text('Connect')),
                          ],
                        )
                      ],
                    ),
                    const Heading(text: 'CONTACT SETTINGS'),
                    ArrowButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  fullscreenDialog: true,
                                  builder: (context) =>
                                      const ManageNotifications()));
                        },
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
                    SwitchButton(
                        buttonText: "Allow people to follow you",
                        buttonicon: Icons.person_add_alt_sharp,
                        onPressed: (value) {},
                        switchvalue: allowFollow),
                    SwitchButton(
                        buttonText: "show your follower count",
                        buttonicon: Icons.numbers,
                        onPressed: (value) {},
                        switchvalue: showCount),
                    const Heading(text: 'PRIVACY'),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
