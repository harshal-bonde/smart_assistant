import 'dart:math';

import 'package:smart_assistant/chat/domain/data_class/chat_message.dart';

abstract class ChatRemoteDataSource {
  Future<String> sendMessage(String message);
  Future<List<ChatMessage>> getChatHistory();
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  static const _responses = {
    'flutter':
        'Flutter is an open-source UI toolkit by Google for building natively compiled applications for mobile, web, and desktop from a single codebase. It uses the Dart programming language and provides a rich set of pre-designed widgets.',
    'state management':
        'Flutter state management helps you manage UI updates efficiently. Popular approaches include Provider, Riverpod, BLoC/Cubit, GetX, and MobX. BLoC pattern separates business logic from UI using streams and events.',
    'dart':
        'Dart is a client-optimized programming language developed by Google. It supports ahead-of-time compilation for fast startup, just-in-time compilation for fast development cycles, and can compile to JavaScript for web apps.',
    'widget':
        'In Flutter, everything is a widget. Widgets describe what their view should look like given their current configuration and state. There are two types: StatelessWidget (immutable) and StatefulWidget (mutable state).',
    'api':
        'To handle APIs in Flutter, you can use packages like http, dio, or retrofit. Best practices include using async/await, proper error handling, creating model classes for JSON parsing, and implementing repository patterns.',
    'navigation':
        'Flutter provides several navigation options: Navigator 1.0 (push/pop), Navigator 2.0 (declarative), and packages like go_router and auto_route. Navigation manages the stack of screens in your app.',
    'animation':
        'Flutter offers implicit animations (AnimatedContainer, AnimatedOpacity), explicit animations (AnimationController, Tween), and hero animations for shared element transitions between screens.',
    'testing':
        'Flutter supports unit tests, widget tests, and integration tests. Use the flutter_test package for unit and widget tests, and integration_test for end-to-end testing.',
    'bloc':
        'BLoC (Business Logic Component) is a state management pattern that separates business logic from the UI. It uses Streams for input (events) and output (states), making the code testable and reusable.',
    'provider':
        'Provider is a wrapper around InheritedWidget that makes state management simpler. It provides dependency injection and state management with minimal boilerplate code.',
  };

  static const _genericResponses = [
    'That\'s a great question! Let me help you with that. The key concept here involves understanding the fundamentals and applying best practices consistently.',
    'I\'d be happy to help! This is a common topic in software development. The approach depends on your specific requirements and constraints.',
    'Great topic! There are several ways to approach this. I recommend starting with the basics and gradually building up complexity as needed.',
    'Interesting question! The best practice here is to follow clean architecture principles, separate concerns, and write testable code.',
    'Let me explain that for you. This concept is fundamental to building robust applications. Focus on understanding the core principles first.',
    'That\'s something many developers ask about! The key is to balance simplicity with scalability in your implementation.',
  ];

  @override
  Future<String> sendMessage(String message) async {
    await Future.delayed(Duration(milliseconds: 800 + Random().nextInt(1200)));

    final lowerMessage = message.toLowerCase();

    for (final entry in _responses.entries) {
      if (lowerMessage.contains(entry.key)) {
        return entry.value;
      }
    }

    return _genericResponses[Random().nextInt(_genericResponses.length)];
  }

  @override
  Future<List<ChatMessage>> getChatHistory() async {
    await Future.delayed(Duration(milliseconds: 300 + Random().nextInt(300)));

    return [
      ChatMessage(
        sender: 'user',
        message: 'What is Flutter?',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      ChatMessage(
        sender: 'assistant',
        message:
            'Flutter is an open-source UI toolkit by Google for building natively compiled applications for mobile, web, and desktop from a single codebase.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      ChatMessage(
        sender: 'user',
        message: 'How does state management work?',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      ChatMessage(
        sender: 'assistant',
        message:
            'Flutter state management helps you manage UI updates efficiently. Popular approaches include Provider, Riverpod, BLoC/Cubit, GetX, and MobX.',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ];
  }
}
