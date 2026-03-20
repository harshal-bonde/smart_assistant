import 'package:flutter/material.dart';
import 'package:smart_assistant/common/themes/app_theme.dart';
import 'package:smart_assistant/suggestions/domain/data_class/suggestion.dart';

class SuggestionCard extends StatelessWidget {
  final Suggestion suggestion;
  final VoidCallback onTap;

  const SuggestionCard({
    Key? key,
    required this.suggestion,
    required this.onTap,
  }) : super(key: key);

  static const _gradients = [
    [Color(0xFF667EEA), Color(0xFF764BA2)],
    [Color(0xFF00D2FF), Color(0xFF3A7BD5)],
    [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
    [Color(0xFF11998E), Color(0xFF38EF7D)],
    [Color(0xFFF093FB), Color(0xFFF5576C)],
    [Color(0xFFFFD194), Color(0xFFD1913C)],
    [Color(0xFF4FACFE), Color(0xFF00F2FE)],
    [Color(0xFFA18CD1), Color(0xFFFBC2EB)],
  ];

  List<Color> get _gradient => _gradients[suggestion.id % _gradients.length];

  IconData get _icon {
    final icons = [
      Icons.auto_awesome_rounded,
      Icons.mail_rounded,
      Icons.translate_rounded,
      Icons.spellcheck_rounded,
      Icons.edit_rounded,
      Icons.code_rounded,
      Icons.school_rounded,
      Icons.checklist_rounded,
      Icons.article_rounded,
      Icons.psychology_rounded,
    ];
    return icons[suggestion.id % icons.length];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? AppColors.darkDivider
                : AppColors.lightDivider.withOpacity(0.5),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _gradient[0].withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(_icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    suggestion.title,
                    style: theme.textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    suggestion.description,
                    style: theme.textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.06)
                    : AppColors.primaryStart.withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                size: 18,
                color: AppColors.primaryStart,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
