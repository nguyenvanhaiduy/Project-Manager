import 'package:get/get.dart';

class DrawerrController extends GetxController {
  var selectedIndex = '1'.obs;

  void changeIndex(String value) {
    selectedIndex.value = value;
  }
}
