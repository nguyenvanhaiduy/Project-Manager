import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/controllers/auth/auth_controller.dart';
import 'package:project_manager/controllers/auth/drawer_controller.dart';
import 'package:project_manager/views/widgets/widgets.dart';

class LogoutTile extends StatelessWidget {
  LogoutTile({super.key});

  final DrawerrController drawerController = Get.find();
  final AuthController authController = Get.find();

  void _handleLogoutAction() {
    drawerController.changeIndex('6');
    authController.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      child: Material(
        color: Get.isDarkMode ? Colors.black54 : Colors.white,
        child: authController.isLogout.value
            ? Container()
            : customListTile(
                'logout'.tr,
                '6',
                const Spacer(),
                BorderRadius.circular(10),
                () => _handleLogoutAction(),
              ),
      ),
    );
  }
}
