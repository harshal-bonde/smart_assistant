import 'package:smart_assistant/core/error/exceptions.dart';
import 'package:smart_assistant/features/chat/data/datasources/chat_local_datasource.dart';
import 'package:smart_assistant/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:smart_assistant/features/chat/domain/entities/chat_message.dart';
import 'package:smart_assistant/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final ChatLocalDataSource localDataSource;

  ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<String> sendMessage(String message) async {
    try {
      return await remoteDataSource.sendMessage(message);
    } catch (e) {
      throw const ServerException('Failed to send message');
    }
  }

  @override
  Future<List<ChatMessage>> getChatHistory() async {
    try {
      return await remoteDataSource.getChatHistory();
    } catch (e) {
      throw const ServerException('Failed to fetch chat history');
    }
  }

  @override
  Future<void> saveChatLocally(ChatMessage message) async {
    try {
      await localDataSource.saveMessage(message);
    } catch (e) {
      throw const CacheException('Failed to save message locally');
    }
  }

  @override
  Future<List<ChatMessage>> getLocalChatHistory() async {
    try {
      return await localDataSource.getMessages();
    } catch (e) {
      throw const CacheException('Failed to fetch local chat history');
    }
  }

  @override
  Future<void> clearLocalHistory() async {
    try {
      await localDataSource.clearMessages();
    } catch (e) {
      throw const CacheException('Failed to clear local history');
    }
  }
}
