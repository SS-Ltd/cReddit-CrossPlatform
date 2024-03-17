import 'package:flutter/material.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  bool isOnline = false; // Track online status

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.grey[900],
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
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
            // Online status button
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
                        Icon(Icons.star, color: Colors.blue, size: 30), // Icon
                        SizedBox(width: 20),
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

                  // Vertical Divider
                  VerticalDivider(
                      color: Colors.grey[800], thickness: 1, width: 20),

                  // Reddit Age Section
                  const Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.cake, color: Colors.blue, size: 30), // Icon
                        SizedBox(width: 18),
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
          ],
        ),
      ),
    );
  }
}
