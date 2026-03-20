import 'package:flutter_test/flutter_test.dart';
import 'package:smart_assistant/chat/domain/data_class/chat_message.dart';
import 'package:smart_assistant/chat/infrastructure/datasources/chat_local_datasource.dart';
import 'package:smart_assistant/chat/infrastructure/datasources/chat_remote_datasource.dart';
import 'package:smart_assistant/chat/infrastructure/repository/chat_repository_impl.dart';
import 'package:smart_assistant/common/network/exceptions.dart';

class FakeChatRemoteDataSource implements ChatRemoteDataSource {
  bool shouldThrow = false;
  String stubbedReply = 'Mock reply';

  @override
  Future<String> sendMessage(String message) async {
    if (shouldThrow) throw Exception('Network error');
    return stubbedReply;
  }

  @override
  Future<List<ChatMessage>> getChatHistory() async {
    if (shouldThrow) throw Exception('Network error');
    return [
      ChatMessage(
        sender: 'user',
        message: 'Hello',
        timestamp: DateTime(2025, 1, 1),
      ),
    ];
  }
}

class FakeChatLocalDataSource implements ChatLocalDataSource {
  final List<ChatMessage> _messages = [];
  bool shouldThrow = false;

  @override
  Future<void> saveMessage(ChatMessage message) async {
    if (shouldThrow) throw Exception('Cache error');
    _messages.add(message);
  }

  @override
  Future<List<ChatMessage>> getMessages() async {
    if (shouldThrow) throw Exception('Cache error');
    return List.from(_messages);
  }

  @override
  Future<void> clearMessages() async {
    if (shouldThrow) throw Exception('Cache error');
    _messages.clear();
  }
}

void main() {
  late ChatRepositoryImpl repository;
  late FakeChatRemoteDataSource fakeRemote;
  late FakeChatLocalDataSource fakeLocal;

  setUp(() {
    fakeRemote = FakeChatRemoteDataSource();
    fakeLocal = FakeChatLocalDataSource();
    repository = ChatRepositoryImpl(
      remoteDataSource: fakeRemote,
      localDataSource: fakeLocal,
    );
  });

  group('ChatRepositoryImpl', () {
    group('sendMessage', () {
      test('returns reply from remote data source', () async {
        fakeRemote.stubbedReply = 'Hello from assistant';
        final result = await repository.sendMessage('Hi');
        expect(result, 'Hello from assistant');
      });

      test('throws ServerException when remote fails', () async {
        fakeRemote.shouldThrow = true;
        expect(
          () => repository.sendMessage('Hi'),
          throwsA(isA<ServerException>()),
        );
      });
    });

    group('getChatHistory', () {
      test('returns history from remote data source', () async {
        final result = await repository.getChatHistory();
        expect(result.length, 1);
        expect(result.first.message, 'Hello');
      });

      test('throws ServerException when remote fails', () async {
        fakeRemote.shouldThrow = true;
        expect(
          () => repository.getChatHistory(),
          throwsA(isA<ServerException>()),
        );
      });
    });

    group('saveChatLocally', () {
      test('saves message via local data source', () async {
        final msg = ChatMessage(
          sender: 'user',
          message: 'Test',
          timestamp: DateTime(2025, 1, 1),
        );
        await repository.saveChatLocally(msg);
        final stored = await fakeLocal.getMessages();
        expect(stored.length, 1);
        expect(stored.first.message, 'Test');
      });

      test('throws CacheException when local fails', () async {
        fakeLocal.shouldThrow = true;
        final msg = ChatMessage(
          sender: 'user',
          message: 'Test',
          timestamp: DateTime(2025, 1, 1),
        );
        expect(
          () => repository.saveChatLocally(msg),
          throwsA(isA<CacheException>()),
        );
      });
    });

    group('getLocalChatHistory', () {
      test('returns messages from local data source', () async {
        final msg = ChatMessage(
          sender: 'user',
          message: 'Saved',
          timestamp: DateTime(2025, 1, 1),
        );
        await fakeLocal.saveMessage(msg);

        final result = await repository.getLocalChatHistory();
        expect(result.length, 1);
        expect(result.first.message, 'Saved');
      });
    });

    group('clearLocalHistory', () {
      test('clears all local messages', () async {
        final msg = ChatMessage(
          sender: 'user',
          message: 'To delete',
          timestamp: DateTime(2025, 1, 1),
        );
        await fakeLocal.saveMessage(msg);
        await repository.clearLocalHistory();

        final result = await fakeLocal.getMessages();
        expect(result, isEmpty);
      });

      test('throws CacheException when local fails', () async {
        fakeLocal.shouldThrow = true;
        expect(
          () => repository.clearLocalHistory(),
          throwsA(isA<CacheException>()),
        );
      });
    });
  });
}
