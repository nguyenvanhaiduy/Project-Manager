import 'package:get/get.dart';

class SearchingController extends GetxController {
  final RxBool isSearching = false.obs;

  @override
  void onInit() {
    super.onInit();
    isSearching.value = false;
  }
}
