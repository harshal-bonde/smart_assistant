import 'package:get/get.dart';
import 'package:smart_assistant/core/theme/theme_controller.dart';
import 'package:smart_assistant/features/chat/data/datasources/chat_local_datasource.dart';
import 'package:smart_assistant/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:smart_assistant/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:smart_assistant/features/chat/domain/repositories/chat_repository.dart';
import 'package:smart_assistant/features/chat/presentation/controller/chat_controller.dart';
import 'package:smart_assistant/features/history/presentation/controller/history_controller.dart';
import 'package:smart_assistant/features/suggestions/data/datasources/suggestions_remote_datasource.dart';
import 'package:smart_assistant/features/suggestions/data/repositories/suggestions_repository_impl.dart';
import 'package:smart_assistant/features/suggestions/domain/repositories/suggestions_repository.dart';
import 'package:smart_assistant/features/suggestions/presentation/controller/suggestions_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Data Sources
    Get.lazyPut<SuggestionsRemoteDataSource>(
      () => SuggestionsRemoteDataSourceImpl(),
      fenix: true,
    );
    Get.lazyPut<ChatRemoteDataSource>(
      () => ChatRemoteDataSourceImpl(),
      fenix: true,
    );
    Get.lazyPut<ChatLocalDataSource>(
      () => ChatLocalDataSourceImpl(),
      fenix: true,
    );

    // Repositories
    Get.lazyPut<SuggestionsRepository>(
      () => SuggestionsRepositoryImpl(
        remoteDataSource: Get.find<SuggestionsRemoteDataSource>(),
      ),
      fenix: true,
    );
    Get.lazyPut<ChatRepository>(
      () => ChatRepositoryImpl(
        remoteDataSource: Get.find<ChatRemoteDataSource>(),
        localDataSource: Get.find<ChatLocalDataSource>(),
      ),
      fenix: true,
    );

    // Controllers
    Get.put(ThemeController());
    Get.lazyPut(
      () => SuggestionsController(
        repository: Get.find<SuggestionsRepository>(),
      ),
      fenix: true,
    );
    Get.lazyPut(
      () => ChatController(
        repository: Get.find<ChatRepository>(),
        localDataSource: Get.find<ChatLocalDataSource>(),
      ),
      fenix: true,
    );
    Get.lazyPut(
      () => HistoryController(
        localDataSource: Get.find<ChatLocalDataSource>(),
      ),
      fenix: true,
    );
  }
}
