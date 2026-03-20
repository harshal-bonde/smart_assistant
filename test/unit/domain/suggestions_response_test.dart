import 'package:flutter_test/flutter_test.dart';
import 'package:smart_assistant/suggestions/domain/data_class/pagination.dart';
import 'package:smart_assistant/suggestions/domain/data_class/suggestion.dart';
import 'package:smart_assistant/suggestions/domain/data_class/suggestions_response.dart';

void main() {
  group('SuggestionsResponse', () {
    test('holds suggestions and pagination together', () {
      const suggestions = [
        Suggestion(id: 1, title: 'A', description: 'Desc A'),
        Suggestion(id: 2, title: 'B', description: 'Desc B'),
      ];
      const pagination = Pagination(
        currentPage: 1,
        totalPages: 3,
        totalItems: 30,
        limit: 10,
        hasNext: true,
        hasPrevious: false,
      );
      const response = SuggestionsResponse(
        suggestions: suggestions,
        pagination: pagination,
      );
      expect(response.suggestions.length, 2);
      expect(response.pagination.currentPage, 1);
    });
  });
}
