import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/controllers/auth/drawer_controller.dart';
import 'package:project_manager/controllers/language_controller.dart';
import 'package:project_manager/controllers/theme_controller.dart';
import 'package:project_manager/views/drawer/components/header.dart';
import 'package:project_manager/views/drawer/components/logout_tile.dart';
import 'package:project_manager/views/drawer/components/profile_card.dart';
import 'package:project_manager/views/drawer/components/rate_and_feature.dart';
import 'package:project_manager/views/drawer/components/tag_title.dart';
import 'package:project_manager/views/drawer/components/theme_and_language.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({super.key});

  final DrawerrController drawerController = Get.find();
  final ThemeController themeController = Get.find();
  final LanguageController languageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Drawer(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 100.0),
            child: Column(
              children: [
                const CustomHeader(),
                const SizedBox(height: 10),
                ProfileCard(),
                const SizedBox(height: 10),
                TagTile(),
                const SizedBox(height: 10),
                ThemeAndLanguageTile(),
                const SizedBox(height: 10),
                RateAndFeature(),
                const SizedBox(height: 10),
                LogoutTile(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
