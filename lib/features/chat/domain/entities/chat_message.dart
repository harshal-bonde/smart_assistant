import 'package:hive/hive.dart';

part 'chat_message.g.dart';

@HiveType(typeId: 0)
class ChatMessage {
  @HiveField(0)
  final String sender;

  @HiveField(1)
  final String message;

  @HiveField(2)
  final DateTime timestamp;

  const ChatMessage({
    required this.sender,
    required this.message,
    required this.timestamp,
  });

  bool get isUser => sender == 'user';
  bool get isAssistant => sender == 'assistant';
}
