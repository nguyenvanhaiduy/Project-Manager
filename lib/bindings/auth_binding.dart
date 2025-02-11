import 'package:get/get.dart';
import 'package:project_manager/controllers/auth/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
  }
}
