import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project_manager/utils/app_constants.dart';

class LanguageController extends GetxController {
  var currentLocale = (Get.deviceLocale ?? const Locale('en', 'US')).obs;
  final _storage = GetStorage();
  final _key = 'language';

  @override
  void onReady() {
    super.onReady();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_storage.read(_key) != null) {
        final storedLocale = supportedLocale
            .firstWhere((locale) => _storage.read(_key) == locale.languageCode);
        currentLocale.value = storedLocale;
        Get.updateLocale(storedLocale);
      } else {
        final localed = supportedLocale.firstWhereOrNull((locale) =>
            locale.languageCode == currentLocale.value.languageCode);
        if (localed != null) {
          currentLocale.value = localed;
          Get.updateLocale(localed);
        }
      }
    });
  }

  void changeLanguage(Locale locale) {
    currentLocale.value = locale;
    _storage.write(_key, locale.languageCode);
    Get.updateLocale(currentLocale.value);
  }
}
