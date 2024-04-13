import 'package:flutter/material.dart';
import 'package:reddit_clone/features/Inbox/notification_item.dart';

class NotificationLayout extends StatelessWidget {
  const NotificationLayout(
      {super.key, required this.notification, required this.onTap});

  final NotificationItem notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        color: notification.isRead
            ? Colors.white
            : const Color.fromARGB(255, 203, 237, 253),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/hehe.png'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: notification.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: ' • ${notification.time}',
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    notification.description,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
