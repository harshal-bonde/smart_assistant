import 'package:smart_assistant/features/suggestions/domain/entities/suggestions_response.dart';

abstract class SuggestionsRepository {
  Future<SuggestionsResponse> getSuggestions({
    required int page,
    required int limit,
  });
}
