import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project_manager/controllers/auth/auth_controller.dart';
import 'package:project_manager/controllers/project/project_controller.dart';
import 'package:project_manager/controllers/task/task_controller.dart';
import 'package:project_manager/models/task.dart';
import 'package:project_manager/views/tasks/add_task_screen.dart';
import 'package:project_manager/views/tasks/components/card_task_custom.dart';

class TableOfMissionScreen extends StatelessWidget {
  TableOfMissionScreen({super.key});

  final AuthController authController = Get.find();
  final TaskController taskController = Get.find();
  final ProjectController projectController = Get.find();

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
      body: Obx(
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
      floatingActionButton: isOwner
          ? FloatingActionButton(
              onPressed: () {
                Get.to(() => AddTaskScreen(project: project));
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
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black54,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, anim1, anim2) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                    color: Colors.black54,
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
                          Center(
                            child: Text(
                              task.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Divider(), // Add a divider for visual separation
                          _buildDetailRowWithExpansion(
                              'Description:', task.description),
                          _buildDetailRow(
                              'Start Date:',
                              DateFormat('MM/dd/yyyy, HH:mm')
                                  .format(task.startDate)),
                          _buildDetailRow(
                              'Due Date:',
                              DateFormat('MM/dd/yyyy, HH:mm')
                                  .format(task.endDate)),
                          FutureBuilder(
                            future: projectController.getUser(
                                userId: task.assignTo),
                            builder: (context, snapshot) {
                              String assignedTo = snapshot.connectionState ==
                                      ConnectionState.waiting
                                  ? 'Loading...'
                                  : (snapshot.data?.name ??
                                      'Unknown'); // Use null-aware operator
                              return _buildDetailRow('Assign to:', assignedTo);
                            },
                          ),
                          _buildDetailRow('Status:', task.status.name.tr),
                          _buildDetailRow('Priority:', task.priority.name.tr),
                          _buildDetailRow('Complex:', task.complexity.name.tr),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                if (isOwner)
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: Text('edit'.tr),
                                  ),
                                if (isOwner)
                                  ElevatedButton(
                                    onPressed: () async {
                                      // taskController.deleteTask(task.id);
                                    },
                                    child: Text('delete'.tr),
                                  ),
                                ElevatedButton(
                                  onPressed: () async {
                                    // taskController.deleteTask(task.id);
                                  },
                                  child: const Text('Claim'),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 4.0), // Add some spacing between rows
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Align label and value
        children: [
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.bold)), // Make label bold
          Text(value),
        ],
      ),
    );
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
