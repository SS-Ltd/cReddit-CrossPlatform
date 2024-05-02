class Chat {
  final String id;
  final String name;
  final List<String> members;
  final String? host;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Message? lastSentMessage;

  Chat({
    required this.id,
    required this.name,
    required this.members,
    required this.host,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.lastSentMessage,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['_id'],
      name: json['name'],
      members: List<String>.from(json['members']),
      host: json['host'],
      isDeleted: json['isDeleted'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      lastSentMessage: json['lastSentMessage'] != null
          ? Message.fromJson(json['lastSentMessage'])
          : null,
    );
  }
}

class Message {
  final String id;
  final String? user;
  final String room;
  final String content;
  final bool isDeleted;
  final List<dynamic> reactions;
  final DateTime createdAt;
  final DateTime updatedAt;

  Message({
    required this.id,
    this.user,
    required this.room,
    required this.content,
    required this.isDeleted,
    required this.reactions,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id'],
      user: json['user'],
      room: json['room'],
      content: json['content'],
      isDeleted: json['isDeleted'] ?? false,
      reactions: json['reactions'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }
}
