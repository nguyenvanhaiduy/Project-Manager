import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project_manager/controllers/auth/auth_controller.dart';
import 'package:project_manager/controllers/project/project_controller.dart';
import 'package:project_manager/controllers/task/task_controller.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/models/user.dart';
import 'package:project_manager/routers/app_routers.dart';
import 'package:project_manager/utils/color_utils.dart';
import 'package:project_manager/views/projects/components/build_avatar.dart';
import 'package:project_manager/views/projects/components/build_plus_avatar.dart';

class CardProjectCustom extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;

  CardProjectCustom({super.key, required this.project, required this.onTap});

  final AuthController authController = Get.find();
  final ProjectController projectController = Get.find();
  final TaskController taskController = Get.find();

  Future<List<User>> fetchUsers() async {
    List<User> users = [];
    for (var userId in project.userIds) {
      final user = await projectController.getUser(userId: userId);
      if (user != null) users.add(user);
    }
    return users;
  }

  @override
  Widget build(BuildContext context) {
    final amountAttachment = project.attachments.length;

    return FutureBuilder<List<User>>(
      future: fetchUsers(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (userSnapshot.hasError) {
          return Text('Lỗi: ${userSnapshot.error}');
        }

        final users = userSnapshot.data ?? [];

        return StreamBuilder(
          stream: taskController.fetchData(id: project.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox.shrink();
            }

            final tasks = snapshot.data ?? [];
            int done = 0, inprogress = 0;
            for (var task in tasks) {
              if (task.status.name == 'completed')
                done++;
              else if (task.status.name == 'inProgress') inprogress++;
            }
            double progress =
                tasks.isEmpty ? 0 : (done + inprogress / 2) / tasks.length;

            return InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: onTap,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Get.isDarkMode ? Colors.black26 : Colors.black26,
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tiêu đề + menu
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            project.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                          ),
                        ),
                        PopupMenuButton(
                          onSelected: (value) {
                            FocusManager.instance.primaryFocus?.unfocus();
                            if (value == 'detail') {
                              taskController.updateCurrentProject(project);
                              Get.toNamed(AppRouters.projectDetail);
                            } else if (value == 'delete') {
                              Get.dialog(
                                AlertDialog(
                                  title: Text('confirm delete'.tr),
                                  content: Text(
                                      'are you sure want to delete this project?'
                                          .tr),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Get.back(),
                                      child: Text('cancel'.tr),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                        projectController.deleteProject(
                                          project.id,
                                          project.owner,
                                          project.attachments,
                                        );
                                      },
                                      child: Text('delete'.tr),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          itemBuilder: (_) => [
                            PopupMenuItem(
                                value: 'detail', child: Text('Detail'.tr)),
                            PopupMenuItem(
                                value: 'delete', child: Text('delete'.tr)),
                          ],
                          icon: const ImageIcon(
                              AssetImage('assets/icons/icons8-dots-90.png'),
                              size: 18),
                        ),
                      ],
                    ),

                    // Progress
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text('Task Done: ',
                                style: Theme.of(context).textTheme.bodyMedium),
                            Text(
                              '$done/${tasks.length}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Text('${(progress * 100).toStringAsFixed(0)}%'),
                      ],
                    ),
                    Container(
                      height: 5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: LinearProgressIndicator(
                        value: progress,
                        borderRadius: BorderRadius.circular(10),
                        valueColor: const AlwaysStoppedAnimation(Colors.blue),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Priority + Status
                    Row(
                      children: [
                        Container(
                          height: 25,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            color: getPriorityColor(project.priority),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            project.priority.name.tr,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          height: 25,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            color: getStatusColor(project.status),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            project.status.name.tr,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Ngày, đính kèm và người dùng
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_month),
                            const SizedBox(width: 10),
                            Text(
                              DateFormat('MM/dd/yyyy, HH:mm')
                                  .format(project.startDate),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.link_outlined),
                            const SizedBox(width: 4),
                            Text('$amountAttachment',
                                style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(width: 10),
                            SizedBox(
                              height: 35,
                              width: users.length == 1
                                  ? (30 * users.length.toDouble()) + 10
                                  : users.length > 2
                                      ? (30 * 3) - 2
                                      : (30 * 2) + 4,
                              child: Stack(
                                children: [
                                  for (int i = 0;
                                      i < (users.length < 3 ? users.length : 3);
                                      i++)
                                    i > 1
                                        ? Positioned(
                                            left: 24.0 * i,
                                            child: BuildPlusAvatar(
                                                count: users.length - 2),
                                          )
                                        : Positioned(
                                            left: 24.0 * i,
                                            child: BuildAvatar(
                                                user: users[i], size: 16),
                                          ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
