import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/controllers/auth/auth_controller.dart';
import 'package:project_manager/controllers/auth/drawer_controller.dart';
import 'package:project_manager/routers/app_routers.dart';
// import 'package:project_manager/views/widgets/tag/tag_screen.dart';
import 'package:project_manager/views/widgets/widgets.dart';

class TagTile extends StatelessWidget {
  TagTile({super.key});

  final DrawerrController drawerController = Get.find();
  final AuthController authController = Get.find();

  void _handleTagAction() {
    drawerController.changeIndex('1');
    Get.toNamed(AppRouters.tag);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.hardEdge,
      child: Material(
        color: Get.isDarkMode ? Colors.black54 : Colors.white,
        child: authController.isLogout.value
            ? Container()
            : customListTile(
                'tag'.tr,
                '1',
                const ImageIcon(
                  AssetImage('assets/icons/icons8-tag-96.png'),
                ),
                BorderRadius.circular(10),
                () => _handleTagAction(),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                ),
              ),
      ),
    );
  }
}
