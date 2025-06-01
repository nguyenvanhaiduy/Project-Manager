import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project_manager/controllers/auth/auth_controller.dart';
import 'package:project_manager/controllers/project/attachments_controller.dart';
import 'package:project_manager/controllers/project/project_controller.dart';
import 'package:project_manager/controllers/task/task_controller.dart';
import 'package:project_manager/logic/project_logic.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/models/task.dart';
import 'package:project_manager/routers/app_routers.dart';
import 'package:project_manager/views/tasks/components/card_task_custom.dart';
import 'package:project_manager/views/widgets/widgets.dart';

// ignore: must_be_immutable
class YourTaskScreen extends StatelessWidget {
  YourTaskScreen({super.key});

  final TaskController taskController = Get.find();
  final AuthController authController = Get.find();
  final ProjectController projectController = Get.find();
  final AttachmentsController attachmentsController = Get.find();
  final ProjectLogic projectLogic = ProjectLogic();
  final RxString status = ''.obs;
  RxBool hasChange = false.obs;

  @override
  Widget build(BuildContext context) {
    final project = taskController.currentProject.value!;
    taskController.tasks.bindStream(
        taskController.yourFetchTask()); // load lại task theo project
    final isOwner = project.owner == authController.currentUser.value!.id;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'your task'.tr,
          ),
        ),
        body: Obx(
          () => taskController.tasks.isEmpty
              ? Center(child: Text('oh!!!. You don\'t have any tasks yet'.tr))
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width ~/ 200,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    mainAxisExtent: 193,
                  ),
                  itemCount: taskController.tasks.length,
                  itemBuilder: (context, index) {
                    final task = taskController.tasks[index];

                    return GestureDetector(
                      onTap: () async {
                        _showTaskDetails(context, task, isOwner);
                      },
                      child: CardTaskCustom(
                        task: taskController.tasks[index],
                      ),
                    );
                  },
                ),
        ));
  }

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
                        maxHeight: Get.size.height *
                            0.8), // Max width for responsiveness

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
                                                          'are you sure you want to cancel this task?',
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
                                                            'Notification',
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
                                                          // SizedBox(height: 10),
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
                          const Divider(), // Add a divider for visual separation
                          _buildDetailRowWithExpansion(
                              '${'description'.tr}:', task.description),
                          _buildDetailRow(
                              '${'start date'.tr}:',
                              DateFormat('MM/dd/yyyy, HH:mm')
                                  .format(task.startDate)),
                          _buildDetailRow(
                              '${'due date'.tr}:',
                              DateFormat('MM/dd/yyyy, HH:mm')
                                  .format(task.endDate)),
                          FutureBuilder(
                            future: projectController.getUser(
                                userId: task.assignTo),
                            builder: (context, snapshot) {
                              String assignedTo = snapshot.connectionState ==
                                      ConnectionState.waiting
                                  ? '...'
                                  : (snapshot.data?.name ??
                                      'unknown'.tr); // Use null-aware operator
                              return _buildDetailRow(
                                  '${'assigned to'.tr}:', assignedTo);
                            },
                          ),
                          _buildDetailRow('${'status'.tr}:', status.value.tr,
                              showMenu:
                                  showMenu(value: task.status.name.tr.obs)),
                          _buildDetailRow(
                              '${'priority'.tr}:', task.priority.name.tr),
                          _buildDetailRow(
                              '${'complex'.tr}:', task.complexity.name.tr),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Attachments:'.tr,
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
                                      tooltip: 'Add file',
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
                                  child: Text('edit'.tr),
                                ),
                              if (isOwner)
                                ElevatedButton(
                                  onPressed: () async {
                                    final shouldDelete =
                                        await customDialogConfirm(
                                      'are you sure you want to delete this task?',
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
                                  child: Text('delete'.tr),
                                ),
                              if (task.assignTo == '')
                                ElevatedButton(
                                  onPressed: () async {
                                    if (task.assignTo == '') {
                                      final shouldClaim = await customDialogConfirm(
                                          'are you sure you want to accept this task?',
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
                                      // Get.closeAllSnackbars();
                                      Get.closeCurrentSnackbar();
                                      Get.snackbar('Notice',
                                          'You chose not to accept this task.');
                                    }
                                  },
                                  child: Text('claim'.tr),
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
          // angle: 10,
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
      padding: const EdgeInsets.symmetric(
          vertical: 4.0), // Add some spacing between rows
      child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Align label and value
          children: [
            Text(label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                )), // Make label bold
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
        // Use a Column for the label and expandable text
        crossAxisAlignment:
            CrossAxisAlignment.start, // Align label to the start
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4), // Spacing between label and text
          Text(
            value,
            overflow: TextOverflow.fade, // Handles text overflow smoothly
            style: const TextStyle(
                height: 1.5), // Line height for better readability
          ),
        ],
      ),
    );
  }
}
