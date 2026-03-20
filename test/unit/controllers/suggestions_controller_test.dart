import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:smart_assistant/suggestions/domain/data_class/pagination.dart';
import 'package:smart_assistant/suggestions/domain/data_class/suggestion.dart';
import 'package:smart_assistant/suggestions/domain/data_class/suggestions_response.dart';
import 'package:smart_assistant/suggestions/domain/repositories/suggestions_repository.dart';
import 'package:smart_assistant/suggestions/application/controllers/suggestions_controller.dart';

class FakeSuggestionsRepository implements SuggestionsRepository {
  bool shouldThrow = false;
  int callCount = 0;

  @override
  Future<SuggestionsResponse> getSuggestions({
    required int page,
    required int limit,
  }) async {
    callCount++;
    if (shouldThrow) throw Exception('Network error');
    return SuggestionsResponse(
      suggestions: List.generate(
        limit,
        (i) => Suggestion(
          id: (page - 1) * limit + i + 1,
          title: 'Suggestion ${(page - 1) * limit + i + 1}',
          description: 'Description',
        ),
      ),
      pagination: Pagination(
        currentPage: page,
        totalPages: 5,
        totalItems: 50,
        limit: limit,
        hasNext: page < 5,
        hasPrevious: page > 1,
      ),
    );
  }
}

void main() {
  late SuggestionsController controller;
  late FakeSuggestionsRepository fakeRepo;

  setUp(() {
    Get.testMode = true;
    fakeRepo = FakeSuggestionsRepository();
    controller = SuggestionsController(repository: fakeRepo);
  });

  tearDown(() {
    Get.reset();
  });

  group('SuggestionsController', () {
    test('loadSuggestions populates suggestions list', () async {
      await controller.loadSuggestions();

      expect(controller.suggestions.length, 10);
      expect(controller.suggestions.first.id, 1);
      expect(controller.isLoading.value, isFalse);
      expect(controller.errorMessage.value, isNull);
    });

    test('loadSuggestions sets pagination', () async {
      await controller.loadSuggestions();

      expect(controller.pagination.value, isNotNull);
      expect(controller.pagination.value!.currentPage, 1);
      expect(controller.pagination.value!.totalItems, 50);
    });

    test('loadSuggestions sets error on failure', () async {
      fakeRepo.shouldThrow = true;
      await controller.loadSuggestions();

      expect(controller.errorMessage.value, isNotNull);
      expect(controller.isLoading.value, isFalse);
    });

    test('loadMoreSuggestions appends to existing list', () async {
      await controller.loadSuggestions();
      expect(controller.suggestions.length, 10);

      await controller.loadMoreSuggestions();
      expect(controller.suggestions.length, 20);
      expect(controller.pagination.value!.currentPage, 2);
    });

    test('loadMoreSuggestions does nothing when hasReachedMax', () async {
      await controller.loadSuggestions();

      // Simulate reaching max by loading all pages
      for (int i = 0; i < 4; i++) {
        await controller.loadMoreSuggestions();
      }
      expect(controller.hasReachedMax, isTrue);

      final countBefore = fakeRepo.callCount;
      await controller.loadMoreSuggestions();
      expect(fakeRepo.callCount, countBefore);
    });

    test('refreshSuggestions replaces existing data', () async {
      await controller.loadSuggestions();
      await controller.loadMoreSuggestions();
      expect(controller.suggestions.length, 20);

      await controller.refreshSuggestions();
      expect(controller.suggestions.length, 10);
      expect(controller.pagination.value!.currentPage, 1);
    });

    test('refreshSuggestions sets error on failure', () async {
      await controller.loadSuggestions();
      fakeRepo.shouldThrow = true;
      await controller.refreshSuggestions();

      expect(controller.errorMessage.value, isNotNull);
    });

    test('hasReachedMax returns false initially', () {
      expect(controller.hasReachedMax, isFalse);
    });
  });
}
