import 'package:get/get.dart';
import 'package:project_manager/bindings/projects/progress_project_binding.dart';
import 'package:project_manager/bindings/projects/project_binding.dart';
import 'package:project_manager/routers/app_routers.dart';
import 'package:project_manager/views/auths/forgot_password.dart';
import 'package:project_manager/views/auths/login_screen.dart';
import 'package:project_manager/views/auths/register_screen.dart';
import 'package:project_manager/views/auths/splash_screen.dart';
import 'package:project_manager/views/auths/verification_code.dart';
import 'package:project_manager/views/home.dart';
import 'package:project_manager/views/profile/profile_screen.dart';
import 'package:project_manager/views/projects/add_project_screen.dart';
import 'package:project_manager/views/projects/project_detail_screen.dart';
import 'package:project_manager/views/projects/project_screen.dart';
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
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: AppRouters.profile,
      page: () => ProfileScreen(),
    ),
    GetPage(
      name: AppRouters.project,
      page: () => ProjectScreen(),
      binding: ProjectBinding(),
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
  ];
}
