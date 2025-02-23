import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project_manager/controllers/auth/auth_controller.dart';
import 'package:project_manager/controllers/project/progress_project_controller.dart';
import 'package:project_manager/controllers/project/project_controller.dart';
import 'package:project_manager/controllers/project/project_detail_controller.dart';
import 'package:project_manager/controllers/task/task_controller.dart';
import 'package:project_manager/controllers/theme_controller.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/models/user.dart';
import 'package:project_manager/utils/color_utils.dart';
import 'package:project_manager/views/projects/components/build_avatar.dart';
import 'package:project_manager/views/tasks/table_of_mission_screen.dart';
import 'package:project_manager/views/tasks/your_task_screen.dart';
import 'package:project_manager/views/widgets/widgets.dart';

class ProjectDetailScreen extends StatelessWidget {
  ProjectDetailScreen({super.key});

  final ThemeController themeController = Get.find();
  final AuthController authController = Get.find();
  final GlobalKey _buttonStatusKey =
      GlobalKey(); // Tạo GlobalKey cho OutlinedButton
  final GlobalKey _buttonPriorityKey = GlobalKey();
  final _formKey1 = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  final ProjectController projectController = Get.find();
  final ProjectDetailController projectDetailController =
      Get.put(ProjectDetailController());

  final emailController = TextEditingController();

  final TaskController taskController = Get.find();

  Future<void> confirmDeleteUser(String name, String id) async {
    await Get.dialog(
      barrierDismissible: true,
      Center(
        child: Container(
          width: 300,
          clipBehavior: Clip.hardEdge,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Get.isDarkMode ? Colors.white12 : Colors.white,
          ),
          child: Material(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'confirm delete'.tr,
                  style: Get.textTheme.bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'are you sure you want to delete'.tr,
                          style: Get.textTheme.bodyLarge,
                          children: [
                            TextSpan(
                                text: name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            TextSpan(text: 'out of the project?'.tr),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(),
                            onPressed: () {
                              Get.back();
                            },
                            child: Text(
                              'no'.tr,
                              // style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                // backgroundColor: Colors.white,
                                ),
                            onPressed: () {
                              // print(listUserIdsCopy.length);

                              projectDetailController.removeUser(id);
                              Get.back();
                            },
                            child: Text('yes'.tr),
                          ),
                        ],
                      )
                    ],
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final project = taskController.currentProject.value!;
    final isOwner = project.owner == authController.currentUser.value!.id;
    final titleController =
        TextEditingController(text: projectDetailController.title.value);
    final descriptionController =
        TextEditingController(text: projectDetailController.description.value);
    final startDateController =
        TextEditingController(text: projectDetailController.startDate.value);
    final dueDateController =
        TextEditingController(text: projectDetailController.dueDate.value);

    void updateTextControllers() {
      titleController.text = projectDetailController.title.value;
      descriptionController.text = projectDetailController.description.value;
      startDateController.text = projectDetailController.startDate.value;
      dueDateController.text = projectDetailController.dueDate.value;
    }

    // final progressProjectController = Get.put(ProgressProjectController());

    void closeController() {
      // projectDetailController.dispose();
      // titleController.dispose();
      // descriptionController.dispose();
      // startDateController.dispose();
      // dueDateController.dispose();
      // projectDetailController.dispose();
      print('close all controller');
    }

    void changeStatusIndex(int value) {
      projectDetailController.selectStatusIndex.value = value;
    }

    void changePriorityIndex(int value) {
      projectDetailController.selectPriorityIndex.value = value;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('project detail'.tr),
        actions: [
          IconButton(
            onPressed: () {
              if (projectDetailController.hasChanges.value) {
                customDialogConfirm(
                    'you have unsaved changes. are you sure you want to exit?',
                    () {
                  Get.to(() => YourTaskScreen());
                  print(projectDetailController.description);
                  projectDetailController.revertChanges();
                  updateTextControllers();
                });
              } else {
                Get.to(() => YourTaskScreen());
              }
            },
            icon: const Icon(Icons.pending_actions_outlined, size: 30),
            tooltip: 'your task'.tr,
          )
        ],
      ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return; // Already handled elsewhere
          bool shouldPop;
          if (projectDetailController.hasChanges.value) {
            shouldPop = await customDialogConfirm(
                'you have unsaved changes. are you sure you want to exit?', () {
              projectDetailController.revertChanges();
            });
          } else {
            shouldPop = true;
          }
          if (shouldPop) {
            Get.back();
            closeController();
          }
        },
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                customTextField(
                  context,
                  titleController,
                  'name'.tr,
                  Icons.edit,
                  (value) {
                    if (value == null || value.isEmpty) {
                      return 'you must enter your project name'.tr;
                    }
                    return null;
                  },
                  themeController,
                  readOnly: !isOwner,
                  textValue: projectDetailController.title,
                ),
                const SizedBox(height: 20),
                customTextField(
                  context,
                  descriptionController,
                  'description'.tr,
                  Icons.edit,
                  (value) {
                    if (value == null || value.isEmpty) {
                      return 'you must enter your project description'.tr;
                    }
                    return null;
                  },
                  themeController,
                  readOnly: !isOwner,
                  textValue: projectDetailController.description,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: customTextField(
                          context,
                          startDateController,
                          'start date'.tr,
                          Icons.edit_calendar,
                          (value) {
                            return null;
                          },
                          onTap: () async {
                            if (isOwner) {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100));
                              if (pickedDate != null) {
                                TimeOfDay? pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                DateTime pickedDateTime = DateTime(
                                  pickedDate.year,
                                  pickedDate.hour,
                                  pickedDate.day,
                                  pickedTime?.hour ?? DateTime.now().hour,
                                  pickedTime?.minute ?? DateTime.now().minute,
                                );

                                startDateController.text =
                                    DateFormat('MM/dd/yyyy, HH:mm')
                                        .format(pickedDateTime);
                              }
                            }
                          },
                          themeController,
                          readOnly: true,
                          textValue: projectDetailController.startDate,
                        ),
                      ),
                      Expanded(
                        child: customTextField(
                          context,
                          dueDateController,
                          'due date'.tr,
                          Icons.edit_calendar,
                          (value) {
                            if (DateFormat('MM/dd/yyy, HH:mm')
                                .parse(value!)
                                .isBefore(DateFormat('MM/dd/yyyy, HH:mm')
                                    .parse(startDateController.text))) {
                              return 'due date must be after start date'.tr;
                            }
                            return null;
                          },
                          onTap: () async {
                            if (isOwner) {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100));
                              if (pickedDate != null) {
                                TimeOfDay? pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                DateTime pickedDateTime = DateTime(
                                  pickedDate.year,
                                  pickedDate.hour,
                                  pickedDate.day,
                                  pickedTime?.hour ?? DateTime.now().hour,
                                  pickedTime?.minute ?? DateTime.now().minute,
                                );
                                dueDateController.text =
                                    DateFormat('MM/dd/yyyy, HH:mm')
                                        .format(pickedDateTime);
                              }
                            }
                          },
                          themeController,
                          readOnly: true,
                          textValue: projectDetailController.dueDate,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                const Divider(),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'status'.tr,
                        style: Get.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Obx(
                        () => OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: getStatusColor(
                              Status.values[projectDetailController
                                  .selectStatusIndex.value],
                            ),
                            foregroundColor: Colors.white,
                          ),
                          key: _buttonStatusKey,
                          onPressed: () async {
                            if (isOwner) {
                              final RenderBox button = _buttonStatusKey
                                  .currentContext!
                                  .findRenderObject() as RenderBox;
                              final RenderBox overlay = Overlay.of(context)
                                  .context
                                  .findRenderObject() as RenderBox;
                              final Offset buttonPosition =
                                  button.localToGlobal(Offset.zero,
                                      ancestor: overlay);
                              await showMenu(
                                  initialValue:
                                      projectDetailController.selectStatusIndex,
                                  context: context,
                                  position: RelativeRect.fromRect(
                                    Rect.fromPoints(
                                      buttonPosition,
                                      buttonPosition.translate(
                                          button.size.width,
                                          button.size.height),
                                    ),
                                    Offset.zero & overlay.size,
                                  ),
                                  items: Status.values
                                      .map((e) => PopupMenuItem(
                                            child: Text(e.name.tr),
                                            onTap: () {
                                              changeStatusIndex(e.index);
                                            },
                                          ))
                                      .toList());
                            }
                          },
                          child: Text(
                            Status
                                .values[projectDetailController
                                    .selectStatusIndex.value]
                                .name
                                .tr,
                            style: Get.textTheme.bodyLarge!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'assigned to'.tr,
                        style: Get.textTheme.bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 35,
                        width: MediaQuery.of(context).size.width * 0.55,
                        child: Obx(
                          () => Stack(
                            fit: StackFit.expand,
                            alignment: Alignment.centerRight,
                            children: [
                              for (int i = 0;
                                  i <= projectDetailController.userIds.length;
                                  i++)
                                if (i == projectDetailController.userIds.length)
                                  if (isOwner)
                                    Positioned(
                                      right: i * 24,
                                      child: GestureDetector(
                                        onTap: () async {
                                          await Get.defaultDialog(
                                            title: 'add members'.tr,
                                            titleStyle: TextStyle(
                                                color: Get.isDarkMode
                                                    ? Colors.white
                                                    : Colors.black),
                                            content: Form(
                                              key: _formKey1,
                                              child: SingleChildScrollView(
                                                keyboardDismissBehavior:
                                                    ScrollViewKeyboardDismissBehavior
                                                        .onDrag,
                                                child: Column(
                                                  children: [
                                                    TextFormField(
                                                      controller:
                                                          emailController,
                                                      autofocus: true,
                                                      decoration:
                                                          InputDecoration(
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        hintText:
                                                            'enter user email'
                                                                .tr,
                                                      ),
                                                      validator: (value) {
                                                        final user =
                                                            projectDetailController
                                                                .userIds
                                                                .firstWhereOrNull(
                                                          (email) =>
                                                              email ==
                                                              emailController
                                                                  .text,
                                                        );
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'you must enter user email'
                                                              .tr;
                                                        }
                                                        if (user != null) {
                                                          return 'user already exists'
                                                              .tr;
                                                        }
                                                        if (!GetUtils.isEmail(
                                                            value)) {
                                                          return 'please enter a valid email'
                                                              .tr;
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                    const SizedBox(height: 10),
                                                    TextButton(
                                                      onPressed: () async {
                                                        if (_formKey1
                                                            .currentState!
                                                            .validate()) {
                                                          final user =
                                                              await projectController
                                                                  .getUser(
                                                                      email: emailController
                                                                          .text);
                                                          if (user != null) {
                                                            if (!projectDetailController
                                                                .userIds
                                                                .contains(
                                                                    user.id)) {
                                                              emailController
                                                                  .clear();
                                                              Get.back();
                                                              projectDetailController
                                                                  .userIds
                                                                  .add(user.id);
                                                            } else {
                                                              Get.snackbar(
                                                                  'Error',
                                                                  'This user was in the project',
                                                                  colorText:
                                                                      Colors
                                                                          .red,
                                                                  duration:
                                                                      const Duration(
                                                                          seconds:
                                                                              1));
                                                            }
                                                          } else {
                                                            Get.snackbar(
                                                                'Error',
                                                                'This account does not exist',
                                                                colorText:
                                                                    Colors.red,
                                                                duration:
                                                                    const Duration(
                                                                        seconds:
                                                                            1));
                                                          }
                                                        }
                                                      },
                                                      child: Text('add'.tr),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // ignore: deprecated_member_use
                                              onPopInvoked: (didPop) {
                                                emailController.clear();
                                              },
                                            ),
                                          );
                                        },
                                        child: const CircleAvatar(
                                          radius: 17.5,
                                          backgroundColor: Colors.redAccent,
                                          child: Icon(Icons.add),
                                        ),
                                      ),
                                    )
                                  else
                                    const SizedBox()
                                else
                                  StreamBuilder<User?>(
                                    stream: Stream.fromFuture(
                                        projectController.getUser(
                                            userId: projectDetailController
                                                .userIds[i])),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Container();
                                      } else if (snapshot.hasError) {
                                        return const Icon(Icons.error);
                                      } else if (!snapshot.hasData ||
                                          snapshot.data == null) {
                                        return const SizedBox();
                                      } else {
                                        return Positioned(
                                          right: i *
                                              24.0, // Điều chỉnh khoảng cách giữa các avatar
                                          child: GestureDetector(
                                            onTap: () async {
                                              if (isOwner) {
                                                if (snapshot.data!.id !=
                                                    project.owner) {
                                                  await confirmDeleteUser(
                                                    snapshot.data!.name,
                                                    snapshot.data!.id,
                                                  );
                                                }
                                              }
                                            },
                                            child: Tooltip(
                                              message: snapshot.data!.name,
                                              child: BuildAvatar(
                                                user: snapshot.data!,
                                                size: 17.5,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'priority'.tr,
                        style: Get.textTheme.bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Obx(
                        () => OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: getPriorityColor(Priority.values[
                                projectDetailController
                                    .selectPriorityIndex.value]),
                            foregroundColor: Colors.white,
                            // side: BorderSide(
                            //   color: Get.isDarkMode ? Colors.white : Colors.black,
                            //   width: 1,
                            // ),
                          ),
                          key: _buttonPriorityKey,
                          onPressed: () async {
                            if (isOwner) {
                              final RenderBox button = _buttonPriorityKey
                                  .currentContext!
                                  .findRenderObject() as RenderBox;
                              final RenderBox overlay = Overlay.of(context)
                                  .context
                                  .findRenderObject() as RenderBox;
                              final Offset buttonPosition =
                                  button.localToGlobal(Offset.zero,
                                      ancestor: overlay);
                              await showMenu(
                                context: context,
                                position: RelativeRect.fromRect(
                                    Rect.fromPoints(
                                        buttonPosition,
                                        buttonPosition.translate(
                                            button.size.width,
                                            button.size.height)),
                                    Offset.zero & overlay.size),
                                items: Priority.values
                                    .map((e) => PopupMenuItem(
                                          child: Text(e.name.tr),
                                          onTap: () {
                                            changePriorityIndex(e.index);
                                          },
                                        ))
                                    .toList(),
                              );
                            }
                          },
                          child: Text(
                            Priority
                                .values[projectDetailController
                                    .selectPriorityIndex.value]
                                .name
                                .tr,
                            style: Get.textTheme.bodyLarge!.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                const Divider(),
                const SizedBox(height: 15),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Get.isDarkMode ? Colors.white10 : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 15),
                            Padding(
                              padding: const EdgeInsets.only(right: 0),
                              child: SizedBox(
                                width: kIsWeb
                                    ? 170
                                    : (Platform.isAndroid ? 200 : 180),
                                child: Text(
                                  'project completion progress!'.tr,
                                  style: Get.textTheme.bodyLarge!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            TextButton(
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  // side: const BorderSide(width: 0.5),
                                  backgroundColor: Get.isDarkMode
                                      ? Colors.white12
                                      : const Color.fromARGB(
                                          255, 207, 234, 248),
                                ),
                                onPressed: () async {
                                  if (isOwner &&
                                      projectDetailController
                                          .hasChanges.value) {
                                    customDialogConfirm(
                                        'you have unsaved changes. are you sure you want to exit?',
                                        () {
                                      if (Get.isDialogOpen != null &&
                                          Get.isDialogOpen!) {
                                        Get.back();
                                      }
                                      projectDetailController.revertChanges();
                                      print(
                                          projectDetailController.description);
                                      updateTextControllers();

                                      Get.to(() => TableOfMissionScreen());
                                    });
                                  } else {
                                    Get.to(() => TableOfMissionScreen());
                                  }
                                  // Get.find<ProgressProjectController>()
                                  //     .currentValue
                                  //     .value = 0;
                                },
                                child: Text(
                                  'view details'.tr,
                                  style: Get.textTheme.bodyLarge!
                                      .copyWith(fontWeight: FontWeight.bold),
                                )),
                            const SizedBox(height: 15),
                          ],
                        ),
                      )),
                      Obx(
                        () {
                          final progressProjectController =
                              Get.find<ProgressProjectController>();
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                height: 80,
                                width: 80,
                                child: CircularProgressIndicator(
                                  value: progressProjectController
                                      .currentValue.value,
                                  strokeWidth: 20,
                                  semanticsValue: '1',
                                  backgroundColor: Get.isDarkMode
                                      ? Colors.white24
                                      : const Color.fromARGB(
                                          208, 229, 236, 241),
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                    Color.fromARGB(255, 150, 221, 253),
                                  ),
                                ),
                              ),
                              Positioned(
                                child: Text(
                                  '${(progressProjectController.currentValue.value * 100).toStringAsFixed(0)}%',
                                  style: Get.textTheme.bodyLarge!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(width: 30),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                isOwner
                    ? OutlinedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (projectDetailController.hasChanges.value) {
                              try {
                                final newProject = Project(
                                  id: project.id,
                                  title: titleController.text.trim(),
                                  description:
                                      descriptionController.text.trim(),
                                  status: Status.values[projectDetailController
                                      .selectStatusIndex.value],
                                  priority: Priority.values[
                                      projectDetailController
                                          .selectPriorityIndex.value],
                                  startDate: DateFormat('MM/dd/yyyy, HH:mm')
                                      .parse(startDateController.text),
                                  endDate: DateFormat('MM/dd/yyyy, HH:mm')
                                      .parse(dueDateController.text),
                                  taskIds: project.taskIds,
                                  userIds: projectDetailController.userIds,
                                  owner: project.owner,
                                );
                                await projectController
                                    .updateProject(newProject);
                                taskController.updateCurrentProject(newProject);
                                projectDetailController.hasChanges.value =
                                    false;
                              } catch (e) {
                                Get.snackbar(
                                    'Error', 'Can not update the project',
                                    colorText: Colors.red);
                              }
                            } else {
                              print('nothing update');
                            }
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 10),
                        ),
                        child: Text(
                          'Update Project',
                          style:
                              Get.textTheme.bodyLarge!.copyWith(fontSize: 20),
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
