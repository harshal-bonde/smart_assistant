import 'package:get/get.dart';
import 'package:smart_assistant/chat/infrastructure/datasources/chat_local_datasource.dart';
import 'package:smart_assistant/chat/domain/data_class/chat_message.dart';

class HistoryController extends GetxController {
  final ChatLocalDataSource localDataSource;

  HistoryController({required this.localDataSource});

  final messages = <ChatMessage>[].obs;
  final isLoading = false.obs;
  final errorMessage = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  Future<void> loadHistory() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final history = await localDataSource.getMessages();
      messages.assignAll(history);
    } catch (e) {
      errorMessage.value = 'Failed to load history.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> clearHistory() async {
    try {
      await localDataSource.clearMessages();
      messages.clear();
    } catch (e) {
      errorMessage.value = 'Failed to clear history.';
    }
  }
}
