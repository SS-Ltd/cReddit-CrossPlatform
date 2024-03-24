import 'package:flutter/material.dart';
import 'package:reddit_clone/create_community_page.dart';
import 'package:reddit_clone/settings.dart';

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
            const Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "u/No_Significance_7222",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
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
                  const Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.cake, color: Colors.blue, size: 30),
                        SizedBox(width: 12),
                        Column(
                          children: [
                            Text(
                              "2y",
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
                      icon: Icons.person, text: 'My Profile', onTap: () {}),
                  _buildListTile(
                      icon: Icons.group_add,
                      text: 'Create a Community',
                      onTap: () {
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
                      icon: Icons.bookmark_border, text: 'Saved', onTap: () {}),
                  _buildListTile(
                      icon: Icons.history, text: 'History', onTap: () {}),
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
