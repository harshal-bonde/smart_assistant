import 'package:hive/hive.dart';
import 'package:smart_assistant/chat/domain/data_class/chat_message.dart';

abstract class ChatLocalDataSource {
  Future<void> saveMessage(ChatMessage message);
  Future<List<ChatMessage>> getMessages();
  Future<void> clearMessages();
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  static const String _boxName = 'chat_history';

  Future<Box<ChatMessage>> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<ChatMessage>(_boxName);
    }
    return Hive.box<ChatMessage>(_boxName);
  }

  @override
  Future<void> saveMessage(ChatMessage message) async {
    final box = await _getBox();
    await box.add(message);
  }

  @override
  Future<List<ChatMessage>> getMessages() async {
    final box = await _getBox();
    return box.values.toList();
  }

  @override
  Future<void> clearMessages() async {
    final box = await _getBox();
    await box.clear();
  }
}
