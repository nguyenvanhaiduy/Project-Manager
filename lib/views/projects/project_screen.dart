import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/controllers/auth/auth_controller.dart';
import 'package:project_manager/controllers/project/project_controller.dart';
import 'package:project_manager/controllers/task/task_controller.dart';
import 'package:project_manager/routers/app_routers.dart';
import 'package:project_manager/views/projects/components/card_project_custom.dart';

class ProjectScreen extends StatelessWidget {
  ProjectScreen({super.key});

  final ProjectController projectController = Get.find();
  final AuthController authController = Get.find();
  final TaskController taskController = Get.find();

  final RxBool isSearching = false.obs;
  final TextEditingController searchController = TextEditingController();

  List<Widget> showMenu() {
    return [
      PopupMenuButton(
        onSelected: (value) {
          projectController.changeSort(value);
        },
        itemBuilder: (context) => [
          PopupMenuItem(value: 'status', child: Text('Sort by Status'.tr)),
          PopupMenuItem(value: 'priority', child: Text('Sort by Priority'.tr)),
          PopupMenuItem(value: 'date', child: Text('Sort by Date'.tr)),
        ],
        icon: const ImageIcon(AssetImage('assets/icons/icons8-sort-64.png')),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          return isSearching.value
              ? TextField(
                  controller: searchController,
                  onChanged: (value) {
                    projectController.searchProject(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search project...'.tr,
                    border: InputBorder.none,
                    hintStyle: Get.textTheme.bodyMedium,
                  ),
                )
              : Text('your project'.tr);
        }),
        // Ẩn actions nếu đang tìm kiếm
        actions: [
          Obx(() => isSearching.value
              ? SizedBox()
              : Row(
                  children: showMenu(),
                ))
        ],
        leading: Obx(() => IconButton(
              icon: Icon(isSearching.value ? Icons.close : Icons.search),
              onPressed: () {
                if (isSearching.value) {
                  searchController.clear();
                  projectController.searchProject('');
                  isSearching.value = false;

                  // Không dùng context — tránh lỗi deactivated widget
                  FocusManager.instance.primaryFocus?.unfocus();
                } else {
                  isSearching.value = true;
                }
              },
            )),
      ),
      body: Obx(() {
        if (projectController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (projectController.projects.isEmpty) {
          return Center(
            child: Text(
              'oh!!!. You don\'t have any projects yet'.tr,
              style: Get.textTheme.bodyLarge,
            ),
          );
        }

        final projects = isSearching.value
            ? projectController.filteredProjects
            : projectController.projects;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: Padding(
            key: ValueKey(projects),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: (MediaQuery.of(context).size.width <= 640)
                ? ListView.separated(
                    itemCount: projects.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 20),
                    itemBuilder: (context, index) {
                      return CardProjectCustom(
                        project: projects[index],
                        onTap: () async {
                          await taskController
                              .updateCurrentProject(projects[index]);
                          taskController.tasks
                              .bindStream(taskController.fetchData());
                          Get.toNamed(AppRouters.tableOfMission);
                        },
                      );
                    },
                  )
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: Get.size.width ~/ 400,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      mainAxisExtent: kIsWeb ? 170 : 175,
                    ),
                    itemCount: projects.length,
                    itemBuilder: (context, index) {
                      return CardProjectCustom(
                        project: projects[index],
                        onTap: () async {
                          await taskController
                              .updateCurrentProject(projects[index]);
                          taskController.tasks
                              .bindStream(taskController.fetchData());
                          Get.toNamed(AppRouters.tableOfMission);
                        },
                      );
                    },
                  ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRouters.addProject),
        tooltip: 'add'.tr,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: const Icon(Icons.add_outlined, color: Colors.white),
      ),
    );
  }
}
