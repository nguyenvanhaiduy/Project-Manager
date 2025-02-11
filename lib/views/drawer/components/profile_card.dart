import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/controllers/auth/auth_controller.dart';
import 'package:project_manager/utils/color_utils.dart';
import 'package:project_manager/views/profile/profile_screen.dart';

class ProfileCard extends StatelessWidget {
  ProfileCard({super.key});

  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        authController.isLogout.value ? null : Get.to(() => ProfileScreen());
      },
      child: AnimatedContainer(
        duration: const Duration(microseconds: 300),
        curve: Curves.linear,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.black38 : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 0),
              blurRadius: 10,
              color: Colors.black.withOpacity(0.1),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Hero(
                tag: 'card',
                child: Obx(() => _buildUserProfileAvatar()),
              ),
              title: Obx(
                () => Text(
                  authController.currentUser.value?.name ?? 'User',
                  style: Get.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              subtitle: Obx(
                () => Text(authController.currentUser.value?.job ?? 'Job'),
              ),
            ),
            // const Divider(
            //   thickness: 0.5,
            //   indent: 20,
            //   endIndent: 20,
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     TextButton.icon(
            //       onPressed: () {},
            //       label: Text('view'.tr),
            //       icon: const Icon(Icons.remove_red_eye),
            //     ),
            //     TextButton.icon(
            //       onPressed: () {
            //         Get.to(() => ProfileScreen());
            //       },
            //       label: Text('edit'.tr),
            //       icon: const Icon(Icons.edit),
            //     ),
            //   ],
            // ),
            // kIsWeb ? const SizedBox(height: 8) : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfileAvatar() {
    // print(
    //     'authController.currentUser.value?.imageUrl ${authController.currentUser.value?.imageUrl}');
    // print(
    //     'authController.currentUser.value?.color ${authController.currentUser.value?.color}');
    if (authController.currentUser.value?.imageUrl != null) {
      return CircleAvatar(
        minRadius: 20,
        maxRadius: 30,
        backgroundImage:
            NetworkImage(authController.currentUser.value!.imageUrl!),
        onBackgroundImageError: (_, __) => const Icon(Icons.account_circle),
      );
    } else if (authController.currentUser.value?.color != null &&
        authController.currentUser.value?.name != null) {
      return CircleAvatar(
        minRadius: 20,
        maxRadius: 30,
        backgroundColor: authController.currentUser.value!.color,
        foregroundColor:
            getContrastingTextColor(authController.currentUser.value!.color!),
        child: Text(
          authController.currentUser.value!.name[0].toUpperCase(),
        ),
      );
    } else {
      return CircleAvatar(
        minRadius: 20,
        maxRadius: 30,
        backgroundImage: const AssetImage('assets/icons/icon_vietname.png'),
        onBackgroundImageError: (_, __) => const Icon(
          Icons.account_circle,
          size: 30,
        ),
      );
    }
  }
}
