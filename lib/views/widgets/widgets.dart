import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:project_manager/controllers/auth/auth_controller.dart';
import 'package:project_manager/controllers/auth/drawer_controller.dart';
import 'package:project_manager/controllers/language_controller.dart';
import 'package:project_manager/controllers/theme_controller.dart';

Widget customTextButton(
    {required Widget child,
    required String title,
    required Function() onPress,
    ThemeMode? themeMode,
    String? name}) {
  final ThemeController themeController = Get.find();
  final LanguageController languageController = Get.find();
  return TextButton(
    style: TextButton.styleFrom(
      shape: const RoundedRectangleBorder(),
      backgroundColor: (themeMode != null
              ? (themeController.themeMode.value == themeMode)
              : (name == languageController.currentLocale.value.languageCode))
          ? const Color.fromARGB(255, 255, 175, 54)
          : null,
    ),
    onPressed: onPress,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          child,
          const SizedBox(width: 10),
          Text(title.tr),
        ],
      ),
    ),
  );
}

Widget customListTile(String title, String id, Widget leading,
    BorderRadiusGeometry borderRadiusGeometry, Function() onPressed,
    {Widget? trailing}) {
  final DrawerrController drawerController = Get.find();
  return Obx(
    () => ListTile(
      key: Key(id),
      title: Text(
        title,
        style: Get.textTheme.bodyLarge!.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onPressed,
      selected: drawerController.selectedIndex.value == id,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(0),
      // ),
      leading: leading,
      trailing: trailing,
    ),
  );
}

Widget customTextField(
  BuildContext context,
  TextEditingController textEditingController,
  String name,
  IconData icon,
  String? Function(String?) onValid,
  ThemeController themeController, {
  RxString? textValue,
  Function()?
      onTap, // để kiểm tra xem nếu bạn là chủ dự án thì có quyền chỉnh sửa
  bool? obscureText = false,
  IconData? suffixIcon,
  TextInputType keyboardType = TextInputType.text,
  bool readOnly = false,
}) {
  final AuthController authController = Get.find();
  return Container(
    decoration: BoxDecoration(
      color: Theme.of(Get.context!).brightness == Brightness.light
          ? Colors.white
          : Colors.white10,
      borderRadius: BorderRadius.circular(20),
    ),
    margin: const EdgeInsets.symmetric(horizontal: 14.0),
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Text(
            name.tr,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                readOnly: readOnly,
                controller: textEditingController,
                obscureText: obscureText ?? false,
                keyboardType: keyboardType,
                onTap: onTap,
                onChanged: (value) => textValue?.value = value,
                style: TextStyle(
                    color: Theme.of(Get.context!).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white),
                validator: onValid,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(icon),
                  suffixIcon: suffixIcon == null
                      ? null
                      : IconButton(
                          onPressed: authController.showPassword,
                          icon: Icon(
                            suffixIcon,
                            color: Colors.black,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget customTextFieldVerify(
    BuildContext context,
    FocusNode focusNode,
    FocusNode? nextFocusNode,
    FocusNode? previousFocusNode,
    TextEditingController controller,
    ValueChanged<String>? onChanged) {
  return Container(
    height: 50,
    width: 50,
    decoration: BoxDecoration(
        color: Get.isDarkMode ? Colors.white10 : Colors.white,
        borderRadius: BorderRadius.circular(4)),
    child: TextFormField(
      focusNode: focusNode,
      controller: controller,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      decoration: const InputDecoration(
          border: InputBorder.none, contentPadding: EdgeInsets.all(2)),
      onChanged: (value) {
        if (onChanged != null) {
          onChanged(value);
        }
        if (value.length == 1 && nextFocusNode != null) {
          FocusScope.of(context).requestFocus(nextFocusNode);
        }
        if (value.isEmpty && previousFocusNode != null) {
          FocusScope.of(context).requestFocus(previousFocusNode);
        }
      },
      inputFormatters: [
        LengthLimitingTextInputFormatter(1),
        FilteringTextInputFormatter.digitsOnly,
      ],
    ),
  );
}

Future<void> customDialogConfirm(Function() nextPage) async {
  return await Get.dialog(
    AlertDialog(
      title: Text('confirm exit'.tr),
      content:
          Text('you have unsaved changes. are you sure you want to exit?'.tr),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false),
          child: Text('no'.tr),
        ),
        TextButton(
          onPressed: nextPage,
          child: Text('yes'.tr),
        ),
      ],
    ),
  );
}
