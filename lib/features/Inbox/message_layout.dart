import 'package:flutter/material.dart';
import 'package:reddit_clone/common/CustomPopupMenuItem.dart';
import 'package:reddit_clone/features/Inbox/message_item.dart';

class MessageLayout extends StatelessWidget {
  final MessageItem message;
  final VoidCallback onTap;

  const MessageLayout({super.key, required this.message, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        width: 20,
        child: Align(
          alignment: Alignment.topCenter,
          child: Icon(
            message.isRead ? Icons.mail_outline : Icons.mail,
            color: message.isRead ? Colors.grey : Colors.blue,
          ),
        ),
      ),
      title: Text(
        message.title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.content,
            style: const TextStyle(color: Colors.grey),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            '${message.senderUsername} • ${message.time}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      trailing: GestureDetector(
        onTap: () {
          final RenderBox button = context.findRenderObject() as RenderBox;
          final RenderBox overlay =
              Overlay.of(context).context.findRenderObject() as RenderBox;
          final RelativeRect position = RelativeRect.fromRect(
            Rect.fromPoints(
              button.localToGlobal(button.size.bottomRight(Offset.zero),
                  ancestor: overlay),
              button.localToGlobal(button.size.bottomRight(Offset.zero),
                  ancestor: overlay),
            ),
            const Offset(20, 28) & overlay.size,
          );

          showMenu(
            context: context,
            position: position,
            items: [
              const CustomPopupMenuItem<String>(
                value: 'block',
                child: IntrinsicWidth(
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Icon(Icons.block),
                      SizedBox(width: 10),
                      Text('Block account'),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        child: const Icon(Icons.more_vert),
      ),
      onTap: onTap,
    );
  }
}
