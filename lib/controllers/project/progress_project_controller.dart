import 'package:get/get.dart';

class ProgressProjectController extends GetxController {
  final double targetValue;
  RxDouble currentValue = 0.0.obs;

  ProgressProjectController({required this.targetValue});

  @override
  void onInit() {
    super.onInit();
    animateToValue();
  }

  void animateToValue() async {
    await Future.delayed(const Duration(milliseconds: 500));
    for (double i = 0.0; i < targetValue; i += 0.01) {
      await Future.delayed(const Duration(milliseconds: 10));
      currentValue.value = i;
    }
    currentValue.value = targetValue;
  }
}
