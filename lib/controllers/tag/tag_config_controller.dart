import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/controllers/tag/tag_controller.dart';
import 'package:project_manager/models/tag.dart';

class TagConfigController extends GetxController {
  TagConfigController({this.tag});

  final Tag? tag;

  final isActive = false.obs;

  final RxList<RxBool> tagConfirmed =
      <RxBool>[].obs; // Thêm RxBool để theo dõi trạng thái

  final RxList<FocusNode> focusNodes = <FocusNode>[].obs; // Add focus nodes

  final RxList<RxBool> isValids = <RxBool>[].obs;

  final RxList<TextEditingController> tagEdittingController =
      <TextEditingController>[].obs;
  final TagController tagController = Get.find();

  @override
  void onInit() {
    if (tag != null) {
      for (var tagi in tag!.tagNames) {
        editTag(tagi);
      }
    }
    super.onInit();
  }

  void chageActive() {
    isActive.value = !isActive.value;
  }

  void addTag({String? text}) {
    isActive.value = true;
    final newController = TextEditingController();
    tagEdittingController.add(newController);
    final newFocusNode = FocusNode();
    focusNodes.add(newFocusNode);
    tagConfirmed.add(false.obs); // Mặc định là chưa xác nhận
    isValids.add(false.obs);
  }

  void editTag(String text) {
    // khởi tạo dữ liệu cho phần edit tag
    isActive.value = false;
    final newController = TextEditingController(text: text);
    tagEdittingController.add(newController);
    final newFocusNode = FocusNode();
    focusNodes.add(newFocusNode);
    tagConfirmed.add(true.obs); // Mặc định là chưa xác nhận
    isValids.add(true.obs);
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
