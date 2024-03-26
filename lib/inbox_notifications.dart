import 'package:flutter/material.dart';
import 'package:reddit_clone/notification_item.dart';
import 'package:reddit_clone/notification_layout.dart';

class InboxNotificationPage extends StatefulWidget {
  const InboxNotificationPage({super.key});

  @override
  State<InboxNotificationPage> createState() => _InboxNotificationPageState();
}

class _InboxNotificationPageState extends State<InboxNotificationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<NotificationItem> notifications = [
    NotificationItem(
        id: "1",
        title: "HweiMains",
        description: "One For All Hwei Winrate",
        time: "1m"),
    NotificationItem(
        id: "2",
        title:
            "u/PlasticDragonfruit84 replied to your post aaaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaaaaa",
        description: "i am a little late here but here is my take",
        time: "19d"),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _showMenuOptions() {
    showModalBottomSheet(
      context: context,
      shape: Border.all(style: BorderStyle.none),
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.message, color: Colors.black),
              title: const Text('New Message',
                  style: TextStyle(color: Colors.black)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.mark_email_read, color: Colors.black),
              title: const Text('Mark all inbox tabs as read',
                  style: TextStyle(color: Colors.black)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.black),
              title: const Text('Edit notification settings',
                  style: TextStyle(color: Colors.black)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: _showMenuOptions,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Notifications'),
            Tab(text: 'Messages'),
          ],
          labelStyle: const TextStyle(fontSize: 16),
          indicatorSize: TabBarIndicatorSize.tab,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return NotificationLayout(
                notification: notification,
                onTap: () {
                  setState(() {
                    notifications[index].isRead = true;
                  });
                },
              );
            },
          ),
          const Center(child: Text('Messages Content')),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
