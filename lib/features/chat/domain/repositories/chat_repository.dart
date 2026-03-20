import 'package:smart_assistant/features/chat/domain/entities/chat_message.dart';

abstract class ChatRepository {
  Future<String> sendMessage(String message);
  Future<List<ChatMessage>> getChatHistory();
  Future<void> saveChatLocally(ChatMessage message);
  Future<List<ChatMessage>> getLocalChatHistory();
  Future<void> clearLocalHistory();
}
