import 'package:smart_assistant/suggestions/domain/data_class/suggestions_response.dart';

abstract class SuggestionsRepository {
  Future<SuggestionsResponse> getSuggestions({
    required int page,
    required int limit,
  });
}
