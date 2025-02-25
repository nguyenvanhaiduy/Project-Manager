import 'package:get/get.dart';
import 'package:project_manager/controllers/task/task_controller.dart';

class ProgressProjectController extends GetxController {
  final TaskController taskController = Get.find<TaskController>();

  RxDouble currentValue = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
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
