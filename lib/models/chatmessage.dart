class ChatMessages {
  final String id;
  final String? user;
  final String room;
  final String content;
  final bool isDeleted;
  final List<dynamic> reactions;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatMessages({
    required this.id,
    this.user,
    required this.room,
    required this.content,
    required this.isDeleted,
    required this.reactions,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatMessages.fromJson(Map<String, dynamic> json) {
    return ChatMessages(
      id: json['_id'],
      user: json['user'],
      room: json['room'],
      content: json['content'],
      isDeleted: json['isDeleted'],
      reactions: json['reactions'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }
}
