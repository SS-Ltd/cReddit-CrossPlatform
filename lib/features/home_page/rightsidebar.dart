import 'package:flutter/material.dart';
import 'package:cReddit/features/Authentication/login.dart';
import 'package:cReddit/features/comments/reply_comment.dart';
import 'package:cReddit/features/community/create_community_page.dart';
import 'package:provider/provider.dart';
import 'package:cReddit/features/User/history.dart';
import 'package:cReddit/features/User/saved.dart';
import 'package:cReddit/features/settings/settings.dart';
import 'package:cReddit/models/user.dart';
import 'package:cReddit/new_page.dart';
import 'package:cReddit/services/networkServices.dart';
import 'package:cReddit/features/User/profile.dart';
import 'package:cReddit/features/User/profile.dart';
import 'package:cReddit/theme/Palette.dart';

class Rightsidebar extends StatefulWidget {
  const Rightsidebar({super.key});

  @override
  State<Rightsidebar> createState() {
    return _RightsidebarState();
  }
}

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
                //update this with button
                child: TextButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return BottomSheet(
                          onClosing: () {},
                          builder: (context) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                child: Row(
                                  children: [Text('Accounts')],
                                ),
                              ),
                              Divider(color: Colors.grey[800]),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.person,
                                          color: Colors.white),
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
                                            await context
                                                .read<NetworkService>()
                                                .logout();
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginScreen(),
                                              ),
                                            );
                                          },
                                          icon: const Icon(Icons.login))
                                    ],
                                  )
                                ],
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
                        Icon(Icons.cake, color: Colors.blue, size: 30),
                        SizedBox(width: 12),
                        Column(
                          children: [
                            Text(
                              formatTimestamp(user!.cakeDay),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text(
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
                            builder: (context) => Profile(
                              userName: myUser.username,
                              profileName: myUser.username,
                              displayName: myUser.displayName,
                              profilePicture: myUser.profilePicture,
                              followerCount: myUser.followers,
                              about: myUser.about!,
                              cakeDay: myUser.cakeDay.toString(),
                              bannerPicture: myUser.banner!,
                              isOwnProfile: true,
                            ),
                          ),
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

String formatTimestamp(DateTime timestamp) {
  final now = DateTime.now();
  final difference = now.difference(timestamp);

  if (difference.inDays > 0) {
    return '${difference.inDays}d';
  } else if (difference.inHours > 0) {
    return '${difference.inHours}h';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes}m';
  } else {
    return '${difference.inSeconds}s';
  }
}
