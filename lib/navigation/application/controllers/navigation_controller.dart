import 'package:get/get.dart';
import 'package:smart_assistant/history/application/controllers/history_controller.dart';

class NavigationController extends GetxController {
  final currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;

    // Refresh history data every time the History tab is selected
    if (index == 2) {
      Get.find<HistoryController>().loadHistory();
    }
  }
}
