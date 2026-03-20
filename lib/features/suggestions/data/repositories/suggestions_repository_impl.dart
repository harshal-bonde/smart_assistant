import 'package:smart_assistant/core/error/exceptions.dart';
import 'package:smart_assistant/features/suggestions/data/datasources/suggestions_remote_datasource.dart';
import 'package:smart_assistant/features/suggestions/domain/entities/suggestions_response.dart';
import 'package:smart_assistant/features/suggestions/domain/repositories/suggestions_repository.dart';

class SuggestionsRepositoryImpl implements SuggestionsRepository {
  final SuggestionsRemoteDataSource remoteDataSource;

  SuggestionsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<SuggestionsResponse> getSuggestions({
    required int page,
    required int limit,
  }) async {
    try {
      return await remoteDataSource.getSuggestions(page: page, limit: limit);
    } catch (e) {
      throw const ServerException('Failed to fetch suggestions');
    }
  }
}
