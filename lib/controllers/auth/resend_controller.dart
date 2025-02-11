import 'package:get/get.dart';

class ResendController extends GetxController {
  final RxBool isResendActive = false.obs;
  final RxInt time = 120.obs;

  void startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      time.value--;
      if (time.value > 0) {
        startTimer();
      } else {
        isResendActive.value = true;
      }
    });
  }

  void resetTimer() {
    isResendActive.value = false;
    time.value = 120;
  }
}
