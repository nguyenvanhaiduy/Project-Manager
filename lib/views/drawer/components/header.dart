import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'project manager'.tr,
      style: Get.textTheme.bodyLarge!
          .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}
