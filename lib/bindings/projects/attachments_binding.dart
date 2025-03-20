import 'package:get/get.dart';
import 'package:project_manager/controllers/project/attachments_controller.dart';

class AttachmentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AttachmentsController(), fenix: true);
  }
}
