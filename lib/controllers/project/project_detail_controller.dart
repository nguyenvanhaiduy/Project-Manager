import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project_manager/controllers/project/attachments_controller.dart';
import 'package:project_manager/controllers/task/task_controller.dart';
import 'package:project_manager/models/project.dart';

class ProjectDetailController extends GetxController {
  final RxList<String> userIds = <String>[].obs;
  RxBool hasChanges = false.obs;

  late RxString title = ''.obs;
  late RxString description = ''.obs;
  late RxString startDate = ''.obs;
  late RxString dueDate = ''.obs;
  late RxInt selectStatusIndex;
  late RxInt selectPriorityIndex;
  late RxList<String> attachments = <String>[].obs;
  final AttachmentsController attachmentsController = Get.find();

  Project? initialProject;

  @override
  void onInit() {
    super.onInit();
    final project = Get.find<TaskController>().currentProject.value!;
    initialProject = project;
    userIds.value = List.from(project.userIds);
    title.value = project.title;
    description.value = project.description;
    startDate.value = DateFormat('MM/dd/yyyy, HH:mm').format(project.startDate);
    dueDate.value = DateFormat('MM/dd/yyyy, HH:mm').format(project.endDate);
    selectStatusIndex = project.status.index.obs;
    selectPriorityIndex = project.priority.index.obs;
    attachments.value = List.from(project.attachments);
    attachmentsController.updateList(project.attachments);

    // Sử dụng everAll để theo dõi thay đổi của tất cả các trường
    everAll([
      title,
      description,
      startDate,
      dueDate,
      selectStatusIndex,
      selectPriorityIndex,
      userIds,
      attachments,
    ], (_) {
      _checkChanges();
    });
  }

  void _checkChanges() {
    final currentProject = Project(
      id: initialProject!.id,
      title: title.value.trim(),
      description: description.value.trim(),
      status: Status.values[selectStatusIndex.value],
      priority: Priority.values[selectPriorityIndex.value],
      startDate: DateFormat('MM/dd/yyyy, HH:mm').parse(startDate.value),
      endDate: DateFormat('MM/dd/yyyy, HH:mm').parse(dueDate.value),
      taskIds: initialProject!.taskIds,
      userIds: userIds,
      attachments: attachments,
      owner: initialProject!.owner,
    );

    hasChanges.value = currentProject != initialProject;
  }

  void revertChanges() {
    title.value = initialProject!.title;
    description.value = initialProject!.description;
    startDate.value =
        DateFormat('MM/dd/yyyy, HH:mm').format(initialProject!.startDate);
    dueDate.value =
        DateFormat('MM/dd/yyyy, HH:mm').format(initialProject!.endDate);
    selectStatusIndex.value = initialProject!.status.index;
    selectPriorityIndex.value = initialProject!.priority.index;
    userIds.value = List.from(initialProject!.userIds);
    print(userIds.length);
    attachments.value = List.from(initialProject!.attachments);
    attachmentsController.updateList(initialProject!.attachments);
    hasChanges.value = false;
  }

  void removeUser(String userId) {
    userIds.remove(userId);
  }
}
