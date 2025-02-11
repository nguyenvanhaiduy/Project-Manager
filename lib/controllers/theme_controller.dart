import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _storage = GetStorage();
  final _key = 'themeMode';
  Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final storedMode = _storage.read(_key);
      if (storedMode != null) {
        themeMode.value = _getThemeModeFromString(storedMode);
        Get.changeThemeMode(themeMode.value);
      }
    });
  }

  void setThemeMode(ThemeMode mode) {
    themeMode.value = mode;
    Get.changeThemeMode(mode);
    _storage.write(_key, mode.toString());
  }

  ThemeMode _getThemeModeFromString(String mode) {
    switch (mode) {
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      case 'ThemeMode.system':
      default:
        debugPrint('Warning: Invalid theme mode stored: $mode'); // Thêm warning
        return ThemeMode.system;
    }
  }
}

extension ThemeModeExtension on ThemeMode {
  String toStringThemeMode() {
    return toString();
  }
}
