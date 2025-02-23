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
                    return GestureDetector(
                      onTap: () async {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return Center(
                              child: Container(
                                height: 100,
                                width: 100,
                                color: Colors.red,
                              ),
                            );
                          },
                        );
                      },
                      child: CardTaskCustom(
                        task: taskController.tasks[index],
                      ),
                    );
                  },
                ),
        ));
  }
}
