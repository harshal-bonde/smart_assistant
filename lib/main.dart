import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smart_assistant/config/app_binding.dart';
import 'package:smart_assistant/routes/app_pages.dart';
import 'package:smart_assistant/routes/app_routes.dart';
import 'package:smart_assistant/common/themes/app_theme.dart';
import 'package:smart_assistant/chat/domain/data_class/chat_message.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(ChatMessageAdapter());

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  runApp(const SmartAssistantApp());
}

class SmartAssistantApp extends StatelessWidget {
  const SmartAssistantApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Smart Assistant',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      initialBinding: AppBinding(),
      initialRoute: AppRoutes.home,
      getPages: AppPages.pages,
    );
  }
}
