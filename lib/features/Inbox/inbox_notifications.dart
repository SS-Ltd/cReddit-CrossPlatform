// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/common/CustomLoadingIndicator.dart';
import 'package:reddit_clone/features/Inbox/message_layout.dart';
import 'package:reddit_clone/features/Inbox/message_page.dart';
import 'package:reddit_clone/features/Inbox/new_message.dart';
import 'package:reddit_clone/features/Inbox/notification_layout.dart';
import 'package:reddit_clone/features/comments/comment_page.dart';
import 'package:reddit_clone/features/home_page/post.dart';
import 'package:reddit_clone/models/comments.dart';
import 'package:reddit_clone/models/messages.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/models/user.dart';
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
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  int page = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController.addListener(_onScroll);
    fetchInboxMessages();
    fetchNotifications();
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
    const threshold = 50;

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
        if (fetchedMessages != null && fetchedMessages.isNotEmpty) {
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
                      setState(() {});
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
            itemCount: notifications.length + (isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < notifications.length) {
                final notification = notifications[index];
                return NotificationLayout(
                  notification: notification,
                  onTap: () async {
                    context
                        .read<NetworkService>()
                        .markNotificationAsRead(notification.id);
                    notifications[index].isRead = true;
                    if (notification.type == 'upvotedPost' ||
                        notification.type == 'followedPost') {
                      PostModel post = await context
                          .read<NetworkService>()
                          .fetchPost(notification.resourceId);
                      Post postComment = Post(
                        postModel: post,
                        isHomePage: false,
                        isSubRedditPage: false,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommentPage(
                            postId: notification.resourceId,
                            postComment: postComment,
                            postTitle: post?.title ?? '',
                            username: post?.username ?? '',
                          ),
                        ),
                      );
                    }

                    if (notification.type == 'comment' ||
                        notification.type == 'upvotedComment') {
                      Comments? comment = await context
                          .read<NetworkService>()
                          .fetchCommentById(notification.resourceId);

                      PostModel post = await context
                          .read<NetworkService>()
                          .fetchPost(comment?.postId ?? '');

                      Post postComment = Post(
                        postModel: post,
                        isHomePage: false,
                        isSubRedditPage: false,
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommentPage(
                            postId: comment?.postId ?? '',
                            postComment: postComment,
                            postTitle: post?.title ?? '',
                            username: post?.username ?? '',
                            commentId: notification.resourceId,
                          ),
                        ),
                      );
                    }
                    setState(() {});
                  },
                );
              } else {
                return const CustomLoadingIndicator();
              }
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
                    if (inboxMessages[index].from != user.username &&
                        !inboxMessages[index].isRead) {
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
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MessagePage(message: inboxMessages[index]),
                      ),
                    );
                  },
                );
              } else {
                return const CustomLoadingIndicator();
              }
            },
          ),
        ],
      ),
    );
  }
}
