import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_assistant/core/theme/app_theme.dart';
import 'package:smart_assistant/features/chat/presentation/pages/chat_screen.dart';
import 'package:smart_assistant/features/history/presentation/pages/history_screen.dart';
import 'package:smart_assistant/features/navigation/presentation/controller/navigation_controller.dart';
import 'package:smart_assistant/features/suggestions/presentation/pages/home_screen.dart';

class NavigationShell extends StatelessWidget {
  const NavigationShell({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navController = Get.put(NavigationController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    const screens = [
      HomeScreen(),
      ChatScreen(),
      HistoryScreen(),
    ];

    return Obx(() {
      final index = navController.currentIndex.value;

      return Scaffold(
        extendBody: true,
        body: IndexedStack(
          index: index,
          children: screens,
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkCard.withOpacity(0.95)
                : Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryStart.withOpacity(0.08),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(
                    icon: Icons.lightbulb_outline,
                    activeIcon: Icons.lightbulb,
                    label: 'Explore',
                    isActive: index == 0,
                    onTap: () => navController.changePage(0),
                  ),
                  _NavItem(
                    icon: Icons.chat_bubble_outline_rounded,
                    activeIcon: Icons.chat_bubble_rounded,
                    label: 'Chat',
                    isActive: index == 1,
                    onTap: () => navController.changePage(1),
                  ),
                  _NavItem(
                    icon: Icons.schedule_outlined,
                    activeIcon: Icons.schedule_rounded,
                    label: 'History',
                    isActive: index == 2,
                    onTap: () => navController.changePage(2),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 20 : 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          gradient: isActive ? AppColors.primaryGradient : null,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              size: 22,
              color: isActive
                  ? Colors.white
                  : Theme.of(context).textTheme.bodySmall?.color,
            ),
            if (isActive) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
