import 'package:smart_assistant/features/suggestions/domain/entities/suggestion.dart';

class SuggestionModel extends Suggestion {
  const SuggestionModel({
    required int id,
    required String title,
    required String description,
  }) : super(id: id, title: title, description: description);

  factory SuggestionModel.fromJson(Map<String, dynamic> json) {
    return SuggestionModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }
}
