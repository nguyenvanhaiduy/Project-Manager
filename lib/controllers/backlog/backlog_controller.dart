import 'package:get/get.dart';

class BacklogController extends GetxController {
  RxBool isOpen = false.obs;

  void toggleOpen() {
    isOpen.value = !isOpen.value;
  }
}
