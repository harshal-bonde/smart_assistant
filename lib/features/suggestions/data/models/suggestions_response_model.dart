import 'package:smart_assistant/features/suggestions/data/models/pagination_model.dart';
import 'package:smart_assistant/features/suggestions/data/models/suggestion_model.dart';
import 'package:smart_assistant/features/suggestions/domain/entities/suggestions_response.dart';

class SuggestionsResponseModel extends SuggestionsResponse {
  const SuggestionsResponseModel({
    required List<SuggestionModel> suggestions,
    required PaginationModel pagination,
  }) : super(suggestions: suggestions, pagination: pagination);

  factory SuggestionsResponseModel.fromJson(Map<String, dynamic> json) {
    return SuggestionsResponseModel(
      suggestions: (json['data'] as List)
          .map((e) => SuggestionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: PaginationModel.fromJson(
          json['pagination'] as Map<String, dynamic>),
    );
  }
}
