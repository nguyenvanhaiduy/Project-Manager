import 'package:get/get.dart';
import 'package:project_manager/controllers/language_controller.dart';

class LanguageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LanguageController(), fenix: true);
  }
}
