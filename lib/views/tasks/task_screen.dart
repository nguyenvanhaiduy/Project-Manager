import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/controllers/task/task_controller.dart';
import 'package:project_manager/views/tasks/components/card_task_custom.dart';

class TaskScreen extends StatelessWidget {
  TaskScreen({super.key});

  final TaskController _taskController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'your task'.tr,
        ),
      ),
      body: Obx(
        () => _taskController.tasks.isEmpty
            ? Center(
                child: Text('oh!!!. You don\'t have any tasks yet'.tr),
              )
            : ListView.separated(
                itemCount: _taskController.tasks.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return const CardTaskCustom();
                }),
      ),
    );
  }
}
