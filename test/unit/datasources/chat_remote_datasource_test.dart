import 'package:flutter_test/flutter_test.dart';
import 'package:smart_assistant/chat/infrastructure/datasources/chat_remote_datasource.dart';

void main() {
  late ChatRemoteDataSourceImpl dataSource;

  setUp(() {
    dataSource = ChatRemoteDataSourceImpl();
  });

  group('ChatRemoteDataSource', () {
    test('returns keyword-matched response for "flutter"', () async {
      final response = await dataSource.sendMessage('Tell me about flutter');

      expect(response, contains('Flutter'));
      expect(response, contains('Google'));
    });

    test('returns keyword-matched response for "dart"', () async {
      final response = await dataSource.sendMessage('What is dart?');

      expect(response, contains('Dart'));
    });

    test('returns keyword-matched response for "state management"', () async {
      final response = await dataSource.sendMessage('Explain state management');

      expect(response, contains('state management'));
    });

    test('returns generic response for unmatched input', () async {
      final response = await dataSource.sendMessage('random gibberish xyz');

      expect(response, isNotEmpty);
    });

    test('getChatHistory returns sample messages', () async {
      final history = await dataSource.getChatHistory();

      expect(history, isNotEmpty);
      expect(history.length, 4);
      expect(history.first.sender, 'user');
      expect(history[1].sender, 'assistant');
    });
  });
}
