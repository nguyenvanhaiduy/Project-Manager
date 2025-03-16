import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool> customDialog({
  GlobalKey<FormState>? formKey,
  required String title,
  Widget? child,
  required Function() onPress,
}) async {
  bool isDelete = false;
  await Get.dialog(
    Center(
      child: Material(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(10),
          width: 300,
          height: 180,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Get.isDarkMode ? Colors.black : Colors.white,
                blurRadius: 10,
              )
            ],
            color: Get.isDarkMode ? Colors.black54 : Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(title.tr),
                child ?? const SizedBox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        // : Colors.white,
                        backgroundColor:
                            const Color.fromARGB(255, 213, 213, 213),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        'close'.tr,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        backgroundColor: const Color.fromARGB(255, 3, 107, 224),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        isDelete = true;
                        onPress();
                        Get.back();
                      },
                      child: Text('confirm'.tr),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ),
  );
  return isDelete;
}
