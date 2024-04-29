// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/features/Inbox/message_layout.dart';
import 'package:reddit_clone/features/Inbox/new_message.dart';
import 'package:reddit_clone/features/Inbox/notification_layout.dart';
import 'package:reddit_clone/models/messages.dart';
import 'package:reddit_clone/models/notification.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:reddit_clone/theme/palette.dart';

class InboxNotificationPage extends StatefulWidget {
  const InboxNotificationPage({super.key});

  @override
  State<InboxNotificationPage> createState() => _InboxNotificationPageState();
}

class _InboxNotificationPageState extends State<InboxNotificationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<Messages> inboxMessages = [];
  late List<NotificationModel> notifications = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchInboxMessages();
    fetchNotifications();
  }

  Future<void> fetchInboxMessages() async {
    final networkService = Provider.of<NetworkService>(context, listen: false);
    final fetchedMessages = await networkService.fetchInboxMessages();
    if (mounted && fetchedMessages != null) {
      setState(() {
        inboxMessages = fetchedMessages;
      });
    }
  }

  Future<void> fetchNotifications() async {
    final networkService = Provider.of<NetworkService>(context, listen: false);
    final fetchedNotifications = await networkService.fetchNotifications();
    print(fetchedNotifications);
    if (mounted && fetchedNotifications != null) {
      setState(() {
        notifications = fetchedNotifications;
      });
    }
  }

  void _showMenuOptions() {
    showModalBottomSheet(
        context: context,
        shape: Border.all(style: BorderStyle.none),
        builder: (BuildContext context) {
          return Container(
            color: Palette.backgroundColor,
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.edit_outlined),
                  title: const Text('New Message'),
                  onTap: () async {
                    final newMessage = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NewMessage()),
                    );
                    if (newMessage != null) {
                      setState(() {
                        inboxMessages.insert(0, newMessage);
                      });
                    }
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.mark_email_read),
                  title: const Text('Mark all inbox tabs as read'),
                  onTap: () async {
                    bool done = await context
                        .read<NetworkService>()
                        .markAllMessagesasRead();
                    if (!done) {
                      return;
                    }
                    setState(() {
                      for (var message in inboxMessages) {
                        message.isRead = true;
                      }
                      for (var notification in notifications) {
                        notification.isRead = true;
                      }
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings_outlined),
                  title: const Text('Edit notification settings'),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.settingsHeading,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Stack(
          children: [
            AppBar(
              automaticallyImplyLeading: false,
              bottom: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Notifications'),
                  Tab(text: 'Messages'),
                ],
                labelStyle: const TextStyle(fontSize: 16),
                labelColor: Palette.whiteColor,
                indicator: const UnderlineTabIndicator(
                    borderSide:
                        BorderSide(width: 2.0, color: Palette.blueColor),
                    insets: EdgeInsets.symmetric(horizontal: -20)),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: _showMenuOptions,
              ),
            ),
          ],
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
          ListView.builder(
            itemCount: inboxMessages.length,
            itemBuilder: (context, index) {
              return MessageLayout(
                message: inboxMessages[index],
                onTap: () async {
                  setState(() {
                    inboxMessages[index].isRead = true;
                  });
                  bool done = await context
                      .read<NetworkService>()
                      .markMessageAsRead(inboxMessages[index].id);
                  setState(() {
                    if (!done) {
                      inboxMessages[index].isRead = false;
                    }
                  });
                },
              );
            },
          ),
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
