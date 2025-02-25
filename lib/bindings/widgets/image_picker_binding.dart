import 'package:get/get.dart';
import 'package:project_manager/controllers/auth/image_picker_controller.dart';

class ImagePickerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ImagePickerController(), fenix: true);
  }
}
