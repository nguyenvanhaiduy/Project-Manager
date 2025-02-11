import 'package:get/get.dart';
import 'package:project_manager/controllers/theme_controller.dart';

class ThemeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ThemeController>(() => ThemeController(), fenix: true);
    // với fenix: true thì nếu dependency bị xoá do không còn sử dụng, nó sẽ đươc khởi tạo lại tự động khi cần thiết.
  }
}
