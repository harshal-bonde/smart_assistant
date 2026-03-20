import 'package:flutter_test/flutter_test.dart';
import 'package:smart_assistant/suggestions/domain/data_class/suggestion.dart';

void main() {
  group('Suggestion', () {
    test('stores all fields correctly', () {
      const suggestion = Suggestion(
        id: 1,
        title: 'Test Title',
        description: 'Test Description',
      );
      expect(suggestion.id, 1);
      expect(suggestion.title, 'Test Title');
      expect(suggestion.description, 'Test Description');
    });
  });
}
