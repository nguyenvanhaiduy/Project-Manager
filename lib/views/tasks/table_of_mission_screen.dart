import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project_manager/controllers/auth/auth_controller.dart';
import 'package:project_manager/controllers/project/attachments_controller.dart';
import 'package:project_manager/controllers/project/progress_project_controller.dart';
import 'package:project_manager/controllers/project/project_controller.dart';
import 'package:project_manager/controllers/task/task_controller.dart';
import 'package:project_manager/logic/project_logic.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/models/task.dart';
import 'package:project_manager/routers/app_routers.dart';
import 'package:project_manager/views/tasks/components/card_task_custom.dart';
import 'package:project_manager/views/widgets/widgets.dart';

class TableOfMissionScreen extends StatelessWidget {
  TableOfMissionScreen({super.key});

  final AuthController authController = Get.find();
  final TaskController taskController = Get.find();
  final ProjectController projectController = Get.find();
  final AttachmentsController attachmentsController = Get.find();
  final ProjectLogic projectLogic = ProjectLogic();
  final RxString status = ''.obs;
  final RxBool hasChange = false.obs;
  final RxString searchText = ''.obs;
  final RxBool isSearching = false.obs;
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final project = taskController.currentProject.value!;
    taskController.tasks.bindStream(taskController.fetchData());
    final isOwner = project.owner == authController.currentUser.value!.id;

    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => isSearching.value
              ? TextField(
                  autofocus: true,
                  controller: searchController, // Sử dụng controller riêng
                  onChanged: (value) {
                    searchText.value = value;
                  },
                  style: TextStyle(
                      color: Get.isDarkMode ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm nhiệm vụ...'.tr,
                    hintStyle: TextStyle(
                        color: Get.isDarkMode ? Colors.white70 : Colors.black),
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.close,
                          color:
                              Get.isDarkMode ? Colors.white10 : Colors.black),
                      onPressed: () {
                        searchController.clear(); // Xóa toàn bộ text
                        searchText.value = ''; // Cập nhật searchText
                        isSearching.value = false; // Thoát chế độ tìm kiếm
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                )
              : Text('Bảng nhiệm vụ'.tr),
        ),
        actions: [
          Obx(
            () => !isSearching.value
                ? IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      isSearching.value = true;
                    },
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      body: PopScope(
        onPopInvokedWithResult: (didPop, result) {
          Get.put(ProgressProjectController())
              .animateToValue(taskController.calculateProgress());
        },
        child: Obx(
          () {
            final filteredTasks = taskController.tasks
                .where((task) => task.title
                    .toLowerCase()
                    .contains(searchText.value.toLowerCase()))
                .toList();

            return filteredTasks.isEmpty
                ? const Center(
                    child: Text('Ồ!!!. Chúng ta chưa có nhiệm vụ nào cả'))
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: MediaQuery.of(context).size.width < 450
                            ? (MediaQuery.of(context).size.width ~/ 170)
                            : (MediaQuery.of(context).size.width ~/ 200),
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        mainAxisExtent: 193,
                      ),
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = filteredTasks[index];
                        return GestureDetector(
                          onTap: () async {
                            _showTaskDetails(context, task, isOwner);
                          },
                          child: CardTaskCustom(task: task),
                        );
                      },
                    ),
                  );
          },
        ),
      ),
      floatingActionButton: isOwner
          ? FloatingActionButton(
              onPressed: () {
                attachmentsController.updateList([]);
                Get.toNamed(
                  AppRouters.addTask,
                  arguments: {
                    'project': project.toMap(),
                    'isAddTask': true,
                  },
                );
              },
              tooltip: 'Thêm',
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.add_outlined, color: Colors.white),
            )
          : null,
    );
  }

  // ... (phần còn lại của code, bao gồm _showTaskDetails, _buildDetailRow, showMenu, _buildDetailRowWithExpansion giữ nguyên)

  void _showTaskDetails(BuildContext context, Task task, bool isOwner) async {
    status.value = task.status.name;
    final originStatus = task.status.name.obs;
    await attachmentsController.updateList(task.attachments);
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black54,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, anim1, anim2) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: PopScope(
            onPopInvokedWithResult: (didPop, result) {
              hasChange.value = false;
            },
            child: Align(
              alignment: Alignment.center,
              child: Material(
                color: Colors.transparent,
                child: ScaleTransition(
                  scale: CurvedAnimation(
                    parent: anim1,
                    curve: Curves.easeOut,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Get.isDarkMode ? Colors.black54 : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(20),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? Get.size.width * 0.9
                            : Get.size.height * 0.9,
                        maxHeight: Get.size.height * 0.8),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  task.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              (isOwner ||
                                      task.assignTo ==
                                          authController.currentUser.value!.id)
                                  ? Align(
                                      alignment: Alignment.topRight,
                                      child: InkWell(
                                          highlightColor: Colors.blue,
                                          onTap: () async {
                                            if (status.value !=
                                                    originStatus.value ||
                                                hasChange.value) {
                                              if (task.assignTo != '') {
                                                bool isUpdate = true;
                                                if (status.value ==
                                                    Status.cancelled.name) {
                                                  isUpdate =
                                                      await customDialogConfirm(
                                                          'Bạn có chắc chắn muốn hủy nhiệm vụ này?',
                                                          () {});
                                                }
                                                if (isUpdate) {
                                                  final taskTmp = Task(
                                                    id: task.id,
                                                    title: task.title,
                                                    description:
                                                        task.description,
                                                    startDate: task.startDate,
                                                    endDate: task.endDate,
                                                    status: Status.values
                                                        .firstWhere((s) =>
                                                            s.name ==
                                                            status.value),
                                                    priority: task.priority,
                                                    assignTo: task.assignTo,
                                                    projectOwner:
                                                        task.projectOwner,
                                                    complexity: task.complexity,
                                                    attachments:
                                                        attachmentsController
                                                            .attachments
                                                            .map((file) =>
                                                                file.id)
                                                            .toList(),
                                                  );
                                                  await taskController
                                                      .updateTask(taskTmp);
                                                  status.value ==
                                                      taskTmp.status.name;
                                                  originStatus.value =
                                                      taskTmp.status.name;

                                                  hasChange.value = false;
                                                }
                                              } else {
                                                Get.dialog(Center(
                                                  child: Material(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    clipBehavior: Clip.hardEdge,
                                                    child: SizedBox(
                                                      width: 280,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          const SizedBox(
                                                              height: 10),
                                                          Text(
                                                            'Thông báo',
                                                            style: Get.textTheme
                                                                .bodyLarge!
                                                                .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          const Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        12,
                                                                    vertical:
                                                                        5),
                                                            child: Text(
                                                              'Nhiệm vụ chưa có người nhận. Bạn có thể nhận nhiệm vụ này để bắt đầu!',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ),
                                                          const Divider(),
                                                          TextButton(
                                                              onPressed: () {
                                                                Get.back();
                                                              },
                                                              child: Text('OK',
                                                                  style: Get
                                                                      .textTheme
                                                                      .bodyLarge!
                                                                      .copyWith(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.blue)))
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ));
                                              }
                                            }
                                          },
                                          child: Obx(() => (status.value !=
                                                      originStatus.value ||
                                                  hasChange.value)
                                              ? const Icon(Icons.save)
                                              : const Icon(
                                                  Icons.save_outlined))),
                                    )
                                  : const SizedBox()
                            ],
                          ),
                          const Divider(),
                          _buildDetailRowWithExpansion(
                              'Mô tả:', task.description),
                          _buildDetailRow(
                              'Ngày bắt đầu:',
                              DateFormat('MM/dd/yyyy, HH:mm')
                                  .format(task.startDate)),
                          _buildDetailRow(
                              'Hạn chót:',
                              DateFormat('MM/dd/yyyy, HH:mm')
                                  .format(task.endDate)),
                          FutureBuilder(
                            future: projectController.getUser(
                                userId: task.assignTo),
                            builder: (context, snapshot) {
                              String assignedTo = snapshot.connectionState ==
                                      ConnectionState.waiting
                                  ? '...'
                                  : (snapshot.data?.name ?? 'chưa rõ');
                              return _buildDetailRow('Giao cho:', assignedTo);
                            },
                          ),
                          _buildDetailRow('Trạng thái:', status.value.tr,
                              showMenu:
                                  showMenu(value: task.status.name.tr.obs)),
                          _buildDetailRow('Độ ưu tiên:', task.priority.name.tr),
                          _buildDetailRow(
                              'Độ phức tạp:', task.complexity.name.tr),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Tệp đính kèm:',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Obx(
                            () => Container(
                              width: double.infinity,
                              constraints: const BoxConstraints(
                                maxHeight: 100,
                              ),
                              child: ListView.separated(
                                padding: const EdgeInsets.all(0),
                                shrinkWrap: true,
                                itemCount:
                                    attachmentsController.attachments.length,
                                cacheExtent: 0,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  height: 4,
                                ),
                                itemBuilder: (context, index) {
                                  final file =
                                      attachmentsController.attachments[index];
                                  return Dismissible(
                                      key: UniqueKey(),
                                      background: Container(
                                        alignment: Alignment.centerRight,
                                        color: Colors.red,
                                        child: const Icon(Icons.delete),
                                      ),
                                      direction: DismissDirection.endToStart,
                                      onDismissed: (diretion) {
                                        attachmentsController
                                            .removeAttachment(index);
                                        hasChange.value = true;
                                      },
                                      child: Row(
                                        textBaseline: TextBaseline.ideographic,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            width: 200,
                                            child: Text(
                                              file.fileName,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: false,
                                            ),
                                          ),
                                        ],
                                      ));
                                },
                              ),
                            ),
                          ),
                          (isOwner ||
                                  task.assignTo ==
                                      authController.currentUser.value!.id)
                              ? Wrap(
                                  alignment: WrapAlignment.center,
                                  children: [
                                    IconButton(
                                      color: Colors.red,
                                      padding: const EdgeInsets.all(0),
                                      tooltip: 'Thêm tệp',
                                      onPressed: () async {
                                        await projectLogic.pickFile();
                                        hasChange.value = true;
                                      },
                                      icon: const Icon(Icons.add),
                                    )
                                  ],
                                )
                              : const SizedBox(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              if (isOwner ||
                                  task.assignTo ==
                                      authController.currentUser.value!.id)
                                ElevatedButton(
                                  onPressed: () {
                                    Get.back();
                                    attachmentsController
                                        .updateList(task.attachments);
                                    Get.toNamed(
                                      AppRouters.addTask,
                                      arguments: {
                                        'project': taskController
                                            .currentProject.value!
                                            .toMap(),
                                        'isAddTask': false,
                                        'task': task.toMap(),
                                      },
                                    );
                                  },
                                  child: Text('Sửa'),
                                ),
                              if (isOwner)
                                ElevatedButton(
                                  onPressed: () async {
                                    final shouldDelete =
                                        await customDialogConfirm(
                                      'Bạn có chắc chắn muốn xóa nhiệm vụ này?',
                                      () {
                                        Get.back();
                                      },
                                    );
                                    if (shouldDelete) {
                                      Get.closeCurrentSnackbar();
                                      await taskController.deleteTask(
                                          task.id, task.attachments);
                                      Get.back();
                                    }
                                  },
                                  child: Text('Xóa'),
                                ),
                              if (task.assignTo == '')
                                ElevatedButton(
                                  onPressed: () async {
                                    if (task.assignTo == '') {
                                      final shouldClaim = await customDialogConfirm(
                                          'Bạn có chắc chắn muốn nhận nhiệm vụ này?',
                                          () {});
                                      if (shouldClaim) {
                                        await taskController.updateTask(
                                          Task(
                                            id: task.id,
                                            title: task.title,
                                            startDate: task.startDate,
                                            endDate: task.endDate,
                                            status: task.status,
                                            priority: task.priority,
                                            assignTo: authController
                                                .currentUser.value!.id,
                                            projectOwner: task.projectOwner,
                                            complexity: task.complexity,
                                            attachments: attachmentsController
                                                .attachments
                                                .map((file) => file.id)
                                                .toList(),
                                          ),
                                        );
                                        Get.back();
                                      }
                                    } else {
                                      Get.closeCurrentSnackbar();
                                      Get.snackbar('Thông báo',
                                          'Bạn đã chọn không nhận nhiệm vụ này.');
                                    }
                                  },
                                  child: Text('Nhận'),
                                ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(
            opacity: anim1.value,
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, {List<Widget>? showMenu}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            )),
        showMenu == null ? Text(value) : Row(children: showMenu),
      ]),
    );
  }

  List<Widget> showMenu({required RxString value}) {
    return [
      PopupMenuButton(
        onSelected: (value) {
          status.value = value;
          print(status.value);
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            value: Status.notStarted.name,
            child: Text(Status.notStarted.name.tr),
          ),
          PopupMenuItem(
            value: Status.inProgress.name,
            child: Text(Status.inProgress.name.tr),
          ),
          PopupMenuItem(
            value: Status.completed.name,
            child: Text(Status.completed.name.tr),
          ),
          PopupMenuItem(
            value: Status.lateCompleted.name,
            child: Text(Status.lateCompleted.name.tr),
          ),
          PopupMenuItem(
            value: Status.cancelled.name,
            child: Text(Status.cancelled.name.tr),
          ),
        ],
        child: Obx(() => Text(status.value.tr)),
      ),
    ];
  }

  Widget _buildDetailRowWithExpansion(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(
            value,
            overflow: TextOverflow.fade,
            style: const TextStyle(height: 1.5),
          ),
        ],
      ),
    );
  }
}
