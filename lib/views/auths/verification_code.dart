import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/controllers/auth/auth_controller.dart';
import 'package:project_manager/controllers/auth/resend_controller.dart';
import 'package:project_manager/views/widgets/widgets.dart';

// ignore: must_be_immutable
class VerificationCode extends StatelessWidget {
  VerificationCode({
    super.key,
    required this.email,
    required this.name,
    required this.job,
    required this.image,
    required this.webImage,
    required this.password,
  });

  final AuthController authController = Get.find();
  final ResendController resendController = Get.put(ResendController());

  final List<TextEditingController> _controllers =
      List.generate(5, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(5, (index) => FocusNode());

  String code = '';

  final String name;
  final String job;
  final File? image;
  final Uint8List? webImage;
  final String email;
  final String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'verification code'.tr,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              Text('we have sent the code verification to'.tr,
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 20),
              Text(email),
              const SizedBox(height: 20),
              SizedBox(
                width: Get.size.width > 800 ? 500 : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    5,
                    (index) => customTextFieldVerify(
                        context,
                        _focusNodes[index],
                        index < 4 ? _focusNodes[index + 1] : null,
                        index > 0 ? _focusNodes[index - 1] : null,
                        _controllers[index], (value) {
                      code = _controllers
                          .map((controller) => controller.text)
                          .join();
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Obx(() {
                if (resendController.isResendActive.value) {
                  authController.currentOtp = '';
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Resend code affter ${authController.time ~/ 60}:${authController.time % 60}',
                    ),
                  ],
                );
              }),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      authController.resendCode(email);
                    },
                    child: Text('resend'.tr),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (kDebugMode) {
                        print(code);
                        print(authController.currentOtp);
                      }

                      if (code == authController.currentOtp) {
                        authController.signUpWithEmailAndPassword(
                          name,
                          job,
                          image,
                          webImage,
                          email,
                          password,
                        );
                      } else {
                        Get.snackbar('Error', 'Incorrect code, try again',
                            colorText: Colors.red);
                      }
                    },
                    child: Text('confirm'.tr),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
