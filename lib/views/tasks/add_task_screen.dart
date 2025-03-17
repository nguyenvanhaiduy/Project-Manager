import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project_manager/controllers/auth/auth_controller.dart';
import 'package:project_manager/controllers/project/add_project_controller.dart';
import 'package:project_manager/controllers/project/project_controller.dart';
import 'package:project_manager/controllers/task/task_controller.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/models/task.dart';
import 'package:project_manager/models/user.dart';
import 'package:project_manager/utils/color_utils.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class AddTaskScreen extends StatelessWidget {
  AddTaskScreen({
    super.key,
  });

  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();

  final ProjectController projectController = Get.find();
  final AuthController authController = Get.find();
  final TaskController taskController = Get.find();
  final AddProjectController addProjectController =
      Get.put(AddProjectController());

  late final taskID = const Uuid().v4();
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final TextEditingController startDateController;
  late final TextEditingController dueDateController;
  late final TextEditingController emailController;
  late RxInt selectedStatus;
  late RxInt selectedPriority;
  late RxInt selectedComplexity;
  final argument = Get.arguments;

  @override
  Widget build(BuildContext context) {
    final RxList<User> assignFors = <User>[].obs;
    final Project project = Project.fromMap(data: argument['project']);
    final bool isAddTask = argument['isAddTask']; // false is edit task
    final Task? task =
        argument['task'] != null ? Task.fromMap(data: argument['task']) : null;

    Future<void> getAssignUser() async {
      final user = await projectController.getUser(userId: task!.assignTo);
      if (user != null) {
        assignFors.add(user);
      }
    }

    if (isAddTask) {
      titleController = TextEditingController();
      descriptionController = TextEditingController();
      startDateController = TextEditingController();
      dueDateController = TextEditingController();
      emailController = TextEditingController();
      selectedStatus = 0.obs;
      selectedPriority = 0.obs;
      selectedComplexity = 0.obs;
    } else {
      if (task != null) {
        titleController = TextEditingController(text: task.title);
        descriptionController = TextEditingController(text: task.description);
        startDateController = TextEditingController(
            text: DateFormat('MM/dd/yyyy, HH:mm').format(task.startDate));
        dueDateController = TextEditingController(
            text: DateFormat('MM/dd/yyyy, HH:mm').format(task.endDate));
        emailController = TextEditingController();
        selectedStatus = Status.values.indexOf(task.status).obs;
        selectedPriority = Priority.values.indexOf(task.priority).obs;
        selectedComplexity = Complexity.values.indexOf(task.complexity).obs;
        Future.wait([getAssignUser()]);
      } else {
        Get.snackbar(
            'Error', 'You need to transmit the task to have edit task');
      }
    }

    final RxList<User?> listUsers = <User?>[].obs;

    Future<void> getUsers() async {
      final users = await Future.wait(
          project.userIds.map((id) => projectController.getUser(userId: id)));
      listUsers.assignAll(users); // Chuyển thành RxList<User?>
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(isAddTask ? 'create task'.tr : 'edit task'.tr),
        ),
        body: FutureBuilder(
            future: getUsers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                return SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              color: Get.isDarkMode
                                  ? Colors.white10
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: TextFormField(
                            autofocus: isAddTask ? true : false,
                            controller: titleController,
                            decoration: InputDecoration(
                              hintText: 'enter task name'.tr,
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'you must enter task name'.tr;
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              color: Get.isDarkMode
                                  ? Colors.white10
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: TextFormField(
                            controller: descriptionController,
                            decoration: InputDecoration(
                              hintText: 'enter task description'.tr,
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                            ),
                            maxLines: null, // This allows multiple lines

                            // validator: (value) {
                            //   if (value == null || value.isEmpty) {
                            //     return 'you must enter task description'.tr;
                            //   }
                            //   return null;
                            // },
                          ),
                        ),
                        const SizedBox(height: 25),
                        MediaQuery.of(context).size.width >= 480
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  _customWidget(
                                    icon: Icons.edit_calendar_outlined,
                                    title: 'start date'.tr,
                                    color: Colors.yellow[700]!,
                                    controller: startDateController,
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100),
                                        initialDate: DateTime.now(),
                                      );
                                      if (pickedDate != null) {
                                        TimeOfDay? pickedTime =
                                            await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        );

                                        if (pickedTime != null) {
                                          DateTime pickedDateTime = DateTime(
                                            pickedDate.year,
                                            pickedDate.month,
                                            pickedDate.day,
                                            pickedTime.hour,
                                            pickedTime.minute,
                                          );
                                          startDateController.text =
                                              DateFormat('MM/dd/yyyy, HH:mm')
                                                  .format(pickedDateTime);
                                        }
                                      }
                                    },
                                    onValidator: (value) {
                                      if (value == null ||
                                          value.isEmpty ||
                                          value == 'start date'.tr) {
                                        return 'you must enter task start date'
                                            .tr;
                                      }

                                      return null;
                                    },
                                  ),
                                  _customWidget(
                                    icon: Icons.edit_calendar_outlined,
                                    title: 'due date'.tr,
                                    color: Colors.yellow[700]!,
                                    controller: dueDateController,
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100),
                                        initialDate: DateTime.now(),
                                      );
                                      if (pickedDate != null) {
                                        TimeOfDay? pickedTime =
                                            await showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now());
                                        if (pickedTime != null) {
                                          DateTime pickedDateTime = DateTime(
                                              pickedDate.year,
                                              pickedDate.month,
                                              pickedDate.day,
                                              pickedTime.hour,
                                              pickedTime.minute);
                                          dueDateController.text =
                                              DateFormat('MM/dd/yyyy, HH:mm')
                                                  .format(pickedDateTime);
                                        }
                                      }
                                    },
                                    onValidator: (value) {
                                      if (value == null ||
                                          value.isEmpty ||
                                          value == 'due date'.tr) {
                                        return 'you must enter task due date'
                                            .tr;
                                      }
                                      if (startDateController.text.isNotEmpty &&
                                          DateFormat('MM/dd/yyyy, HH:mm')
                                              .parse(value)
                                              .isBefore(DateFormat(
                                                      'MM/dd/yyyy, HH:mm')
                                                  .parse(startDateController
                                                      .text))) {
                                        return 'due date must be after start date'
                                            .tr;
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _customWidget(
                                    icon: Icons.edit_calendar_outlined,
                                    title: 'Start Date',
                                    color: Colors.yellow[700]!,
                                    controller: startDateController,
                                    hintText: 'start date'.tr,
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100),
                                        initialDate: DateTime.now(),
                                      );
                                      if (pickedDate != null) {
                                        TimeOfDay? pickedTime =
                                            await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        );

                                        if (pickedTime != null) {
                                          DateTime pickedDateTime = DateTime(
                                            pickedDate.year,
                                            pickedDate.month,
                                            pickedDate.day,
                                            pickedTime.hour,
                                            pickedTime.minute,
                                          );
                                          startDateController.text =
                                              DateFormat('MM/dd/yyyy, HH:mm')
                                                  .format(pickedDateTime);
                                        }
                                      }
                                    },
                                    onValidator: (value) {
                                      if (value == null ||
                                          value.isEmpty ||
                                          value == 'start date'.tr) {
                                        return 'you must enter task start date'
                                            .tr;
                                      }
                                      // if(startDateController.text.isNotEmpty && DateFormat('MM/dd/yyyy, hh:mm a').parse(value).isbe)
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  _customWidget(
                                    icon: Icons.edit_calendar_outlined,
                                    title: 'Due Date',
                                    color: Colors.yellow[700]!,
                                    controller: dueDateController,
                                    hintText: 'due date'.tr,
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100),
                                        initialDate: DateTime.now(),
                                      );
                                      if (pickedDate != null) {
                                        TimeOfDay? pickedTime =
                                            await showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now());
                                        if (pickedTime != null) {
                                          DateTime pickedDateTime = DateTime(
                                            pickedDate.year,
                                            pickedDate.month,
                                            pickedDate.day,
                                            pickedTime.hour,
                                            pickedTime.minute,
                                          );
                                          dueDateController.text =
                                              DateFormat('MM/dd/yyyy, HH:mm')
                                                  .format(pickedDateTime);
                                        }
                                      }
                                    },
                                    onValidator: (value) {
                                      if (value == null ||
                                          value.isEmpty ||
                                          value == 'due date'.tr) {
                                        return 'you must enter task due date'
                                            .tr;
                                      }
                                      if (startDateController.text.isNotEmpty &&
                                          DateFormat('MM/dd/yyyy, HH:mm')
                                              .parse(value)
                                              .isBefore(DateFormat(
                                                      'MM/dd/yyyy, HH:mm')
                                                  .parse(startDateController
                                                      .text))) {
                                        return 'due date must be after start date'
                                            .tr;
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                        const SizedBox(height: 15),
                        const Divider(thickness: 0, height: 0),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple[200]!,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.person_outline,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'assigned to'.tr,
                                style: Get.textTheme.bodyLarge!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: Obx(() => ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: assignFors.length,
                                      itemBuilder: (context, index) {
                                        final user = assignFors[index];
                                        return Stack(
                                          children: [
                                            user.imageUrl != null
                                                ? Stack(
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundImage:
                                                            NetworkImage(
                                                                user.imageUrl!),
                                                      ),
                                                    ],
                                                  )
                                                : CircleAvatar(
                                                    backgroundColor:
                                                        listUsers[index]!.color,
                                                    foregroundColor:
                                                        getContrastingTextColor(
                                                            user.color!),
                                                    child: Text(user.name[0]
                                                        .toUpperCase()),
                                                  ),
                                            if (index != 0)
                                              Positioned(
                                                right: 0,
                                                top: 0,
                                                child: InkWell(
                                                  child: const CircleAvatar(
                                                    radius: 6,
                                                    backgroundImage: AssetImage(
                                                      'assets/icons/icons8-cancel-48.png',
                                                    ),
                                                    backgroundColor:
                                                        Colors.grey,
                                                  ),
                                                  onTap: () {
                                                    listUsers.removeAt(index);
                                                  },
                                                ),
                                              ),
                                          ],
                                        );
                                      })),
                                ),
                                IconButton.outlined(
                                  style: IconButton.styleFrom(
                                    backgroundColor: Get.isDarkMode
                                        ? Colors.white10
                                        : Colors.white,
                                  ),
                                  onPressed: () async {
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
                                                controller: emailController,
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  hintText:
                                                      'enter user email'.tr,
                                                ),
                                                validator: (value) {
                                                  final user = assignFors
                                                      .firstWhereOrNull((user) {
                                                    return user.email ==
                                                        emailController.text;
                                                  });
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
                                                  if (_formKey1.currentState!
                                                      .validate()) {
                                                    final user = listUsers
                                                        .firstWhereOrNull(
                                                            (user) =>
                                                                user?.email ==
                                                                emailController
                                                                    .text);

                                                    if (user != null) {
                                                      emailController.clear();
                                                      Get.back();
                                                      assignFors.add(user);
                                                      // Get.snackbar('Successful',
                                                      //     '${user.name} added to project',
                                                      //     colorText: Colors.green);
                                                    } else {
                                                      Get.closeAllSnackbars();
                                                      Get.snackbar('Error',
                                                          'This account has not been added to the project',
                                                          colorText:
                                                              Colors.red);
                                                    }
                                                  }
                                                },
                                                child: Text('add'.tr),
                                              ),
                                            ],
                                          ),
                                        ),
                                        onPopInvoked: (didPop) {
                                          emailController.clear();
                                        },
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.add),
                                ),
                                // Spacer(
                                //   flex: 3,
                                // )
                              ],
                            )),
                        _customDivider(),
                        _customWidget(
                          icon: Icons.flag_outlined,
                          title: 'priority'.tr,
                          color: Colors.green[200]!,
                          isTextField: false,
                        ),
                        const SizedBox(height: 15),
                        Container(
                          height: 35,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              const SizedBox(width: 20),
                              _customLablePriority(context, Priority.low, () {
                                selectedPriority.value = 0;
                              }),
                              const SizedBox(width: 20),
                              _customLablePriority(context, Priority.medium,
                                  () {
                                selectedPriority.value = 1;
                              }),
                              const SizedBox(width: 20),
                              _customLablePriority(context, Priority.high, () {
                                selectedPriority.value = 2;
                              }),
                            ],
                          ),
                        ),
                        _customDivider(),
                        _customWidget(
                          icon: Icons.flag_outlined,
                          title: 'complexity'.tr,
                          color: Colors.green[200]!,
                          isTextField: false,
                        ),
                        const SizedBox(height: 15),
                        Container(
                          height: 35,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              const SizedBox(width: 20),
                              _customLabelComplexity(context, Complexity.easy,
                                  () {
                                selectedComplexity.value = 0;
                              }),
                              const SizedBox(width: 20),
                              _customLabelComplexity(context, Complexity.medium,
                                  () {
                                selectedComplexity.value = 1;
                              }),
                              const SizedBox(width: 20),
                              _customLabelComplexity(context, Complexity.hard,
                                  () {
                                selectedComplexity.value = 2;
                              }),
                              const SizedBox(width: 20),
                              _customLabelComplexity(
                                  context, Complexity.veryHard, () {
                                selectedComplexity.value = 3;
                              }),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                Get.closeAllSnackbars();
                                Future.delayed(
                                    const Duration(milliseconds: 600));
                                if (isAddTask) {
                                  await taskController.addTask(Task(
                                    title: titleController.text,
                                    description: descriptionController.text,
                                    startDate: DateFormat('MM/dd/yyyy, HH:mm')
                                        .parse(startDateController.text),
                                    endDate: DateFormat('MM/dd/yyyy, HH:mm')
                                        .parse(dueDateController.text),
                                    status: Status.notStarted,
                                    priority:
                                        Priority.values[selectedPriority.value],
                                    assignTo: assignFors.isNotEmpty
                                        ? assignFors.first.id
                                        : '',
                                    projectOwner: project.id,
                                    complexity: Complexity
                                        .values[selectedComplexity.value],
                                  ));
                                  await projectController.updateProject(
                                    Project(
                                      id: project.id,
                                      title: project.title,
                                      description: project.description,
                                      status: project.status,
                                      priority: project.priority,
                                      startDate: project.startDate,
                                      endDate: project.endDate,
                                      taskIds: taskController.tasks
                                          .map((e) => e.id)
                                          .toList(),
                                      userIds: project.userIds,
                                      attachments: project.attachments,
                                      owner: project.owner,
                                    ),
                                  );
                                } else {
                                  await taskController.updateTask(Task(
                                    id: task!.id,
                                    title: titleController.text,
                                    description: descriptionController.text,
                                    startDate: DateFormat('MM/dd/yyyy, HH:mm')
                                        .parse(startDateController.text),
                                    endDate: DateFormat('MM/dd/yyyy, HH:mm')
                                        .parse(dueDateController.text),
                                    status: Status.values[selectedStatus.value],
                                    priority:
                                        Priority.values[selectedPriority.value],
                                    assignTo: assignFors.isNotEmpty
                                        ? assignFors.first.id
                                        : '',
                                    projectOwner: project.id,
                                    complexity: Complexity
                                        .values[selectedComplexity.value],
                                  ));
                                }
                              }
                            },
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Get.isDarkMode
                                  ? Colors.black38
                                  : Colors.white,
                              foregroundColor:
                                  Get.isDarkMode ? Colors.white : Colors.black,
                            ),
                            child: Container(
                              constraints: const BoxConstraints(
                                minWidth: 100,
                                maxWidth: 300,
                              ),
                              height: kIsWeb ? 50 : 40,
                              alignment: Alignment.center,
                              child: Text(
                                isAddTask ? 'create task'.tr : 'update'.tr,
                                style: Get.textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
            }));
  }

  Widget _customWidget(
      {required IconData icon,
      required String title,
      required Color color,
      String? hintText,
      TextEditingController? controller,
      Function()? onTap,
      String? Function(String?)? onValidator,
      bool isTextField = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
            ),
          ),
          const SizedBox(width: 10),
          isTextField
              ? SizedBox(
                  width: 220,
                  child: TextFormField(
                    readOnly: true,
                    controller: controller,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: title,
                    ),
                    onTap: onTap,
                    validator: onValidator,
                  ),
                )
              : GestureDetector(
                  onTap: onTap,
                  child: Text(
                    title,
                    style: Get.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _customLablePriority(
      BuildContext context, Priority priority, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Obx(
        () => Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            color: selectedPriority.value == priority.index
                ? getPriorityColor(priority)
                : null,
            borderRadius: BorderRadius.circular(15),
          ),
          alignment: Alignment.center,
          child: Text(
            priority.name.tr,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  color: selectedPriority.value == priority.index
                      ? Colors.black
                      : null,
                ),
          ),
        ),
      ),
    );
  }

  Widget _customLabelComplexity(
      BuildContext context, Complexity complexity, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Obx(
        () => Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            color: selectedComplexity.value == complexity.index
                ? getComplexityColor(complexity)
                : null,
            borderRadius: BorderRadius.circular(15),
          ),
          alignment: Alignment.center,
          child: Text(
            complexity.name.tr,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  color: selectedComplexity.value == complexity.index
                      ? Colors.black
                      : null,
                ),
          ),
        ),
      ),
    );
  }

  Widget _customDivider() {
    return const Column(
      children: [
        SizedBox(height: 15),
        Divider(thickness: 0, height: 0),
        SizedBox(height: 15),
      ],
    );
  }
}
