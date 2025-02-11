import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/controllers/theme_controller.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Obx(
        () {
          return Column(
            children: [
              RadioListTile(
                title: const Text('Light Mode'),
                value: ThemeMode.light,
                groupValue: themeController.themeMode.value,
                onChanged: (ThemeMode? value) {
                  if (value != null) {
                    themeController.setThemeMode(value);
                  }
                },
              ),
              RadioListTile(
                title: const Text('Dark Mode'),
                value: ThemeMode.dark,
                groupValue: themeController.themeMode.value,
                onChanged: (ThemeMode? value) {
                  if (value != null) {
                    themeController.setThemeMode(value);
                  }
                },
              ),
              RadioListTile(
                title: const Text('System Default'),
                value: ThemeMode.system,
                groupValue: themeController.themeMode.value,
                onChanged: (ThemeMode? value) {
                  if (value != null) {
                    themeController.setThemeMode(value);
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
