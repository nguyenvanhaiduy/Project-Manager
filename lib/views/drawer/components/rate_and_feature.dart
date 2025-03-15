import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/controllers/auth/drawer_controller.dart';
import 'package:project_manager/views/widgets/widgets.dart';

class RateAndFeature extends StatelessWidget {
  RateAndFeature({super.key});

  final DrawerrController drawerController = Get.find();

  void _handleRateUsAction() {
    drawerController.changeIndex('4');
    // Get.back();
    // Get.defaultDialog(onCancel: () => Get.back(), onConfirm: () => Get.back());
  }

  void _handleFeatureRequestAction() {
    drawerController.changeIndex('5');
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
        child: Column(
          children: [
            customListTile(
              'rate us'.tr,
              '4',
              const Icon(Icons.star_rate_rounded),
              const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              () => _handleRateUsAction(),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 20,
              ),
            ),
            const Divider(
              thickness: 0,
              height: 0,
            ),
            customListTile(
              'feature request'.tr,
              '5',
              const ImageIcon(
                AssetImage('assets/icons/icons8-orthogonal-view-96.png'),
              ),
              const BorderRadius.vertical(bottom: Radius.circular(10)),
              () => _handleFeatureRequestAction(),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 20,
              ),
            )
          ],
        ),
      ),
    );
  }
}
