import 'package:smart_assistant/chat/domain/data_class/chat_message.dart';

abstract class ChatRepository {
  Future<String> sendMessage(String message);
  Future<List<ChatMessage>> getChatHistory();
  Future<void> saveChatLocally(ChatMessage message);
  Future<List<ChatMessage>> getLocalChatHistory();
  Future<void> clearLocalHistory();
}
