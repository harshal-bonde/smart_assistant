import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:smart_assistant/common/themes/theme_controller.dart';

void main() {
  late ThemeController controller;

  setUp(() {
    Get.testMode = true;
    controller = ThemeController();
  });

  tearDown(() {
    Get.reset();
  });

  group('ThemeController', () {
    test('initial theme mode is light', () {
      expect(controller.themeMode, ThemeMode.light);
      expect(controller.isDark, isFalse);
    });

    test('toggleTheme switches from light to dark', () {
      controller.toggleTheme();
      expect(controller.themeMode, ThemeMode.dark);
      expect(controller.isDark, isTrue);
    });

    test('toggleTheme switches back from dark to light', () {
      controller.toggleTheme(); // light -> dark
      controller.toggleTheme(); // dark -> light
      expect(controller.themeMode, ThemeMode.light);
      expect(controller.isDark, isFalse);
    });
  });
}
