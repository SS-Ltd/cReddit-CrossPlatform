import 'package:flutter/material.dart';
import 'package:reddit_clone/models/messages.dart';
import 'package:reddit_clone/theme/palette.dart';
import 'package:reddit_clone/utils/utils_time.dart';

class MessagePage extends StatelessWidget {
  final Messages message;

  const MessagePage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('u/${message.from}',
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
            titleSpacing: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(message.subject,
                  style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
            ),
            const Divider(color: Palette.greyColor, thickness: 0.15),
            Text("${message.from} • ${formatTimestamp(DateTime.parse(message.createdAt))}",
                style: const TextStyle(
                  color: Palette.greyColor,
                  fontSize: 12,
                )),
            const SizedBox(height: 3),
            Text(message.text),
          ],
        ),
      ),
    );
  }
}
