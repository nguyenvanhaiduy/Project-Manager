import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingOverlay {
  static void show() {
    Get.dialog(
      barrierDismissible: false,
      const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  static Future<void> hide() async {
    try {
      if (Get.isDialogOpen == true) {
        Get.back();
      }
    } catch (e) {
      print('Error hiding loading overlay: $e');
    }
  }
}
