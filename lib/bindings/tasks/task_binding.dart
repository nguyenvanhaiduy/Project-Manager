import 'package:get/get.dart';
import 'package:project_manager/controllers/task/task_controller.dart';

class TaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TaskController(), fenix: true);
  }
}
