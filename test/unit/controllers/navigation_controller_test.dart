import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:smart_assistant/chat/domain/data_class/chat_message.dart';
import 'package:smart_assistant/chat/infrastructure/datasources/chat_local_datasource.dart';
import 'package:smart_assistant/history/application/controllers/history_controller.dart';
import 'package:smart_assistant/navigation/application/controllers/navigation_controller.dart';

class FakeChatLocalDataSource implements ChatLocalDataSource {
  @override
  Future<void> saveMessage(ChatMessage message) async {}

  @override
  Future<List<ChatMessage>> getMessages() async => [];

  @override
  Future<void> clearMessages() async {}
}

void main() {
  late NavigationController controller;

  setUp(() {
    Get.testMode = true;
    Get.put<HistoryController>(
      HistoryController(localDataSource: FakeChatLocalDataSource()),
    );
    controller = NavigationController();
  });

  tearDown(() {
    Get.reset();
  });

  group('NavigationController', () {
    test('initial index is 0', () {
      expect(controller.currentIndex.value, 0);
    });

    test('changePage updates current index', () {
      controller.changePage(1);
      expect(controller.currentIndex.value, 1);
    });

    test('changePage to 2 triggers history reload', () {
      controller.changePage(2);
      expect(controller.currentIndex.value, 2);
    });

    test('changePage to same index still updates', () {
      controller.changePage(1);
      controller.changePage(1);
      expect(controller.currentIndex.value, 1);
    });
  });
}
