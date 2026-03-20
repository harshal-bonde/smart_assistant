import 'package:get/get.dart';
import 'package:smart_assistant/common/themes/theme_controller.dart';
import 'package:smart_assistant/chat/infrastructure/datasources/chat_local_datasource.dart';
import 'package:smart_assistant/chat/infrastructure/datasources/chat_remote_datasource.dart';
import 'package:smart_assistant/chat/infrastructure/repository/chat_repository_impl.dart';
import 'package:smart_assistant/chat/domain/repositories/chat_repository.dart';
import 'package:smart_assistant/chat/application/controllers/chat_controller.dart';
import 'package:smart_assistant/history/application/controllers/history_controller.dart';
import 'package:smart_assistant/suggestions/infrastructure/datasources/suggestions_remote_datasource.dart';
import 'package:smart_assistant/suggestions/infrastructure/repository/suggestions_repository_impl.dart';
import 'package:smart_assistant/suggestions/domain/repositories/suggestions_repository.dart';
import 'package:smart_assistant/suggestions/application/controllers/suggestions_controller.dart';

class AppBinding extends Bindings {
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
      () => SuggestionsController(repository: Get.find<SuggestionsRepository>()),
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
      () => HistoryController(localDataSource: Get.find<ChatLocalDataSource>()),
      fenix: true,
    );
  }
}
