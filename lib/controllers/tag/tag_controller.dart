import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/controllers/auth/auth_controller.dart';
import 'package:project_manager/models/tag.dart';
import 'package:project_manager/views/widgets/loading_overlay.dart';

class TagController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final RxList<Tag> tags = <Tag>[].obs;
  final AuthController authController = Get.find();
  @override
  void onInit() {
    super.onInit();
    tags.bindStream(fetchTags());
  }

  Stream<List<Tag>> fetchTags() {
    return firestore
        .collection('tags')
        .where('owner', isEqualTo: authController.currentUser.value!.id)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Tag.fromMap(data: doc.data()))
              .toList(),
        );
  }

  Future<void> createTag(Tag tag) async {
    try {
      LoadingOverlay.show();
      await firestore.collection('tags').doc(tag.id).set(tag.toMap());
      LoadingOverlay.hide();
      Get.snackbar('Success', 'Add tag success', colorText: Colors.green);
    } catch (e) {
      LoadingOverlay.hide();
      Get.closeCurrentSnackbar();
      Get.snackbar('Error', 'Failed to add tag',
          duration: const Duration(seconds: 1));
      debugPrint('Failed to add tag: $e');
    }
  }

  Future<void> editTag(Tag tag) async {
    try {
      LoadingOverlay.show();
      await firestore.collection('tags').doc(tag.id).update(tag.toMap());
      Get.snackbar('Success', 'Add project success', colorText: Colors.green);
      LoadingOverlay.hide();
    } catch (e) {
      LoadingOverlay.hide();
      Get.closeCurrentSnackbar();
      Get.snackbar('Error', 'Failed to edit tag',
          duration: const Duration(seconds: 1));
      if (kDebugMode) print('Failed to edit tag: $e');
    }
  }

  Future<void> deleteTag(String id) async {
    try {
      LoadingOverlay.show();
      await firestore.collection('tags').doc(id).delete();
      Get.snackbar('Success', 'Delete tag success', colorText: Colors.green);
      LoadingOverlay.hide();
    } catch (e) {
      LoadingOverlay.hide();
      Get.closeCurrentSnackbar();
      Get.snackbar('Error', 'Failed to delete tag',
          duration: const Duration(seconds: 1));
      if (kDebugMode) print('Failed to delete tag: $e');
    }
  }
}
