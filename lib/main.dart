import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project_manager/bindings/auth_binding.dart';
import 'package:project_manager/bindings/drawer_binding.dart';
import 'package:project_manager/bindings/image_picker_binding.dart';
import 'package:project_manager/bindings/language_binding.dart';
import 'package:project_manager/bindings/theme_binding.dart';
import 'package:project_manager/firebase_options.dart';
import 'package:project_manager/utils/app_constants.dart';
import 'package:project_manager/utils/app_translations.dart';
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
      title: 'Project Manager',
      theme: ThemeData.light().copyWith(
        appBarTheme: const AppBarTheme(backgroundColor: kbackgroundLightColor),
        scaffoldBackgroundColor: kbackgroundLightColor,
        textTheme: const TextTheme().copyWith(
            bodyMedium: const TextStyle(
              color: Colors.black,
            ),
            bodyLarge: const TextStyle(
              color: Colors.black,
            ),
            bodySmall: const TextStyle(
              color: Colors.black,
            ),
            headlineLarge: const TextStyle(
              color: Colors.black,
            )),
        cardTheme: const CardTheme().copyWith(
          color: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateColor.resolveWith(
              (states) => const Color.fromARGB(255, 91, 98, 143),
            ),
            foregroundColor: MaterialStateColor.resolveWith(
              (states) => Colors.white,
            ),
          ),
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: kbackgroundLightColor,
        ),
        listTileTheme: const ListTileThemeData(
          // selectedColor: Colors.amber,
          selectedTileColor: Colors.orange,
          selectedColor: Colors.black,
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateColor.resolveWith(
              (states) => Colors.black,
            ),
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        appBarTheme: const AppBarTheme(backgroundColor: kbackgroundDarkColor),
        scaffoldBackgroundColor: kbackgroundDarkColor,
        textTheme: const TextTheme().copyWith(
            bodyMedium: const TextStyle(
              color: Colors.white,
              // fontWeight: FontWeight.bold,
            ),
            bodyLarge: const TextStyle(
              color: Colors.white,
              // fontWeight: FontWeight.bold,
            ),
            bodySmall: const TextStyle(
              color: Colors.white,
              // fontWeight: FontWeight.bold,
            ),
            headlineLarge: const TextStyle(
              color: Colors.white,
            )),
        cardTheme: const CardTheme().copyWith(
          color: Colors.black54,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateColor.resolveWith(
              (states) => const Color.fromARGB(255, 31, 57, 111), // Màu tối
            ),
            foregroundColor: MaterialStateColor.resolveWith(
              (states) => Colors.white, // Màu chữ
            ),
          ),
        ),
        listTileTheme: const ListTileThemeData(
          // selectedColor: Colors.amber,
          selectedTileColor: Colors.orange,
          selectedColor: Colors.white,
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: kbackgroundDarkColor,
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateColor.resolveWith(
              (states) => Colors.white,
            ),
          ),
        ),
      ),
      initialBinding: BindingsBuilder(() {
        ThemeBinding().dependencies();
        AuthBinding().dependencies();
        DrawerBinding().dependencies();
        LanguageBinding().dependencies();
        ImagePickerBinding().dependencies();
        // AppwriteBinding().dependencies();
      }),
      home: const SplashScreen(),
      translations: AppTranslations(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('vi', 'VN'),
    );
  }
}
