import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:smart_assistant/chat/domain/data_class/chat_message.dart';
import 'package:smart_assistant/chat/infrastructure/datasources/chat_local_datasource.dart';
import 'package:smart_assistant/history/application/controllers/history_controller.dart';

class FakeChatLocalDataSource implements ChatLocalDataSource {
  final List<ChatMessage> _messages = [];
  bool shouldThrow = false;

  @override
  Future<void> saveMessage(ChatMessage message) async {
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
  late HistoryController controller;
  late FakeChatLocalDataSource fakeLocal;

  setUp(() {
    Get.testMode = true;
    fakeLocal = FakeChatLocalDataSource();
    controller = HistoryController(localDataSource: fakeLocal);
  });

  tearDown(() {
    Get.reset();
  });

  group('HistoryController', () {
    test('loadHistory populates messages', () async {
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

      await controller.loadHistory();

      expect(controller.messages.length, 2);
      expect(controller.isLoading.value, isFalse);
      expect(controller.errorMessage.value, isNull);
    });

    test('loadHistory sets error on failure', () async {
      fakeLocal.shouldThrow = true;
      await controller.loadHistory();

      expect(controller.errorMessage.value, isNotNull);
      expect(controller.isLoading.value, isFalse);
    });

    test('clearHistory removes all messages', () async {
      fakeLocal._messages.add(
        ChatMessage(
          sender: 'user',
          message: 'Test',
          timestamp: DateTime(2025, 1, 1),
        ),
      );
      await controller.loadHistory();
      expect(controller.messages, isNotEmpty);

      await controller.clearHistory();
      expect(controller.messages, isEmpty);
    });

    test('clearHistory sets error on failure', () async {
      fakeLocal._messages.add(
        ChatMessage(
          sender: 'user',
          message: 'Test',
          timestamp: DateTime(2025, 1, 1),
        ),
      );
      await controller.loadHistory();

      fakeLocal.shouldThrow = true;
      await controller.clearHistory();

      expect(controller.errorMessage.value, isNotNull);
    });
  });
}
