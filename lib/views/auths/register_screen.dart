import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:project_manager/controllers/auth/auth_controller.dart';
import 'package:project_manager/controllers/auth/image_picker_controller.dart';
import 'package:project_manager/controllers/theme_controller.dart';
import 'package:project_manager/views/widgets/widgets.dart';

final _authController = Get.find<AuthController>();

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _jobController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _themeController = Get.find<ThemeController>();
  final _imagePickerControler = Get.find<ImagePickerController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: SizedBox(
            width: Get.size.width > 800
                ? MediaQuery.of(context).size.width * 0.7
                : null,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      _imagePickerControler.showImageSourceDialog(context);
                    },
                    child: Obx(
                      () {
                        if (_imagePickerControler.image.value != null) {
                          return CircleAvatar(
                            minRadius: 20,
                            maxRadius: 50,
                            backgroundImage:
                                FileImage(_imagePickerControler.image.value!),
                          );
                        } else if (kIsWeb) {
                          if (_imagePickerControler.webImage.value != null) {
                            return CircleAvatar(
                              minRadius: 20,
                              maxRadius: 50,
                              backgroundImage: MemoryImage(
                                  _imagePickerControler.webImage.value!),
                            );
                          }
                        }
                        return const CircleAvatar(
                          minRadius: 20,
                          maxRadius: 50,
                          backgroundImage: AssetImage('assets/images/logo.png'),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  customTextField(context, _nameController, 'fullname',
                      Icons.person_outline, (value) {
                    if (value == null || value.isEmpty) {
                      return 'you must enter your full name'.tr;
                    }
                    return null;
                  }, _themeController),
                  const SizedBox(height: 20),
                  customTextField(
                      context, _jobController, 'job', Icons.work_outline,
                      (value) {
                    if (value == null || value.isEmpty) {
                      return 'you must enter your job'.tr;
                    }
                    return null;
                  }, _themeController),
                  const SizedBox(height: 20),
                  // const Spacer(),
                  customTextField(
                    context,
                    _emailController,
                    'email',
                    Icons.email_outlined,
                    (value) {
                      if (value == null || value.isEmpty) {
                        return 'you must enter your email'.tr;
                      }

                      if (!GetUtils.isEmail(value)) {
                        return 'you must enter a valid email'.tr;
                      }
                      return null;
                    },
                    _themeController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),

                  Obx(() => customTextField(context, _passwordController,
                          'password', Icons.lock_outline,
                          obscureText: _authController.isShowPassword.value,
                          suffixIcon: _authController.isShowPassword.value
                              ? Icons.remove_red_eye
                              : Icons.remove_red_eye_outlined, (value) {
                        if (value == null || value.isEmpty) {
                          return 'you must enter password'.tr;
                        }
                        if (value.length < 8) {
                          return 'password must be greater than 8 characters'
                              .tr;
                        }
                        if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z]).{8,}$')
                            .hasMatch(value)) {
                          return 'password must contain at least 1 uppercase and 1 lowercase letter'
                              .tr;
                        }
                        return null;
                      }, _themeController)),
                  const SizedBox(height: 20),
                  Obx(
                    () => customTextField(context, _confirmPasswordController,
                        'confirm password'.tr, Icons.lock_outline,
                        obscureText: _authController.isShowPassword.value,
                        suffixIcon: _authController.isShowPassword.value
                            ? Icons.remove_red_eye
                            : Icons.remove_red_eye_outlined, (value) {
                      if (value == null || value.isEmpty) {
                        return 'you must enter confirm password'.tr;
                      }
                      if (value != _passwordController.text) {
                        return 'password and confirm password must be same'.tr;
                      }
                      return null;
                    }, _themeController),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    width: double.infinity,
                    height: kIsWeb ? 50 : null,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _authController.goToVerificationScreen(
                            _nameController.text,
                            _jobController.text,
                            _imagePickerControler.image.value,
                            _imagePickerControler.webImage.value,
                            _emailController.text,
                            _passwordController.text,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(15)),
                      child: Text('register'.tr),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('You have already an account?'.tr),
                        MaterialButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text('login'.tr),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
