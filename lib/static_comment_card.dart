import 'package:flutter/material.dart';

class StaticCommentCard extends StatelessWidget {
  final String username;
  final String content;
  final DateTime timestamp;

  const StaticCommentCard({
    required this.username,
    required this.content,
    required this.timestamp,
  });

  String formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return '${difference.inSeconds}s';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 12, 12, 12),
      shape: Border.all(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 7, 12, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.reddit.com%2Fr%2FOnePiece%2Fcomments%2Fww3xat%2Fi_drew_monkey_d_luffy_as_a_reddit_avatar_comment%2F&psig=AOvVaw0nRKxmKmnwvV23b3Se7kQs&ust=1710718192594000&source=images&cd=vfe&opi=89978449&ved=0CBMQjRxqFwoTCJjj2Ib4-YQDFQAAAAAdAAAAABAE'),
                ),
                const SizedBox(width: 10),
                Text(
                  username,
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                Text(
                  formatTimestamp(timestamp),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10,)
          ],
        ),
      ),
    );
  }
}
