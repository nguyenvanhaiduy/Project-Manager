import 'package:get/get.dart';
import 'package:project_manager/controllers/project/progress_project_controller.dart';

class ProgressProjectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProgressProjectController(), fenix: true);
  }
}
