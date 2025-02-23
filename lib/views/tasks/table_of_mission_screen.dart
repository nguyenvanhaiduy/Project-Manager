import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project_manager/controllers/auth/auth_controller.dart';
import 'package:project_manager/controllers/project/progress_project_controller.dart';
import 'package:project_manager/controllers/project/project_controller.dart';
import 'package:project_manager/controllers/task/task_controller.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/models/task.dart';
import 'package:project_manager/views/tasks/add_task_screen.dart';
import 'package:project_manager/views/tasks/components/card_task_custom.dart';
import 'package:project_manager/views/widgets/widgets.dart';

class TableOfMissionScreen extends StatelessWidget {
  TableOfMissionScreen({super.key});

  final AuthController authController = Get.find();
  final TaskController taskController = Get.find();
  final ProjectController projectController = Get.find();
  RxString status = ''.obs;

  @override
  Widget build(BuildContext context) {
    final project = taskController.currentProject.value!;
    taskController.tasks
        .bindStream(taskController.fetchData()); // load lại task theo project
    final isOwner = project.owner == authController.currentUser.value!.id;
    return Scaffold(
      appBar: AppBar(
        title: Text('table of mission'.tr),
      ),
      body: PopScope(
        onPopInvokedWithResult: (didPop, result) {
          Get.find<ProgressProjectController>()
              .animateToValue(taskController.calculateProgress());
        },
        child: Obx(
          () => taskController.tasks.isEmpty
              ? Center(child: Text('oh!!!. We don\'t have any tasks yet'.tr))
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Obx(
                    () => GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: MediaQuery.of(context).size.width < 450
                            ? (MediaQuery.of(context).size.width ~/ 170)
                            : (MediaQuery.of(context).size.width ~/ 200),
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
                  ),
                ),
        ),
      ),
      floatingActionButton: isOwner
          ? FloatingActionButton(
              onPressed: () {
                Get.to(() => AddTaskScreen(
                      project: project,
                      isAddTask: true,
                    ));
                print(
                    '${MediaQuery.of(context).size.width ~/ 200} ${MediaQuery.of(context).size.width}');
              },
              tooltip: 'add'.tr,
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

  void _showTaskDetails(BuildContext context, Task task, bool isOwner) {
    status.value = task.status.name;
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
              print('test');
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

                    child: IntrinsicHeight(
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
                                Align(
                                    alignment: Alignment.topRight,
                                    child: InkWell(
                                        borderRadius: BorderRadius.circular(
                                            30), // Bo góc hiệu ứng
                                        splashColor: Colors.blue.withOpacity(
                                            0.3), // Màu hiệu ứng khi nhấn
                                        highlightColor: Colors.blue,
                                        onTap: () async {
                                          bool isUpdate = true;
                                          if (status.value ==
                                              Status.cancelled.name) {
                                            isUpdate = await customDialogConfirm(
                                                'Are you sure you want to cancel this task?',
                                                () {});
                                          }
                                          if (isUpdate) {
                                            taskController.updateTask(Task(
                                                id: task.id,
                                                title: task.title,
                                                startDate: task.startDate,
                                                endDate: task.endDate,
                                                status: Status.values
                                                    .firstWhere((s) =>
                                                        s.name == status.value),
                                                priority: task.priority,
                                                assignTo: task.assignTo,
                                                projectOwner: task.projectOwner,
                                                complexity: task.complexity));
                                          }
                                        },
                                        child: const Icon(Icons.save)))
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
                                        'unknown'
                                            .tr); // Use null-aware operator
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
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  if (isOwner)
                                    ElevatedButton(
                                      onPressed: () {
                                        Get.back();
                                        Get.to(AddTaskScreen(
                                            project: taskController
                                                .currentProject.value!,
                                            isAddTask: false,
                                            task: task));
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
                                          await taskController
                                              .deleteTask(task.id);
                                          Get.back();
                                        }
                                      },
                                      child: Text('delete'.tr),
                                    ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (task.assignTo == '') {
                                        final shouldClaim =
                                            await customDialogConfirm(
                                                'are you sure you want to accept this task?',
                                                () {});
                                        if (shouldClaim) {
                                          try {
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
                                              ),
                                            );
                                            Get.snackbar('Success',
                                                'You have accepted this task');
                                          } catch (e) {
                                            // Get.closeAllSnackbars();
                                            Get.closeCurrentSnackbar();
                                            Get.snackbar(
                                                'Error', 'Assign error: $e');
                                          }
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
                              ),
                            )
                          ],
                        ),
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
