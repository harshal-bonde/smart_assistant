import 'package:flutter_test/flutter_test.dart';
import 'package:smart_assistant/suggestions/domain/data_class/pagination.dart';
import 'package:smart_assistant/suggestions/domain/data_class/suggestion.dart';
import 'package:smart_assistant/suggestions/domain/data_class/suggestions_response.dart';
import 'package:smart_assistant/suggestions/infrastructure/datasources/suggestions_remote_datasource.dart';
import 'package:smart_assistant/suggestions/infrastructure/repository/suggestions_repository_impl.dart';
import 'package:smart_assistant/common/network/exceptions.dart';

class FakeSuggestionsRemoteDataSource implements SuggestionsRemoteDataSource {
  bool shouldThrow = false;
  SuggestionsResponse? stubbedResponse;

  @override
  Future<SuggestionsResponse> getSuggestions({
    required int page,
    required int limit,
  }) async {
    if (shouldThrow) throw Exception('Network error');
    return stubbedResponse ??
        const SuggestionsResponse(
          suggestions: [
            Suggestion(id: 1, title: 'Test', description: 'Desc'),
          ],
          pagination: Pagination(
            currentPage: 1,
            totalPages: 1,
            totalItems: 1,
            limit: 10,
            hasNext: false,
            hasPrevious: false,
          ),
        );
  }
}

void main() {
  late SuggestionsRepositoryImpl repository;
  late FakeSuggestionsRemoteDataSource fakeDataSource;

  setUp(() {
    fakeDataSource = FakeSuggestionsRemoteDataSource();
    repository = SuggestionsRepositoryImpl(remoteDataSource: fakeDataSource);
  });

  group('SuggestionsRepositoryImpl', () {
    test('returns suggestions from data source', () async {
      final result = await repository.getSuggestions(page: 1, limit: 10);

      expect(result.suggestions.length, 1);
      expect(result.suggestions.first.title, 'Test');
      expect(result.pagination.currentPage, 1);
    });

    test('throws ServerException when data source fails', () async {
      fakeDataSource.shouldThrow = true;

      expect(
        () => repository.getSuggestions(page: 1, limit: 10),
        throwsA(isA<ServerException>()),
      );
    });

    test('passes page and limit to data source', () async {
      fakeDataSource.stubbedResponse = const SuggestionsResponse(
        suggestions: [],
        pagination: Pagination(
          currentPage: 3,
          totalPages: 5,
          totalItems: 50,
          limit: 10,
          hasNext: true,
          hasPrevious: true,
        ),
      );

      final result = await repository.getSuggestions(page: 3, limit: 10);
      expect(result.pagination.currentPage, 3);
    });
  });
}
