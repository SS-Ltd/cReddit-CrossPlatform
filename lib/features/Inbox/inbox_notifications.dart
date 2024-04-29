// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/common/CustomLoadingIndicator.dart';
import 'package:reddit_clone/features/Inbox/message_layout.dart';
import 'package:reddit_clone/features/Inbox/new_message.dart';
import 'package:reddit_clone/features/Inbox/notification_item.dart';
import 'package:reddit_clone/features/Inbox/notification_layout.dart';
import 'package:reddit_clone/models/messages.dart';
import 'package:reddit_clone/models/user.dart';
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
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  int page = 1;

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController.addListener(_onScroll);
    fetchInboxMessages();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
  final maxScroll = _scrollController.position.maxScrollExtent;
  final currentScroll = _scrollController.position.pixels;
  const threshold = 200.0;

  if (maxScroll - currentScroll <= threshold && !isLoading) {
    fetchInboxMessages();
  }
}

  Future<void> fetchInboxMessages() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      final networkService =
          Provider.of<NetworkService>(context, listen: false);
      final fetchedMessages =
          await networkService.fetchInboxMessages(page: page);
      if (mounted) {
        if (fetchedMessages != null) {
          setState(() {
            inboxMessages.addAll(fetchedMessages);
            page++;
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      }
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
            controller: _scrollController,
            itemCount: inboxMessages.length + (isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < inboxMessages.length) {
                return MessageLayout(
                  message: inboxMessages[index],
                  onTap: () async {
                    UserModel user = context.read<NetworkService>().getUser();
                    if (inboxMessages[index].from == user.username ||
                        inboxMessages[index].isRead) {
                      return;
                    }
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
              } else {
                return CustomLoadingIndicator();
              }
            },
          ),
        ],
      ),
    );
  }
}
