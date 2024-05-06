class NotificationModel {
  final String id;
  final String user;
  final String notificationFrom;
  final String type;
  final String resourceId;
  final String title;
  final String content;
  bool isRead;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String profilePic;
  NotificationModel({
    required this.id,
    required this.user,
    required this.notificationFrom,
    required this.type,
    required this.resourceId,
    required this.title,
    required this.content,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
    required this.profilePic,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'],
      user: json['user'],
      notificationFrom: json['notificationFrom'],
      type: json['type'],
      resourceId: json['resourceId'],
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      isRead: json['isRead'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      profilePic: json['profilePicture'],
    );
  }
}
