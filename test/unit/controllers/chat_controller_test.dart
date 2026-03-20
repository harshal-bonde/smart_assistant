import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:smart_assistant/chat/domain/data_class/chat_message.dart';
import 'package:smart_assistant/chat/domain/repositories/chat_repository.dart';
import 'package:smart_assistant/chat/infrastructure/datasources/chat_local_datasource.dart';
import 'package:smart_assistant/chat/application/controllers/chat_controller.dart';

class FakeChatRepository implements ChatRepository {
  bool shouldThrow = false;
  String stubbedReply = 'Assistant reply';

  @override
  Future<String> sendMessage(String message) async {
    if (shouldThrow) throw Exception('Network error');
    return stubbedReply;
  }

  @override
  Future<List<ChatMessage>> getChatHistory() async => [];

  @override
  Future<void> saveChatLocally(ChatMessage message) async {}

  @override
  Future<List<ChatMessage>> getLocalChatHistory() async => [];

  @override
  Future<void> clearLocalHistory() async {}
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
    _messages.clear();
  }
}

void main() {
  late ChatController controller;
  late FakeChatRepository fakeRepo;
  late FakeChatLocalDataSource fakeLocal;

  setUp(() {
    Get.testMode = true;
    fakeRepo = FakeChatRepository();
    fakeLocal = FakeChatLocalDataSource();
    controller = ChatController(
      repository: fakeRepo,
      localDataSource: fakeLocal,
    );
  });

  tearDown(() {
    Get.reset();
  });

  group('ChatController', () {
    test('loadLocalHistory populates messages from local storage', () async {
      fakeLocal._messages.addAll([
        ChatMessage(
          sender: 'user',
          message: 'Hello',
          timestamp: DateTime(2025, 1, 1),
        ),
        ChatMessage(
          sender: 'assistant',
          message: 'Hi!',
          timestamp: DateTime(2025, 1, 1),
        ),
      ]);

      await controller.loadLocalHistory();

      expect(controller.messages.length, 2);
      expect(controller.isLoading.value, isFalse);
    });

    test('loadLocalHistory clears messages on error', () async {
      fakeLocal.shouldThrow = true;
      await controller.loadLocalHistory();

      expect(controller.messages, isEmpty);
      expect(controller.isLoading.value, isFalse);
    });

    test('sendMessage adds user message and assistant reply', () async {
      fakeRepo.stubbedReply = 'Hello from AI';

      await controller.sendMessage('Hi there');

      expect(controller.messages.length, 2);
      expect(controller.messages[0].sender, 'user');
      expect(controller.messages[0].message, 'Hi there');
      expect(controller.messages[1].sender, 'assistant');
      expect(controller.messages[1].message, 'Hello from AI');
      expect(controller.isSending.value, isFalse);
    });

    test('sendMessage saves both messages to local storage', () async {
      await controller.sendMessage('Test');

      expect(fakeLocal._messages.length, 2);
      expect(fakeLocal._messages[0].sender, 'user');
      expect(fakeLocal._messages[1].sender, 'assistant');
    });

    test('sendMessage sets error on repository failure', () async {
      fakeRepo.shouldThrow = true;

      await controller.sendMessage('Hi');

      expect(controller.messages.length, 1); // only user message
      expect(controller.errorMessage.value, isNotNull);
      expect(controller.isSending.value, isFalse);
    });

    test('clearChat removes all messages', () async {
      await controller.sendMessage('Test');
      expect(controller.messages, isNotEmpty);

      controller.clearChat();
      expect(controller.messages, isEmpty);
    });
  });
}
