import 'package:get/get.dart';
import 'package:project_manager/models/user.dart';

class AddProjectController extends GetxController {
  final RxInt selectedPriority = 0.obs;

  final RxList<User> assignedForArr = <User>[].obs;

  void changePriority(int index) {
    selectedPriority.value = index;
  }

  void addUser(User user) {
    assignedForArr.add(user);
  }

  void removeUser(int index) {
    assignedForArr.removeAt(index);
  }
}
