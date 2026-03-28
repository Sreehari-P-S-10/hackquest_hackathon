enum MessageType { text, moodCheckin, suggestion }

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;
  final MessageType type;

  ChatMessage({
    required this.text,
    required this.isUser,
    DateTime? time,
    this.type = MessageType.text,
  }) : time = time ?? DateTime.now();

  String get formattedTime {
    final h = time.hour == 0
        ? 12
        : time.hour > 12
            ? time.hour - 12
            : time.hour;
    final m = time.minute.toString().padLeft(2, '0');
    final suffix = time.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $suffix';
  }
}