import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/controllers/auth/auth_controller.dart';
import 'package:project_manager/controllers/theme_controller.dart';
import 'package:project_manager/views/widgets/widgets.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final AuthController authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('forgot_password'.tr)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: Get.size.width > 800
                ? MediaQuery.of(context).size.width * 0.7
                : null,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'please enter your email address to receive a password reset link.'
                        .tr
                        .tr,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  customTextField(
                      context, emailController, 'email', Icons.email, (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address'.tr;
                    }
                    if (!GetUtils.isEmail(value)) {
                      return 'Please enter a valid email address'.tr;
                    }
                    return null;
                  }, themeController, keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    width: double.infinity,
                    height: kIsWeb ? 50 : null,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          authController.resetPassword(emailController.text);
                        }
                      },
                      child: Text('send_reset_link'.tr),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
