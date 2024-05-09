import 'package:flutter/material.dart';
import 'package:reddit_clone/models/notification.dart';
import 'package:reddit_clone/theme/palette.dart';
import 'package:reddit_clone/utils/utils_time.dart';

class NotificationLayout extends StatelessWidget {
  const NotificationLayout(
      {super.key, required this.notification, required this.onTap});

  final NotificationModel notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      tileColor: notification.isRead
          ? Palette.backgroundColor
          : Palette.notificationColor,
      leading: CircleAvatar(
        backgroundImage: AssetImage(notification.profilePic),
      ),
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: notification.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Palette.whiteColor,
              ),
            ),
            TextSpan(
              text: ' • ${formatTimestamp(notification.updatedAt)}',
              style: const TextStyle(
                color: Palette.greyColor,
              ),
            ),
          ],
        ),
      ),
      subtitle: Text(
        notification.content,
        style: const TextStyle(color: Colors.grey),
      ),
      trailing: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            backgroundColor: Palette.textFormFieldgreyColor,
            builder: (BuildContext context) {
              return Wrap(
                children: <Widget>[
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 8, bottom: 4),
                      width: 30,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Palette.redditGrey,
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Center(
                      child: Text(
                        'Manage Notification',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const Divider(color: Colors.grey, thickness: 0.1),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    leading: const Icon(Icons.visibility_off_outlined),
                    title: const Text('Hide this notification'),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10.0),
                    leading: const Icon(Icons.cancel_outlined),
                    title: const Text('Disable updates from this community'),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    leading: const Icon(Icons.notifications_off_outlined),
                    title: const Text('Tun off this notification type'),
                    onTap: () => Navigator.pop(context),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Palette.transparent,
                          shadowColor: Palette.transparent,
                        ),
                        child: const Text('Close',
                            style: TextStyle(color: Palette.whiteColor)),
                      ),
                    ),
                  )
                ],
              );
            },
          );
        },
        child: const Icon(Icons.more_vert),
      ),
    );
  }
}
