import 'package:get/get.dart';
import 'package:smart_assistant/core/routes/app_routes.dart';
import 'package:smart_assistant/features/chat/presentation/pages/chat_screen.dart';
import 'package:smart_assistant/features/history/presentation/pages/history_screen.dart';
import 'package:smart_assistant/features/navigation/presentation/pages/navigation_shell.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => const NavigationShell(),
    ),
    GetPage(
      name: AppRoutes.chat,
      page: () => const ChatScreen(),
    ),
    GetPage(
      name: AppRoutes.history,
      page: () => const HistoryScreen(),
    ),
  ];
}
