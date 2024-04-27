import 'package:flutter/material.dart';
import 'package:reddit_clone/features/Authentication/login.dart';
import 'package:reddit_clone/features/community/create_community_page.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/features/User/history.dart';
import 'package:reddit_clone/features/User/saved.dart';
import 'package:reddit_clone/features/home_page/widgets/custom_navigation_bar.dart';
import 'package:reddit_clone/features/settings/settings.dart';
import 'package:reddit_clone/models/user.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:reddit_clone/features/User/profile.dart';
import 'package:reddit_clone/theme/Palette.dart';
import 'package:reddit_clone/utils/utils_time.dart';

/// This file contains the implementation of the `Rightsidebar` widget.
///
/// The `Rightsidebar` widget is a stateful widget that represents the right sidebar of the home page.
/// It displays a drawer with various account-related options and information.
///
/// The `Rightsidebar` widget extends the `StatefulWidget` class and overrides the `createState` method
/// to create an instance of the `_RightsidebarState` class, which manages the state of the widget.
///
/// The `_RightsidebarState` class is a private class that extends the `State` class and manages the state
/// of the `Rightsidebar` widget. It contains a boolean variable `isOnline` to track the online status
/// and overrides the `build` method to build the UI of the widget.
///
/// The UI of the `Rightsidebar` widget consists of a `Drawer` widget with a dark grey background color.
/// It contains a column with the following children:
///   - An image widget displaying an image from the 'assets/hehe.png' file.
///   - A text button that opens a bottom sheet when pressed.
///   - The bottom sheet contains a column with account-related options and information.
///     - The column starts with a text widget displaying the text 'ACCOUNTS'.
///     - It is followed by a divider widget.
///     - It contains a row with an image widget displaying the user's profile picture and a text widget
///       displaying the user's username.
///     - It also contains a row with an icon button and an icon widget, representing a check mark and a logout button.
///     - The logout button opens another bottom sheet with logout confirmation options.
///
/// This widget requires the `BuildContext` to access the `NetworkService` and `user` information.

class Rightsidebar extends StatefulWidget {
  /// Creates a `Rightsidebar` widget.
  ///
  /// The `key` parameter is used to specify a unique identifier for the widget.
  const Rightsidebar({super.key});

  @override
  State<Rightsidebar> createState() {
    return _RightsidebarState();
  }
}

/// The state class for the `Rightsidebar` widget.
///
/// This class manages the state of the `Rightsidebar` widget.
/// It contains a boolean variable `isOnline` to track the online status.
/// It overrides the `build` method to build the UI of the widget.
class _RightsidebarState extends State<Rightsidebar> {
  bool isOnline = false;
  @override
  Widget build(BuildContext context) {
    final user = context.read<NetworkService>().user;
    return Drawer(
      child: Container(
        color: Colors.grey[900],
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25.0),
              child: Container(
                height: 200,
                child: Image.asset(
                  'assets/hehe.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const Border(),
                      builder: (BuildContext context) {
                        return BottomSheet(
                          onClosing: () {},
                          builder: (context) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 15, top: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      'ACCOUNTS',
                                      style: TextStyle(
                                        color: Palette.greyColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Divider(
                                  color: Colors.grey[800],
                                  thickness: 0.25,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 14, bottom: 5, right: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Image.network(
                                            user?.profilePicture ??
                                                'https://external-preview.redd.it/2ha9O240cGSUZZ0mCk6FYku61NmKUDgoOAJHMCpMjOM.png?auto=webp&s=3decd6c3ec58dc0a850933af089fb3ad12d3a505',
                                            width: 30,
                                            height: 30,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          'u/${user?.username ?? 'Username'}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        const Icon(
                                          Icons.check,
                                          color: Palette.blueJoinColor,
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            showModalBottomSheet(
                                              context: context,
                                              shape: const Border(),
                                              builder: (BuildContext context) {
                                                return Wrap(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 15,
                                                              top: 10),
                                                      child: Text(
                                                        'u/${user?.username ?? 'Username'}',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: const TextStyle(
                                                          color:
                                                              Palette.greyColor,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              right: 10),
                                                      child: Divider(
                                                        color: Colors.grey[800],
                                                        thickness: 0.25,
                                                      ),
                                                    ),
                                                    ListTile(
                                                      leading: const Icon(
                                                        Icons.login_outlined,
                                                        color: Color.fromARGB(
                                                            255, 249, 25, 25),
                                                      ),
                                                      title: const Text(
                                                        'Logout',
                                                        style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 249, 25, 25),
                                                        ),
                                                      ),
                                                      onTap: () async {
                                                        await context
                                                            .read<
                                                                NetworkService>()
                                                            .logout();
                                                        Navigator
                                                            .pushAndRemoveUntil(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                const LoginScreen(),
                                                          ),
                                                          (Route<dynamic>
                                                                  route) =>
                                                              false,
                                                        );
                                                      },
                                                    ),
                                                    ListTile(
                                                      title: const Center(
                                                        child: Text('Cancel',
                                                            style: TextStyle(
                                                                color: Palette
                                                                    .greyColor)),
                                                      ),
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          icon:
                                              const Icon(Icons.login_outlined),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.keyboard_arrow_down_sharp),
                  label: Text(
                    'u/${user?.username ?? 'Username'}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: OutlinedButton.icon(
                icon: isOnline
                    ? Icon(Icons.fiber_manual_record, color: Colors.green[400])
                    : const Icon(Icons.fiber_manual_record, color: Colors.grey),
                label: Text(
                  isOnline ? 'Online Status: On' : 'Online Status: Off',
                  style: TextStyle(
                    color: isOnline ? Colors.green[400] : Colors.grey,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                      color: isOnline
                          ? Colors.green[400] ?? Colors.green
                          : Colors.grey),
                ),
                onPressed: () {
                  setState(() {
                    isOnline = !isOnline;
                  });
                },
              ),
            ),
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  const Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.star, color: Colors.blue, size: 30),
                        SizedBox(width: 12),
                        Column(
                          children: [
                            Text(
                              "281",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              "Karma",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  VerticalDivider(
                      color: Colors.grey[800], thickness: 1, width: 20),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Icon(Icons.cake, color: Colors.blue, size: 30),
                        const SizedBox(width: 12),
                        Column(
                          children: [
                            Text(
                              formatTimestamp(user!.cakeDay),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const Text(
                              "Reddit Age",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: Colors.grey[800]),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildListTile(
                      icon: Icons.person,
                      text: 'My Profile',
                      onTap: () async {
                        UserModel myUser =
                            await context.read<NetworkService>().getMyDetails();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CustomNavigationBar(
                                    isProfile: true,
                                    myuser: myUser,
                                  )),
                        );
                      }),
                  _buildListTile(
                      icon: Icons.group_add,
                      text: 'Create a Community',
                      onTap: () async {
                        await context.read<NetworkService>().refreshToken();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateCommunityPage(),
                          ),
                        );
                      }),
                  _buildListTile(
                      icon: Icons.star_border,
                      text: 'Contributor Program',
                      onTap: () {}),
                  _buildListTile(
                      icon: Icons.lock_outline, text: 'Vault', onTap: () {}),
                  _buildListTile(
                      icon: Icons.card_membership,
                      text: 'Reddit Premium',
                      onTap: () {}),
                  _buildListTile(
                    icon: Icons.bookmark_border,
                    text: 'Saved',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SavedPage(),
                        ),
                      );
                    },
                  ),
                  _buildListTile(
                    icon: Icons.history,
                    text: 'History',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HistoryPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            _buildListTile(
              icon: Icons.settings,
              text: 'Settings',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Settings(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(
      {required IconData icon, required String text, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(text, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }
}
