import 'package:flutter_test/flutter_test.dart';
import 'package:smart_assistant/chat/domain/data_class/chat_message.dart';

void main() {
  group('ChatMessage', () {
    test('isUser returns true when sender is "user"', () {
      final msg = ChatMessage(
        sender: 'user',
        message: 'Hello',
        timestamp: DateTime(2025, 1, 1),
      );
      expect(msg.isUser, isTrue);
      expect(msg.isAssistant, isFalse);
    });

    test('isAssistant returns true when sender is "assistant"', () {
      final msg = ChatMessage(
        sender: 'assistant',
        message: 'Hi there!',
        timestamp: DateTime(2025, 1, 1),
      );
      expect(msg.isAssistant, isTrue);
      expect(msg.isUser, isFalse);
    });

    test('stores all fields correctly', () {
      final ts = DateTime(2025, 3, 15, 10, 30);
      final msg = ChatMessage(
        sender: 'user',
        message: 'Test message',
        timestamp: ts,
      );
      expect(msg.sender, 'user');
      expect(msg.message, 'Test message');
      expect(msg.timestamp, ts);
    });
  });
}
