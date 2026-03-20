import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_assistant/chat/application/controllers/chat_controller.dart';
import 'package:smart_assistant/chat/presentation/widgets/chat_bubble.dart';
import 'package:smart_assistant/chat/presentation/widgets/chat_input.dart';
import 'package:smart_assistant/chat/presentation/widgets/typing_indicator.dart';
import 'package:smart_assistant/common/themes/app_theme.dart';

class ChatScreen extends StatefulWidget {
  final String? initialMessage;

  const ChatScreen({Key? key, this.initialMessage}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _scrollController = ScrollController();
  late final ChatController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<ChatController>();
    ever(_controller.messages, (_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showClearSheet(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Clear Conversation'),
          content: const Text(
            'Are you sure you want to clear all messages? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _controller.clearChat();
                Navigator.pop(dialogContext);
              },
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Column(
        children: [
          // Custom app bar with gradient accent
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              left: 20,
              right: 12,
              bottom: 12,
            ),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: isDark
                      ? AppColors.darkDivider
                      : AppColors.lightDivider.withOpacity(0.5),
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryStart.withOpacity(0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Smart Assistant',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Obx(() {
                        if (_controller.isSending.value) {
                          return Row(
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryStart,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Thinking...',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.primaryStart,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          );
                        }
                        return Row(
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                color: AppColors.success,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Online',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.success,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _showClearSheet(context),
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),

          // Messages
          Expanded(
            child: Obx(() {
              if (_controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (_controller.messages.isEmpty) {
                return _buildEmptyChat(context);
              }

              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                itemCount: _controller.messages.length +
                    (_controller.isSending.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _controller.messages.length) {
                    return const TypingIndicator();
                  }
                  return ChatBubble(message: _controller.messages[index]);
                },
              );
            }),
          ),

          // Input
          Obx(() => ChatInput(
                onSend: (msg) => _controller.sendMessage(msg),
                isLoading: _controller.isSending.value,
              )),
        ],
      ),
    );
  }

  Widget _buildEmptyChat(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryStart.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.chat_rounded,
              size: 44,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Start a Conversation',
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 10),
          Text(
            'Ask me anything! I\'m your AI assistant\nready to help with any question.',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 36),
          Text(
            'Try asking',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _QuickChip(
                text: 'What is Flutter?',
                onTap: () => _controller.sendMessage('What is Flutter?'),
                isDark: isDark,
              ),
              _QuickChip(
                text: 'Explain state management',
                onTap: () =>
                    _controller.sendMessage('Explain state management'),
                isDark: isDark,
              ),
              _QuickChip(
                text: 'Help with Dart',
                onTap: () => _controller.sendMessage('Help with Dart'),
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickChip extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isDark;

  const _QuickChip({
    required this.text,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkCard
              : AppColors.primaryStart.withOpacity(0.06),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primaryStart.withOpacity(isDark ? 0.2 : 0.15),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: AppColors.primaryStart,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
