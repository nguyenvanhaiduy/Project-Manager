import 'package:get/get.dart';
import 'package:project_manager/utils/translations/en_us.dart';
import 'package:project_manager/utils/translations/vi_vn.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUs,
        'vi_VN': viVn,
      };
}
