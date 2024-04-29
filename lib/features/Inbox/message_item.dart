class MessageItem {
  final String from;
  final String to;
  final String subject;
  final String text;
  bool isRead;
  bool isDeleted;
  final String createdAt;

  MessageItem({
    required this.from,
    required this.to,
    required this.subject,
    required this.text,
    required this.isRead,
    required this.isDeleted,
    required this.createdAt,
  });
}
