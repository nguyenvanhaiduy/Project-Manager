import 'package:get/get.dart';
import 'package:project_manager/bindings/auth/auth_binding.dart';
import 'package:project_manager/bindings/image_picker_binding.dart';
import 'package:project_manager/bindings/projects/attachments_binding.dart';
import 'package:project_manager/bindings/widgets/drawer_binding.dart';
import 'package:project_manager/bindings/languages/language_binding.dart';
import 'package:project_manager/bindings/tasks/task_binding.dart';
import 'package:project_manager/bindings/theme/theme_binding.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    ThemeBinding().dependencies();
    AuthBinding().dependencies();
    DrawerBinding().dependencies();
    LanguageBinding().dependencies();
    ImagePickerBinding().dependencies();
    TaskBinding().dependencies();
    AttachmentsBinding().dependencies();
  }
}
