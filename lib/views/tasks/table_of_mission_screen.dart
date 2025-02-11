import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/controllers/auth/auth_controller.dart';
import 'package:project_manager/controllers/task/task_controller.dart';
import 'package:project_manager/views/tasks/add_task_screen.dart';
import 'package:project_manager/views/tasks/components/card_task_custom.dart';

class TableOfMissionScreen extends StatelessWidget {
  TableOfMissionScreen({super.key, required this.ownerId});
  final String ownerId;

  final TaskController _taskController = Get.find();
  final AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    final isOwner = ownerId == _authController.currentUser.value!.id;
    print(ownerId);
    print(_authController.currentUser.value!.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bảng nhiệm vụ'.tr,
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
                  return CardTaskCustom();
                }),
      ),
      floatingActionButton: isOwner
          ? FloatingActionButton(
              onPressed: () {
                Get.to(() => AddTaskScreen());
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
