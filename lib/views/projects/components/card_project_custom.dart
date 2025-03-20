import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project_manager/controllers/auth/auth_controller.dart';
import 'package:project_manager/controllers/project/project_controller.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/models/user.dart';
import 'package:project_manager/utils/color_utils.dart';
import 'package:project_manager/views/projects/components/build_avatar.dart';
import 'package:project_manager/views/projects/components/build_plus_avatar.dart';

class CardProjectCustom extends StatelessWidget {
  CardProjectCustom({super.key, required this.onTap, required this.project});
  final AuthController authController = Get.find();
  final ProjectController projectController = Get.find();
  final Project project;
  final Function() onTap;
  final RxList<User> assignedForArr = <User>[].obs;

  Future<void> _fetchUsers() async {
    await Future.wait(
      project.userIds.map((userId) async {
        final user = await projectController.getUser(userId: userId);
        if (user != null) {
          assignedForArr.add(user);
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    _fetchUsers();
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Get.isDarkMode ? Colors.black26 : Colors.white,
          border: Border.all(
            style: BorderStyle.solid,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    project.title,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                // IconButton(
                //   onPressed: () {},
                //   icon: const ImageIcon(
                //     AssetImage(
                //       'assets/icons/icons8-dots-90.png',
                //     ),
                //     size: 18,
                //   ),
                // ),
                PopupMenuButton(
                  onSelected: (value) {
                    if (value == 'delete') {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('confirm delete'.tr),
                          content: Text(
                              'are you sure want to delete this project?'.tr),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text('cancel'.tr),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.closeAllSnackbars();
                                Get.back();
                                projectController.deleteProject(
                                  project.id,
                                  project.owner,
                                  project.attachments,
                                );
                              },
                              child: Text('delete'.tr),
                            )
                          ],
                        ),
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('delete'.tr),
                    ),
                  ],
                  icon: const ImageIcon(
                    AssetImage(
                      'assets/icons/icons8-dots-90.png',
                    ),
                    size: 18,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  height: 30,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: getPriorityColor(project.priority),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    project.priority.name.tr,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  height: 30,
                  decoration: BoxDecoration(
                    color: getStatusColor(project.status),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    project.status.name.tr,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_month),
                    const SizedBox(width: 10),
                    Text(
                      DateFormat('MM/dd/yyyy, HH:mm').format(project.startDate),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(
                  height: 35,
                  width: project.userIds.length == 1
                      ? (30 * project.userIds.length.toDouble()) + 10
                      : project.userIds.length > 2
                          ? (30 * 3) - 2
                          : (30 * 2) + 4,
                  child: Stack(
                    children: [
                      for (int i = 0;
                          i <
                              (project.userIds.length < 3
                                  ? project.userIds.length
                                  : 3);
                          i++)
                        StreamBuilder<User?>(
                            stream: Stream.fromFuture(projectController.getUser(
                                userId: project.userIds[i])),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const SizedBox();
                              } else if (!snapshot.hasData) {
                                return const Icon(Icons.person);
                              } else {
                                return i > 1
                                    ? Positioned(
                                        left: 24.0 * i,
                                        child: BuildPlusAvatar(
                                          count: project.userIds.length - 2,
                                        ))
                                    : Positioned(
                                        left: 24.0 * i,
                                        child: BuildAvatar(
                                          user: snapshot.data!,
                                          size: 16,
                                        ));
                              }
                            })
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
