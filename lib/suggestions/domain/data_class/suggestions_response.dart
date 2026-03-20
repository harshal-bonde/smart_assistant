import 'package:smart_assistant/suggestions/domain/data_class/pagination.dart';
import 'package:smart_assistant/suggestions/domain/data_class/suggestion.dart';

class SuggestionsResponse {
  final List<Suggestion> suggestions;
  final Pagination pagination;

  const SuggestionsResponse({
    required this.suggestions,
    required this.pagination,
  });
}
