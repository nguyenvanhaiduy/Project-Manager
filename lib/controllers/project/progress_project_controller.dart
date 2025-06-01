import 'package:get/get.dart';
import 'package:project_manager/controllers/task/task_controller.dart';

class ProgressProjectController extends GetxController {
  late final TaskController taskController;

  RxDouble currentValue = 0.0.obs;
  int count = 0;

  @override
  void onInit() {
    super.onInit();
    taskController = Get.find<TaskController>();
    animateToValue(taskController.calculateProgress());
  }

  void animateToValue(double targetValue) async {
    await Future.delayed(const Duration(milliseconds: 500));
    for (double i = 0.0; i < targetValue; i += 0.01) {
      await Future.delayed(const Duration(milliseconds: 10));
      currentValue.value = i;
    }
    currentValue.value = targetValue;
  }
}
