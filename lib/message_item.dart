class MessageItem {
  String id;
  String title;
  String content;
  String senderUsername;
  bool isRead;
  String time;

  MessageItem({
    required this.id,
    required this.title,
    required this.content,
    required this.senderUsername,
    this.isRead = false,
    required this.time,
  });
}
