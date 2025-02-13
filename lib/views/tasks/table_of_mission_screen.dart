import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/bindings/task_binding.dart';
import 'package:project_manager/controllers/auth/auth_controller.dart';
import 'package:project_manager/controllers/task/task_controller.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/views/tasks/add_task_screen.dart';
import 'package:project_manager/views/tasks/components/card_task_custom.dart';

class TableOfMissionScreen extends StatelessWidget {
  TableOfMissionScreen({super.key, required this.project});
  final Project project;

  final TaskController _taskController = Get.find();
  final AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    final isOwner = project.owner == _authController.currentUser.value!.id;
    print(project.owner);
    print(_authController.currentUser.value!.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'table of mission'.tr,
        ),
      ),
      body: Obx(
        () => _taskController.tasks.isEmpty
            ? Center(
                child: Text('oh!!!. We don\'t have any tasks yet'.tr),
              )
            : ListView.separated(
                itemCount: _taskController.tasks.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return const CardTaskCustom();
                }),
      ),
      floatingActionButton: isOwner
          ? FloatingActionButton(
              onPressed: () {
                Get.to(() => AddTaskScreen(project: project),
                    binding: TaskBinding());
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
