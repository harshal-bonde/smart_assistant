import 'package:smart_assistant/features/suggestions/domain/entities/pagination.dart';
import 'package:smart_assistant/features/suggestions/domain/entities/suggestion.dart';

class SuggestionsResponse {
  final List<Suggestion> suggestions;
  final Pagination pagination;

  const SuggestionsResponse({
    required this.suggestions,
    required this.pagination,
  });
}
