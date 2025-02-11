import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSnackbar(String title, String message,
    {Color? colorText, int duration = 2, SnackPosition? position}) {
  Get.closeAllSnackbars();
  Get.snackbar(
    title,
    message,
    colorText: colorText,
    duration: Duration(seconds: duration),
    snackPosition: position,
  );
}
