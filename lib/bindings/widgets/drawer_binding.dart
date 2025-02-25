import 'package:get/get.dart';
import 'package:project_manager/controllers/auth/drawer_controller.dart';

class DrawerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DrawerrController>(() => DrawerrController(), fenix: true);
  }
}
