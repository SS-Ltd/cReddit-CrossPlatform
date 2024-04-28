class ChatMessage {
  final String senderId;
  final String recipientId;
  final String message;
  final DateTime timestamp;

  ChatMessage({
    required this.senderId,
    required this.recipientId,
    required this.message,
    required this.timestamp,
  });
}
