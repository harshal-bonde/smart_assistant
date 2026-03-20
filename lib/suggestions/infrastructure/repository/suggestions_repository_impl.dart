import 'package:smart_assistant/common/network/exceptions.dart';
import 'package:smart_assistant/suggestions/domain/data_class/suggestions_response.dart';
import 'package:smart_assistant/suggestions/domain/repositories/suggestions_repository.dart';
import 'package:smart_assistant/suggestions/infrastructure/datasources/suggestions_remote_datasource.dart';

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
