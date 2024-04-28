class Messages {
  final String id;
  final String from;
  final String to;
  final String subject;
  final String text;
  bool isRead;
  bool isDeleted;
  final String createdAt;
  Messages({
    required this.id,
    required this.from,
    required this.to,
    required this.subject,
    required this.text,
    this.isRead = false,
    this.isDeleted = false,
    required this.createdAt,
  });

  factory Messages.fromJson(Map<String, dynamic> json) {
    return Messages(
      id: json['_id'],
      from: json['from'],
      to: json['to'],
      subject: json['subject'],
      text: json['text'],
      isRead: json['isRead'],
      isDeleted: json['isDeleted'],
      createdAt: json['createdAt'],
    );
  }
}
