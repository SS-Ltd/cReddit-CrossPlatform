import 'package:flutter/material.dart';
import 'package:cReddit/features/Inbox/message_item.dart';
import 'package:cReddit/features/Inbox/message_layout.dart';
import 'package:cReddit/features/Inbox/notification_item.dart';
import 'package:cReddit/features/Inbox/notification_layout.dart';

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
        title: "u/PlasticDragonfruit84 replied to your post",
        description: "I am a little late here but here is my take",
        time: "19d"),
    NotificationItem(
        id: "3",
        title: "u/TravelingSloth liked your comment",
        description: "“Absolutely brilliant point there!”",
        time: "2h"),
    NotificationItem(
        id: "4",
        title: "u/GreenTechie mentioned you in a comment",
        description: "I think u/ExampleUser might have some insights on this",
        time: "5d"),
    NotificationItem(
        id: "5",
        title: "u/CuriousCat posted in r/Cats",
        description: "Look at my cat’s new hat!",
        time: "3m"),
  ];

  List<MessageItem> messages = [
    MessageItem(
      id: "1",
      title: "Welcome to Reddit!",
      content: "Hello, welcome to Reddit! We're glad you're here.",
      senderUsername: "u/RedditAdmin",
      time: "1h",
      isRead: false,
    ),
    MessageItem(
      id: "2",
      title: "Can we collaborate?",
      content:
          "Hi there! I saw your post on r/FlutterDev. Are you open to collaboration on a Flutter project?",
      senderUsername: "u/FlutterFan123",
      time: "2d",
      isRead: true,
    ),
    MessageItem(
      id: "3",
      title: "Your subscription is expiring",
      content:
          "Just a reminder that your subscription to r/PremiumContent is expiring in 3 days.",
      senderUsername: "u/SubscriptionsBot",
      time: "4d",
      isRead: false,
    ),
    MessageItem(
      id: "4",
      title: "Thank you for your support!",
      content:
          "We just wanted to say a big thank you for supporting our Kickstarter campaign.",
      senderUsername: "u/KickstartThis",
      time: "6d",
      isRead: true,
    ),
    MessageItem(
      id: "5",
      title: "Your order has shipped",
      content:
          "Good news! Your order from r/ArtisanGoods has shipped. Track your package here: [link]",
      senderUsername: "u/CraftsmanBot",
      time: "8d",
      isRead: false,
    ),
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
          ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              return MessageLayout(
                message: message,
                onTap: () {
                  setState(() {
                    messages[index].isRead = true;
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
