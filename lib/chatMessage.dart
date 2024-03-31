class ChatMessage {
  final String sender;
  final String text;
  final DateTime timestamp;
  final String receiver;

  ChatMessage({
    required this.sender,
    required this.text,
    required this.receiver,
    required this.timestamp,
  });
}
