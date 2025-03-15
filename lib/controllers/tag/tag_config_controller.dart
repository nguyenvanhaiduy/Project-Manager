import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TagConfigController extends GetxController {
  final isActive = false.obs;

  final RxList<RxBool> tagConfirmed =
      <RxBool>[].obs; // Thêm RxBool để theo dõi trạng thái

  final RxList<FocusNode> focusNodes = <FocusNode>[].obs; // Add focus nodes

  final RxList<RxBool> isValids = <RxBool>[].obs;

  final RxList<TextEditingController> tagEdittingController =
      <TextEditingController>[].obs;

  void chageActive() {
    isActive.value = !isActive.value;
  }

  void addTag() {
    isActive.value = true;
    final newController = TextEditingController();
    tagEdittingController.add(newController);
    final newFocusNode = FocusNode();
    focusNodes.add(newFocusNode);
    tagConfirmed.add(false.obs); // Mặc định là chưa xác nhận
    isValids.add(false.obs);
  }

  void confirmTag(int index) {
    tagConfirmed[index].value = true; // Đánh dấu là đã xác nhận
  }

  void removeTag(int index) {
    tagEdittingController.removeAt(index);
    tagConfirmed.removeAt(index); // Xóa cả trạng thái xác nhận
    isValids.removeAt(index);
  }
}
