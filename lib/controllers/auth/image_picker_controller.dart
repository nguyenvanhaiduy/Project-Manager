import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_manager/views/widgets/widgets.dart';

class ImagePickerController extends GetxController {
  final Rx<File?> image = Rx<File?>(null);
  final Rx<Uint8List?> webImage = Rx<Uint8List?>(null);

  Future<void> pickImage(ImageSource source) async {
    if (kIsWeb && source == ImageSource.gallery) {
      try {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          allowMultiple: false,
        );
        if (result != null && result.files.isNotEmpty) {
          PlatformFile file = result.files.first;
          if (file.bytes != null) {
            webImage.value = file.bytes;
            image.value = null;
          }
        }
      } catch (e) {
        log('Error loading file from web $e');
        Get.snackbar('Error', 'Error loading file: $e');
      }
    } else {
      try {
        final pickedFile = await ImagePicker().pickImage(source: source);
        if (pickedFile != null) {
          image.value = File(pickedFile.path);
          webImage.value = null;
        }
      } catch (e) {
        log('Error picking image: $e');
        Get.snackbar('Error', 'Error picking image: $e');
      }
    }
  }

  void showImageSourceDialog(BuildContext context) {
    Get.dialog(
        barrierDismissible: true,
        Center(
          child: Material(
            borderRadius: BorderRadius.circular(10),
            clipBehavior: Clip.hardEdge,
            child: SizedBox(
              width: 300,
              child: kIsWeb
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        customTextButton(
                          child: const Icon(Icons.photo_library),
                          title: 'galery'.tr,
                          onPress: () {
                            pickImage(ImageSource.gallery);
                            Get.back();
                          },
                        ),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        customTextButton(
                          child: const Icon(Icons.camera_alt),
                          title: 'camera'.tr,
                          onPress: () {
                            pickImage(ImageSource.camera);
                            Get.back();
                          },
                        ),
                        customTextButton(
                          child: const Icon(Icons.photo_library),
                          title: 'galery'.tr,
                          onPress: () {
                            pickImage(ImageSource.gallery);
                            Get.back();
                          },
                        ),
                      ],
                    ),
            ),
          ),
        ));
  }
}
