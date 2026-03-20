import 'dart:math';

import 'package:smart_assistant/features/suggestions/data/models/suggestion_model.dart';
import 'package:smart_assistant/features/suggestions/data/models/suggestions_response_model.dart';
import 'package:smart_assistant/features/suggestions/data/models/pagination_model.dart';

abstract class SuggestionsRemoteDataSource {
  Future<SuggestionsResponseModel> getSuggestions({
    required int page,
    required int limit,
  });
}

class SuggestionsRemoteDataSourceImpl implements SuggestionsRemoteDataSource {
  static const _allSuggestions = [
    {'id': 1, 'title': 'Summarize my notes', 'description': 'Get a concise summary of your text'},
    {'id': 2, 'title': 'Generate email reply', 'description': 'Create a professional email response'},
    {'id': 3, 'title': 'Translate text', 'description': 'Translate your text to any language'},
    {'id': 4, 'title': 'Fix grammar', 'description': 'Correct grammar and spelling mistakes'},
    {'id': 5, 'title': 'Write a poem', 'description': 'Generate creative poetry on any topic'},
    {'id': 6, 'title': 'Code review', 'description': 'Get feedback on your code quality'},
    {'id': 7, 'title': 'Explain concept', 'description': 'Break down complex topics simply'},
    {'id': 8, 'title': 'Create a to-do list', 'description': 'Organize your tasks efficiently'},
    {'id': 9, 'title': 'Draft a blog post', 'description': 'Write engaging blog content'},
    {'id': 10, 'title': 'Brainstorm ideas', 'description': 'Generate creative ideas for any project'},
    {'id': 11, 'title': 'Write unit tests', 'description': 'Generate test cases for your code'},
    {'id': 12, 'title': 'Create a presentation', 'description': 'Draft slide content and talking points'},
    {'id': 13, 'title': 'Analyze data', 'description': 'Get insights from your dataset'},
    {'id': 14, 'title': 'Write a cover letter', 'description': 'Craft a compelling job application'},
    {'id': 15, 'title': 'Debug my code', 'description': 'Find and fix bugs in your code'},
    {'id': 16, 'title': 'Optimize performance', 'description': 'Improve your app speed and efficiency'},
    {'id': 17, 'title': 'Design a database', 'description': 'Plan your database schema and relations'},
    {'id': 18, 'title': 'Write documentation', 'description': 'Create clear and helpful docs'},
    {'id': 19, 'title': 'Plan a meeting', 'description': 'Create agenda and talking points'},
    {'id': 20, 'title': 'Simplify my writing', 'description': 'Make complex text easier to read'},
    {'id': 21, 'title': 'Generate API docs', 'description': 'Document your REST API endpoints'},
    {'id': 22, 'title': 'Create a workout plan', 'description': 'Design a personalized fitness routine'},
    {'id': 23, 'title': 'Write a recipe', 'description': 'Get step-by-step cooking instructions'},
    {'id': 24, 'title': 'Plan a trip', 'description': 'Create a detailed travel itinerary'},
    {'id': 25, 'title': 'Learn a new skill', 'description': 'Get a structured learning roadmap'},
    {'id': 26, 'title': 'Write a story', 'description': 'Generate creative fiction narratives'},
    {'id': 27, 'title': 'Create flashcards', 'description': 'Study aids for any subject'},
    {'id': 28, 'title': 'Proofread document', 'description': 'Check for errors and improve clarity'},
    {'id': 29, 'title': 'Generate SQL queries', 'description': 'Write database queries from descriptions'},
    {'id': 30, 'title': 'Summarize a book', 'description': 'Get key takeaways from any book'},
    {'id': 31, 'title': 'Write a speech', 'description': 'Craft an engaging presentation speech'},
    {'id': 32, 'title': 'Create a budget', 'description': 'Plan your finances effectively'},
    {'id': 33, 'title': 'Design a logo', 'description': 'Get creative logo design suggestions'},
    {'id': 34, 'title': 'Write a review', 'description': 'Compose thoughtful product reviews'},
    {'id': 35, 'title': 'Explain an error', 'description': 'Understand and fix error messages'},
    {'id': 36, 'title': 'Create a resume', 'description': 'Build a professional resume'},
    {'id': 37, 'title': 'Write a newsletter', 'description': 'Create engaging email newsletters'},
    {'id': 38, 'title': 'Plan a project', 'description': 'Break down projects into milestones'},
    {'id': 39, 'title': 'Generate regex', 'description': 'Create regular expressions from descriptions'},
    {'id': 40, 'title': 'Write social media posts', 'description': 'Create engaging social content'},
    {'id': 41, 'title': 'Create a survey', 'description': 'Design effective questionnaires'},
    {'id': 42, 'title': 'Explain a formula', 'description': 'Break down mathematical formulas'},
    {'id': 43, 'title': 'Write a contract', 'description': 'Draft basic legal agreements'},
    {'id': 44, 'title': 'Create a menu', 'description': 'Design a restaurant or event menu'},
    {'id': 45, 'title': 'Write release notes', 'description': 'Document software release changes'},
    {'id': 46, 'title': 'Plan a party', 'description': 'Organize event details and logistics'},
    {'id': 47, 'title': 'Create a playlist', 'description': 'Curate music for any mood or occasion'},
    {'id': 48, 'title': 'Write a FAQ', 'description': 'Create frequently asked questions'},
    {'id': 49, 'title': 'Design a workflow', 'description': 'Optimize your business processes'},
    {'id': 50, 'title': 'Write a thank you note', 'description': 'Express gratitude professionally'},
  ];

  @override
  Future<SuggestionsResponseModel> getSuggestions({
    required int page,
    required int limit,
  }) async {
    await Future.delayed(Duration(milliseconds: 500 + Random().nextInt(500)));

    final totalItems = _allSuggestions.length;
    final totalPages = (totalItems / limit).ceil();
    final startIndex = (page - 1) * limit;
    final endIndex = min(startIndex + limit, totalItems);

    final pageData = startIndex < totalItems
        ? _allSuggestions.sublist(startIndex, endIndex)
        : <Map<String, dynamic>>[];

    final suggestions =
        pageData.map((e) => SuggestionModel.fromJson(e)).toList();

    final pagination = PaginationModel(
      currentPage: page,
      totalPages: totalPages,
      totalItems: totalItems,
      limit: limit,
      hasNext: page < totalPages,
      hasPrevious: page > 1,
    );

    return SuggestionsResponseModel(
      suggestions: suggestions,
      pagination: pagination,
    );
  }
}
