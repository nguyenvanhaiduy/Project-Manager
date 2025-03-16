import 'package:get/get.dart';
import 'package:project_manager/bindings/projects/progress_project_binding.dart';
import 'package:project_manager/bindings/projects/project_binding.dart';
import 'package:project_manager/bindings/tags/tag_binding.dart';
import 'package:project_manager/routers/app_routers.dart';
import 'package:project_manager/views/auths/forgot_password.dart';
import 'package:project_manager/views/auths/login_screen.dart';
import 'package:project_manager/views/auths/register_screen.dart';
import 'package:project_manager/views/auths/splash_screen.dart';
import 'package:project_manager/views/auths/verification_code.dart';
import 'package:project_manager/views/pages.dart';
import 'package:project_manager/views/profile/profile_screen.dart';
import 'package:project_manager/views/projects/add_project_screen.dart';
import 'package:project_manager/views/projects/project_detail_screen.dart';
import 'package:project_manager/views/projects/project_screen.dart';
import 'package:project_manager/views/tag/tag_create_or_edit_screen.dart';
import 'package:project_manager/views/tag/tag_screen.dart';
import 'package:project_manager/views/tasks/add_task_screen.dart';
import 'package:project_manager/views/tasks/table_of_mission_screen.dart';
import 'package:project_manager/views/tasks/your_task_screen.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRouters.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRouters.login,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: AppRouters.register,
      page: () => RegisterScreen(),
    ),
    GetPage(
      name: AppRouters.forgotPassword,
      page: () => ForgotPasswordScreen(),
    ),
    GetPage(
      name: AppRouters.home,
      page: () => PagesScreen(),
      binding: ProjectBinding(),
    ),
    GetPage(
      name: AppRouters.profile,
      page: () => ProfileScreen(),
    ),
    GetPage(
      name: AppRouters.project,
      page: () => ProjectScreen(),
    ),
    GetPage(
      name: AppRouters.addProject,
      page: () => AddProjectScreen(),
    ),
    GetPage(
      name: AppRouters.verification,
      page: () => VerificationCode(),
    ),
    GetPage(
      name: AppRouters.projectDetail,
      page: () => ProjectDetailScreen(),
      binding: ProgressProjectBinding(),
    ),
    GetPage(
      name: AppRouters.yourTask,
      page: () => YourTaskScreen(),
    ),
    GetPage(
      name: AppRouters.addTask,
      page: () => AddTaskScreen(),
    ),
    GetPage(
      name: AppRouters.tableOfMission,
      page: () => TableOfMissionScreen(),
    ),
    GetPage(
      name: AppRouters.tag,
      page: () => TagScreen(),
      binding: TagBinding(),
    ),
    GetPage(
      name: AppRouters.addTag,
      page: () => TagCreateOrEditScreen(),
    ),
    GetPage(
      name: AppRouters.editTag,
      page: () => TagCreateOrEditScreen(),
    ),
  ];
}
