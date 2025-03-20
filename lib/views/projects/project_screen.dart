import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/controllers/auth/auth_controller.dart';
import 'package:project_manager/controllers/project/project_controller.dart';
import 'package:project_manager/controllers/task/task_controller.dart';
import 'package:project_manager/routers/app_routers.dart';
import 'package:project_manager/views/drawer/custom_drawer.dart';
import 'package:project_manager/views/projects/components/card_project_custom.dart';

class ProjectScreen extends StatelessWidget {
  ProjectScreen({super.key});

  final ProjectController projectController = Get.find();
  final AuthController authController = Get.find();
  final TaskController taskController = Get.find();

  List<Widget> showMenu() {
    return [
      PopupMenuButton(
        onSelected: (value) {
          projectController.changeSort(value);
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'status',
            child: Text('Sort by Status'),
          ),
          const PopupMenuItem(
            value: 'priority',
            child: Text('Sort by Priority'),
          ),
          const PopupMenuItem(
            value: 'date',
            child: Text('Sort by Date'),
          ),
        ],
        icon: const ImageIcon(
          AssetImage('assets/icons/icons8-sort-64.png'),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'your project'.tr,
        ),
        actions: showMenu(),
      ),
      drawer: GetPlatform.isWeb ? CustomDrawer() : null,
      body: Obx(
        () {
          if (projectController.projects.isEmpty) {
            return Center(
              child: Text(
                'oh!!!. You don\'t have any projects yet'.tr,
                style: Get.textTheme.bodyLarge,
              ),
            );
          } else {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Obx(
                      () => (MediaQuery.of(context).size.width <= 640)
                          ? ListView.separated(
                              itemCount: projectController.projects.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 20),
                              itemBuilder: (context, index) {
                                return CardProjectCustom(
                                  project: projectController.projects[index],
                                  onTap: () async {
                                    await taskController.updateCurrentProject(
                                        projectController.projects[index]);
                                    taskController.tasks
                                        .bindStream(taskController.fetchData());

                                    Get.toNamed(AppRouters.projectDetail);
                                  },
                                );
                              },
                            )
                          : GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: Get.size.width ~/ 400,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                                mainAxisExtent: kIsWeb ? 135 : 145,
                              ),
                              itemCount: projectController.projects.length,
                              itemBuilder: (context, index) {
                                return CardProjectCustom(
                                  project: projectController.projects[index],
                                  onTap: () async {
                                    await taskController.updateCurrentProject(
                                        projectController.projects[index]);
                                    taskController.tasks
                                        .bindStream(taskController.fetchData());
                                    Get.toNamed(AppRouters.projectDetail);
                                  },
                                );
                              },
                            ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AppRouters.addProject);
        },
        tooltip: 'add'.tr,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: const Icon(
          Icons.add_outlined,
          color: Colors.white,
        ),
      ),
    );
  }

  // Widget _customLable(BuildContext context,
  //     {required String label, required Function() ontap}) {
  //   return InkWell(
  //     borderRadius: BorderRadius.circular(15),
  //     splashColor: Colors.green,
  //     hoverColor: Colors.blue,
  //     highlightColor: Colors.purple,
  //     onTap: ontap,
  //     child: Container(
  //       height: 30,
  //       padding: const EdgeInsets.symmetric(horizontal: 15),
  //       decoration: BoxDecoration(
  //         color: Colors.red,
  //         borderRadius: BorderRadius.circular(15),
  //       ),
  //       alignment: Alignment.center,
  //       child: Text(
  //         label,
  //         style: Theme.of(context).textTheme.bodyLarge!,
  //       ),
  //     ),
  //   );
  // }
}
