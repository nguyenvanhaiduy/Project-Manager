import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/controllers/auth/auth_controller.dart';
import 'package:project_manager/controllers/task/task_controller.dart';
import 'package:project_manager/views/tasks/add_task_screen.dart';
import 'package:project_manager/views/tasks/components/card_task_custom.dart';

class TableOfMissionScreen extends StatelessWidget {
  TableOfMissionScreen({super.key});

  final AuthController authController = Get.find();
  final TaskController taskController = Get.find();

  @override
  Widget build(BuildContext context) {
    final project = taskController.currentProject!.value;
    taskController.tasks.bindStream(taskController.fetchData());
    final isOwner = project.owner == authController.currentUser.value!.id;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'table of mission'.tr,
        ),
      ),
      body: Obx(
        () => taskController.tasks.isEmpty
            ? Center(
                child: Text('oh!!!. We don\'t have any tasks yet'.tr),
              )
            : ListView.separated(
                itemCount: taskController.tasks.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return CardTaskCustom(
                    task: taskController.tasks[index],
                  );
                }),
      ),
      floatingActionButton: isOwner
          ? FloatingActionButton(
              onPressed: () {
                print('project table misssion id: ${project.id}');

                Get.to(() => AddTaskScreen(project: project));
              },
              tooltip: 'add'.tr,
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: const Icon(
                Icons.add_outlined,
                color: Colors.white,
              ),
            )
          : null,
    );
  }
}
