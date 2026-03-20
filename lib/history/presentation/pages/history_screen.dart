import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_assistant/common/themes/app_theme.dart';
import 'package:smart_assistant/chat/domain/data_class/chat_message.dart';
import 'package:smart_assistant/history/application/controllers/history_controller.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final controller = Get.find<HistoryController>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.fromLTRB(
                20,
                MediaQuery.of(context).padding.top + 16,
                20,
                20,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Chat History',
                          style: theme.textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 4),
                        Obx(() => Text(
                              controller.messages.isEmpty
                                  ? 'No conversations yet'
                                  : '${controller.messages.length} messages',
                              style: theme.textTheme.bodyMedium,
                            )),
                      ],
                    ),
                  ),
                  Obx(() {
                    if (controller.messages.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return GestureDetector(
                      onTap: () => _showClearSheet(context, controller),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.delete_outline_rounded,
                          color: AppColors.error,
                          size: 22,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          // Content
          Obx(() {
            if (controller.isLoading.value) {
              return const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (controller.errorMessage.value != null &&
                controller.messages.isEmpty) {
              return SliverFillRemaining(
                child: _buildErrorState(context, controller),
              );
            }

            if (controller.messages.isEmpty) {
              return SliverFillRemaining(
                child: _buildEmptyState(context),
              );
            }

            return SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final message = controller.messages[index];
                    final showDateHeader = index == 0 ||
                        !_isSameDay(
                          controller.messages[index - 1].timestamp,
                          message.timestamp,
                        );

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (showDateHeader)
                          Padding(
                            padding: EdgeInsets.only(
                              top: index == 0 ? 0 : 16,
                              bottom: 10,
                            ),
                            child: _DateBadge(
                              date: message.timestamp,
                              isDark: isDark,
                            ),
                          ),
                        _HistoryCard(
                          message: message,
                          isDark: isDark,
                        ),
                      ],
                    );
                  },
                  childCount: controller.messages.length,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                gradient: AppColors.accentGradient,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.schedule_rounded,
                size: 44,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            Text('No History Yet', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 10),
            Text(
              'Your conversations will appear here\nafter you start chatting.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, HistoryController controller) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                size: 40,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              controller.errorMessage.value ?? 'Something went wrong',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: controller.loadHistory,
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearSheet(BuildContext context, HistoryController controller) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Clear History'),
          content: const Text(
            'Are you sure you want to clear all chat history? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                controller.clearHistory();
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
}

class _DateBadge extends StatelessWidget {
  final DateTime date;
  final bool isDark;

  const _DateBadge({required this.date, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;
    final isYesterday = date.year == now.year &&
        date.month == now.month &&
        date.day == now.day - 1;

    String label;
    if (isToday) {
      label = 'Today';
    } else if (isYesterday) {
      label = 'Yesterday';
    } else {
      label = DateFormat('MMM d, yyyy').format(date);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurface
            : AppColors.primaryStart.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryStart,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final ChatMessage message;
  final bool isDark;

  const _HistoryCard({required this.message, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = message.isUser;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUser
              ? AppColors.primaryStart.withOpacity(isDark ? 0.2 : 0.12)
              : isDark
                  ? AppColors.darkDivider
                  : AppColors.lightDivider.withOpacity(0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: isUser ? AppColors.primaryGradient : null,
              color: isUser ? null : AppColors.accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isUser ? Icons.person_rounded : Icons.auto_awesome_rounded,
              size: 18,
              color: isUser ? Colors.white : AppColors.accent,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      isUser ? 'You' : 'Assistant',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontSize: 13,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      DateFormat('h:mm a').format(message.timestamp),
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  message.message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 13,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
