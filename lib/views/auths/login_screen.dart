import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/controllers/auth/auth_controller.dart';
import 'package:project_manager/controllers/theme_controller.dart';
import 'package:project_manager/views/auths/forgot_password.dart';
import 'package:project_manager/views/auths/register_screen.dart';
import 'package:project_manager/views/drawer/custom_drawer.dart';
import 'package:project_manager/views/widgets/widgets.dart';

final _authController = Get.find<AuthController>();

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ThemeController themeController = Get.find();

  // final emailRegex =
  //     RegExp(r'^[{0-9}{a-z}{A-Z}.]+@[{0-9}{a-z}{A-Z}]+\.[{0-9}{a-z}{A-Z}]+$');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: CustomDrawer(),
      body: Center(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(() {
                  return _buildUserProfileAvatar();
                }),
                const SizedBox(height: 50),
                SizedBox(
                  width: Get.size.width > 800
                      ? MediaQuery.of(context).size.width * 0.7
                      : null,
                  child: Center(
                    child: Column(
                      children: [
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
                          themeController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),
                        Obx(() => customTextField(context, _passwordController,
                                'password', Icons.lock_outline,
                                obscureText:
                                    _authController.isShowPassword.value,
                                suffixIcon: _authController.isShowPassword.value
                                    ? Icons.remove_red_eye
                                    : Icons.remove_red_eye_outlined, (value) {
                              if (value == null || value.isEmpty) {
                                return 'you must enter password'.tr;
                              }
                              if (value.length < 6) {
                                return 'password must be greater than 6 characters'
                                    .tr;
                              }
                              return null;
                            }, themeController)),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          width: double.infinity,
                          height: kIsWeb ? 50 : null,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                Get.closeAllSnackbars();
                                await _authController
                                    .signInWithEmailAndPassword(
                                        _emailController.text,
                                        _passwordController.text);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(15)),
                            child: Text('login'.tr),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MaterialButton(
                                onPressed: () {
                                  Get.to(
                                    () => RegisterScreen(),
                                  );
                                },
                                child: Text('register'.tr),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  Get.to(() => ForgotPasswordScreen());
                                },
                                child: Text('forgot password'.tr),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 150),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfileAvatar() {
    if (_authController.currentUser.value?.imageUrl != null) {
      return CircleAvatar(
        minRadius: 30,
        maxRadius: 50,
        backgroundImage:
            NetworkImage(_authController.currentUser.value!.imageUrl!),
        onBackgroundImageError: (_, __) => const Icon(
          Icons.account_circle,
          size: 50,
          color: Colors.grey,
        ),
      );
    } else if (_authController.currentUser.value?.color != null &&
        _authController.currentUser.value?.name != null) {
      return CircleAvatar(
        minRadius: 30,
        maxRadius: 50,
        backgroundColor: _authController.currentUser.value!.color,
        child: Text(
          _authController.currentUser.value!.name[0].toUpperCase(),
          style: const TextStyle(fontSize: 40),
        ),
      );
    } else {
      return const CircleAvatar(
        minRadius: 30,
        maxRadius: 50,
        backgroundImage: AssetImage('assets/images/logo.png'),
      );
    }
  }
}
