import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project_manager/bindings/initial_binding.dart';
import 'package:project_manager/firebase_options.dart';
import 'package:project_manager/routers/app_pages.dart';
import 'package:project_manager/utils/app_translations.dart';
import 'package:project_manager/utils/theme.dart';
import 'package:project_manager/views/auths/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //  khởi tạo tất cả các kết nối framework cần thiết cho việc sử dụng các plugins.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Project Manager',
      theme: lightTheme(),
      darkTheme: darkTheme(),
      initialBinding: InitialBinding(),
      home: const SplashScreen(),
      translations: AppTranslations(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('vi', 'VN'),
      initialRoute: '/',
      getPages: AppPages.pages,
    );
  }
}
