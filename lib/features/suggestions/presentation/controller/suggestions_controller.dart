import 'package:get/get.dart';
import 'package:smart_assistant/features/suggestions/domain/entities/pagination.dart';
import 'package:smart_assistant/features/suggestions/domain/entities/suggestion.dart';
import 'package:smart_assistant/features/suggestions/domain/repositories/suggestions_repository.dart';

class SuggestionsController extends GetxController {
  final SuggestionsRepository repository;

  SuggestionsController({required this.repository});

  static const int _limit = 10;

  final suggestions = <Suggestion>[].obs;
  final Rxn<Pagination> pagination = Rxn<Pagination>();
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final errorMessage = Rxn<String>();

  bool get hasReachedMax => pagination.value != null && !pagination.value!.hasNext;

  @override
  void onInit() {
    super.onInit();
    loadSuggestions();
  }

  Future<void> loadSuggestions() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final response = await repository.getSuggestions(page: 1, limit: _limit);
      suggestions.assignAll(response.suggestions);
      pagination.value = response.pagination;
    } catch (e) {
      errorMessage.value = 'Failed to load suggestions. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreSuggestions() async {
    if (hasReachedMax || isLoadingMore.value) return;

    isLoadingMore.value = true;
    try {
      final nextPage = (pagination.value?.currentPage ?? 0) + 1;
      final response =
          await repository.getSuggestions(page: nextPage, limit: _limit);
      suggestions.addAll(response.suggestions);
      pagination.value = response.pagination;
    } catch (e) {
      // Silently fail on load-more; user can scroll again
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> refreshSuggestions() async {
    errorMessage.value = null;
    try {
      final response = await repository.getSuggestions(page: 1, limit: _limit);
      suggestions.assignAll(response.suggestions);
      pagination.value = response.pagination;
    } catch (e) {
      errorMessage.value = 'Failed to refresh suggestions.';
    }
  }
}
