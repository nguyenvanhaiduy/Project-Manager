import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/controllers/auth/auth_controller.dart';
import 'package:project_manager/controllers/auth/image_picker_controller.dart';
import 'package:project_manager/controllers/theme_controller.dart';
import 'package:project_manager/models/user.dart';
import 'package:project_manager/utils/color_utils.dart';
import 'package:project_manager/views/widgets/widgets.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final ImagePickerController _imagePickerController = Get.find();
  final AuthController _authController = Get.find();
  final ThemeController _themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    User? user = _authController.currentUser.value;
    if (user == null) return Container();
    final nameController = TextEditingController(text: user.name);
    final jobController = TextEditingController(text: user.job);
    final phoneController = TextEditingController(text: user.phone);
    final emailController = TextEditingController(text: user.email);
    final originalImage = _imagePickerController.image.value;
    final originalWebImage = _imagePickerController.webImage.value;

    return Scaffold(
      appBar: AppBar(
        title: Text('personal data'.tr),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: Get.size.width > 800
                ? MediaQuery.of(context).size.width * 0.7
                : null,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    _imagePickerController.showImageSourceDialog(context);
                  },
                  child: Hero(
                    tag: 'card',
                    child: Obx(
                      () => _imagePickerController.image.value != null
                          ? CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.red,
                              backgroundImage: FileImage(
                                  _imagePickerController.image.value!),
                            )
                          : (_imagePickerController.webImage.value != null
                              ? CircleAvatar(
                                  radius: 50,
                                  backgroundImage: MemoryImage(
                                      _imagePickerController.webImage.value!),
                                )
                              : user.imageUrl != null
                                  ? CircleAvatar(
                                      radius: 50,
                                      backgroundImage: NetworkImage(
                                        _authController
                                            .currentUser.value!.imageUrl!,
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 50,
                                      backgroundColor: user.color,
                                      foregroundColor:
                                          getContrastingTextColor(user.color!),
                                      child: Text(
                                        _authController
                                            .currentUser.value!.name[0]
                                            .toUpperCase(),
                                        style: const TextStyle(fontSize: 40),
                                      ),
                                    )),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                customTextField(
                  context,
                  nameController,
                  'fullname'.tr,
                  Icons.person_outline,
                  (value) => null,
                  _themeController,
                ),
                const SizedBox(height: 20),
                customTextField(
                  context,
                  jobController,
                  'job'.tr,
                  Icons.work_outline,
                  (value) => null,
                  _themeController,
                ),
                const SizedBox(height: 20),
                customTextField(
                  context,
                  phoneController,
                  'phone'.tr,
                  Icons.phone_outlined,
                  (value) => null,
                  _themeController,
                ),
                const SizedBox(height: 20),
                customTextField(
                  context,
                  emailController,
                  'email',
                  Icons.email_outlined,
                  (value) => null,
                  _themeController,
                  readOnly: true,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () async {
                      bool hasChanges = _authController
                                  .currentUser.value!.name !=
                              nameController.text.trim() ||
                          _authController.currentUser.value!.job !=
                              jobController.text.trim() ||
                          _authController.currentUser.value!.phone !=
                              phoneController.text.trim() ||
                          originalImage != _imagePickerController.image.value ||
                          originalWebImage !=
                              _imagePickerController.webImage.value;
                      if (hasChanges) {
                        await _authController.updateUser(
                          name: nameController.text,
                          job: jobController.text,
                          phone: phoneController.text,
                          image: _imagePickerController.image.value,
                          imageWeb: _imagePickerController.webImage.value,
                        );
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.change_circle,
                          size: 30,
                        ),
                        const SizedBox(width: 6),
                        Text('update'.tr),
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
}
