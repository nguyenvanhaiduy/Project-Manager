import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/controllers/task/task_controller.dart';
import 'package:project_manager/views/tasks/components/card_task_custom.dart';

class YourTaskScreen extends StatelessWidget {
  YourTaskScreen({super.key});

  final TaskController taskController = Get.find();

  @override
  Widget build(BuildContext context) {
    taskController.tasks.bindStream(taskController.yourFetchTask());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'your task'.tr,
        ),
      ),
      body: Obx(
        () => taskController.tasks.isEmpty
            ? Center(
                child: Text('oh!!!. You don\'t have any tasks yet'.tr),
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
    );
  }
}
