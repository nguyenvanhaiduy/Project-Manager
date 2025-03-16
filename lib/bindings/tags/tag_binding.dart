import 'package:get/get.dart';
import 'package:project_manager/controllers/tag/tag_controller.dart';

class TagBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TagController(), fenix: true);
  }
}
