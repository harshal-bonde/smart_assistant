import 'package:get/get.dart';
import 'package:smart_assistant/chat/domain/data_class/chat_message.dart';
import 'package:smart_assistant/chat/domain/repositories/chat_repository.dart';
import 'package:smart_assistant/chat/infrastructure/datasources/chat_local_datasource.dart';

class ChatController extends GetxController {
  final ChatRepository repository;
  final ChatLocalDataSource localDataSource;

  ChatController({required this.repository, required this.localDataSource});

  final messages = <ChatMessage>[].obs;
  final isLoading = false.obs;
  final isSending = false.obs;
  final errorMessage = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    loadLocalHistory();
  }

  Future<void> loadLocalHistory() async {
    isLoading.value = true;
    try {
      final history = await localDataSource.getMessages();
      messages.assignAll(history);
    } catch (_) {
      messages.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendMessage(String text) async {
    final userMessage = ChatMessage(
      sender: 'user',
      message: text,
      timestamp: DateTime.now(),
    );

    messages.add(userMessage);
    isSending.value = true;
    errorMessage.value = null;

    await localDataSource.saveMessage(userMessage);

    try {
      final reply = await repository.sendMessage(text);
      final assistantMessage = ChatMessage(
        sender: 'assistant',
        message: reply,
        timestamp: DateTime.now(),
      );

      await localDataSource.saveMessage(assistantMessage);
      messages.add(assistantMessage);
    } catch (e) {
      errorMessage.value = 'Failed to get response. Please try again.';
    } finally {
      isSending.value = false;
    }
  }

  void clearChat() {
    messages.clear();
  }
}
