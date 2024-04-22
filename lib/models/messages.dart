class Messages {
  final String from;
  final String subject;
  final String text;
  Messages({
    required this.from,
    required this.subject,
    required this.text,
  });

  factory Messages.fromJson(Map<String, dynamic> json) {
    return Messages(
      from: json['from'],
      subject: json['subject'],
      text: json['text'],
    );
  }
}
