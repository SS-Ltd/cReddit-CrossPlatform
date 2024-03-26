class NotificationItem {
  String id;
  String title;
  bool isRead;
  String description;
  String type;
  String time;

  NotificationItem({
    required this.id,
    required this.title,
    this.isRead = false,
    this.description = '',
    this.type = '',
    required this.time,
  });
}
