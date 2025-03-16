import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/controllers/auth/drawer_controller.dart';
import 'package:project_manager/controllers/language_controller.dart';
import 'package:project_manager/controllers/theme_controller.dart';
import 'package:project_manager/views/widgets/widgets.dart';

class ThemeAndLanguageTile extends StatelessWidget {
  ThemeAndLanguageTile({super.key});

  final DrawerrController drawerController = Get.find();
  final ThemeController themeController = Get.find();
  final LanguageController languageController = Get.find();

  void _handleThemeDialog(Size size) {
    Get.back();
    drawerController.changeIndex('2');
    Get.generalDialog(
      barrierDismissible: true,
      barrierLabel: 'Confirm dialog',
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            borderRadius: BorderRadius.circular(10),
            clipBehavior: Clip.hardEdge,
            child: SizedBox(
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  customTextButton(
                      child: Icon(
                        Icons.light_mode,
                        size: 20,
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                      ),
                      title: 'light',
                      onPress: () {
                        themeController.setThemeMode(ThemeMode.light);
                      },
                      themeMode: ThemeMode.light),
                  const Divider(
                    height: 0,
                    thickness: 0,
                  ),
                  customTextButton(
                      child: Icon(
                        Icons.dark_mode,
                        size: 20,
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                      ),
                      title: 'dark',
                      onPress: () {
                        themeController.setThemeMode(ThemeMode.dark);
                      },
                      themeMode: ThemeMode.dark),
                  const Divider(
                    height: 0,
                    thickness: 0,
                  ),
                  customTextButton(
                    child: Icon(
                      Icons.settings,
                      size: 20,
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                    ),
                    title: 'system',
                    onPress: () {
                      themeController.setThemeMode(ThemeMode.system);
                    },
                    themeMode: ThemeMode.system,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleLanguageDialog(Size size) {
    Get.back();
    drawerController.changeIndex('3');
    Get.dialog(
      barrierDismissible: true,
      Center(
        child: Material(
          borderRadius: BorderRadius.circular(10),
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            width: 200,
            child: Obx(
              () => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  customTextButton(
                      child: Image.asset(
                        'assets/icons/icon_united_kingdom.jpg',
                        width: 30,
                      ),
                      title: 'english',
                      onPress: () {
                        // print(drawerController.selectLanguage.value);
                        languageController
                            .changeLanguage(const Locale('en', 'US'));
                      },
                      name: 'en'),
                  customTextButton(
                      child: Image.asset(
                        'assets/icons/icon_vietname.png',
                        width: 30,
                      ),
                      title: 'vietnamese',
                      onPress: () {
                        // print(drawerController.selectLanguage.value);
                        languageController
                            .changeLanguage(const Locale('vi', 'VN'));
                      },
                      name: 'vi')
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      child: Material(
        color: Get.isDarkMode
            ? const Color.fromARGB(255, 2, 2, 20)
            : const Color.fromARGB(255, 194, 153, 153),
        child: Column(
          children: [
            customListTile(
              'theme'.tr,
              '2',
              const ImageIcon(
                AssetImage('assets/icons/icons8-paint-50.png'),
              ),
              const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              () => _handleThemeDialog(size),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 20,
              ),
            ),
            const Divider(
              height: 0,
              thickness: 0,
            ),
            customListTile(
              'language'.tr,
              '3',
              const Icon(
                Icons.language,
              ),
              const BorderRadius.vertical(
                bottom: Radius.circular(10),
              ),
              () => _handleLanguageDialog(size),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
