import 'package:flutter_test/flutter_test.dart';
import 'package:smart_assistant/suggestions/infrastructure/datasources/suggestions_remote_datasource.dart';

void main() {
  late SuggestionsRemoteDataSourceImpl dataSource;

  setUp(() {
    dataSource = SuggestionsRemoteDataSourceImpl();
  });

  group('SuggestionsRemoteDataSource', () {
    test('returns first page with correct number of items', () async {
      final response = await dataSource.getSuggestions(page: 1, limit: 10);

      expect(response.suggestions.length, 10);
      expect(response.pagination.currentPage, 1);
      expect(response.pagination.totalItems, 50);
      expect(response.pagination.hasNext, isTrue);
      expect(response.pagination.hasPrevious, isFalse);
    });

    test('returns correct items for page 2', () async {
      final response = await dataSource.getSuggestions(page: 2, limit: 10);

      expect(response.suggestions.length, 10);
      expect(response.pagination.currentPage, 2);
      expect(response.pagination.hasPrevious, isTrue);
      expect(response.suggestions.first.id, 11);
    });

    test('returns last page correctly', () async {
      final response = await dataSource.getSuggestions(page: 5, limit: 10);

      expect(response.suggestions.length, 10);
      expect(response.pagination.currentPage, 5);
      expect(response.pagination.hasNext, isFalse);
      expect(response.pagination.totalPages, 5);
    });

    test('returns empty list for page beyond total', () async {
      final response = await dataSource.getSuggestions(page: 6, limit: 10);

      expect(response.suggestions, isEmpty);
      expect(response.pagination.hasNext, isFalse);
    });

    test('respects custom limit', () async {
      final response = await dataSource.getSuggestions(page: 1, limit: 5);

      expect(response.suggestions.length, 5);
      expect(response.pagination.totalPages, 10);
      expect(response.pagination.limit, 5);
    });

    test('suggestion fields are populated correctly', () async {
      final response = await dataSource.getSuggestions(page: 1, limit: 10);
      final first = response.suggestions.first;

      expect(first.id, 1);
      expect(first.title, 'Summarize my notes');
      expect(first.description, isNotEmpty);
    });
  });
}
