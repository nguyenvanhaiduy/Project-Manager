import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project_manager/controllers/auth/auth_controller.dart';
import 'package:project_manager/controllers/project/add_project_controller.dart';
import 'package:project_manager/controllers/project/project_controller.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/models/user.dart';
import 'package:project_manager/utils/color_utils.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class AddProjectScreen extends StatelessWidget {
  AddProjectScreen({super.key});

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final ProjectController projectController = Get.find();
  final AuthController authController = Get.find();
  final AddProjectController addProjectController =
      Get.put(AddProjectController());

  final List<User> listUsers = <User>[].obs;

  final projectID = const Uuid().v4();

  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  final RxList<String> attachments = <String>[].obs;
  var count = 0;

  @override
  Widget build(BuildContext context) {
    if (count == 0) {
      listUsers.add(authController.currentUser.value!);
      count++;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'create project'.tr,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Get.isDarkMode ? Colors.white10 : Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: 'enter project name'.tr,
                    border:
                        const OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'you must enter project name'.tr;
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Get.isDarkMode ? Colors.white10 : Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    hintText: 'enter project description'.tr,
                    border:
                        const OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'you must enter project description'.tr;
                    }
                    return null;
                  },
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
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              initialDate: DateTime.now(),
                            );
                            if (pickedDate != null) {
                              TimeOfDay? pickedTime = await showTimePicker(
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
                              return 'you must enter project start date'.tr;
                            }

                            return null;
                          },
                        ),
                        _customWidget(
                          icon: Icons.edit_calendar_outlined,
                          title: 'Due Date',
                          color: Colors.yellow[700]!,
                          controller: dueDateController,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              initialDate: DateTime.now(),
                            );
                            if (pickedDate != null) {
                              TimeOfDay? pickedTime = await showTimePicker(
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
                              return 'you must enter project due date'.tr;
                            }
                            if (startDateController.text.isNotEmpty &&
                                DateFormat('MM/dd/yyyy, HH:mm')
                                    .parse(value)
                                    .isBefore(DateFormat('MM/dd/yyyy, HH:mm')
                                        .parse(startDateController.text))) {
                              return 'due date must be after start date'.tr;
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
                          title: 'start date'.tr,
                          color: Colors.yellow[700]!,
                          controller: startDateController,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              initialDate: DateTime.now(),
                            );
                            if (pickedDate != null) {
                              TimeOfDay? pickedTime = await showTimePicker(
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
                              return 'you must enter project start date'.tr;
                            }
                            // if(startDateController.text.isNotEmpty && DateFormat('MM/dd/yyyy, hh:mm a').parse(value).isbe)
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        _customWidget(
                          icon: Icons.edit_calendar_outlined,
                          title: 'due date'.tr,
                          color: Colors.yellow[700]!,
                          controller: dueDateController,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              initialDate: DateTime.now(),
                            );
                            if (pickedDate != null) {
                              TimeOfDay? pickedTime = await showTimePicker(
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
                              return 'you must enter project due date'.tr;
                            }
                            if (startDateController.text.isNotEmpty &&
                                DateFormat('MM/dd/yyyy, HH:mm')
                                    .parse(value)
                                    .isBefore(DateFormat('MM/dd/yyyy, HH:mm')
                                        .parse(startDateController.text))) {
                              return 'due date must be after start date'.tr;
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
                            itemCount: listUsers.length,
                            itemBuilder: (context, index) {
                              final user = listUsers[index];
                              return Stack(
                                children: [
                                  user.imageUrl != null
                                      ? Stack(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage:
                                                  NetworkImage(user.imageUrl!),
                                            ),
                                          ],
                                        )
                                      : CircleAvatar(
                                          backgroundColor: user.color,
                                          foregroundColor:
                                              getContrastingTextColor(
                                                  user.color!),
                                          child:
                                              Text(user.name[0].toUpperCase()),
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
                                          backgroundColor: Colors.grey,
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
                          backgroundColor:
                              Get.isDarkMode ? Colors.white10 : Colors.white,
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
                                    ScrollViewKeyboardDismissBehavior.onDrag,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: emailController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        hintText: 'enter user email'.tr,
                                      ),
                                      validator: (value) {
                                        final user = listUsers.firstWhereOrNull(
                                          (user) =>
                                              user.email ==
                                              emailController.text,
                                        );
                                        if (value == null || value.isEmpty) {
                                          return 'you must enter user email'.tr;
                                        }
                                        if (user != null) {
                                          return 'user already exists'.tr;
                                        }
                                        if (!GetUtils.isEmail(value)) {
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
                                          final user =
                                              await projectController.getUser(
                                                  email: emailController.text);
                                          if (user != null) {
                                            emailController.clear();
                                            Get.back();
                                            listUsers.add(user);
                                            // Get.snackbar('Successful',
                                            //     '${user.name} added to project',
                                            //     colorText: Colors.green);
                                          } else {
                                            Get.snackbar('Error',
                                                'This account does not exist',
                                                colorText: Colors.red);
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
              const SizedBox(height: 15),
              const Divider(thickness: 0, height: 0),
              const SizedBox(height: 15),
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
                      addProjectController.changePriority(0);
                    }),
                    const SizedBox(width: 20),
                    _customLablePriority(context, Priority.medium, () {
                      addProjectController.changePriority(1);
                    }),
                    const SizedBox(width: 20),
                    _customLablePriority(context, Priority.high, () {
                      addProjectController.changePriority(2);
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
                      await projectController.addProject(
                        Project(
                          id: projectID,
                          title: titleController.text,
                          description: descriptionController.text,
                          status: Status.notStarted,
                          priority: Priority.values[
                              addProjectController.selectedPriority.value],
                          startDate: DateFormat('MM/dd/yyyy, HH:mm')
                              .parse(startDateController.text),
                          endDate: DateFormat('MM/dd/yyyy, HH:mm')
                              .parse(dueDateController.text),
                          taskIds: [],
                          userIds: listUsers.map((user) => user.id).toList(),
                          // attachments: attachments,
                          owner: authController.currentUser.value!.id,
                        ),
                      );
                    }
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor:
                        Get.isDarkMode ? Colors.black38 : Colors.white,
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
                      'create project'.tr,
                      style: Get.textTheme.bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _customWidget(
      {required IconData icon,
      required String title,
      required Color color,
      TextEditingController? controller,
      Function()? onTap,
      String? Function(String?)? onValidator,
      bool isTextField = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
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
                        border: InputBorder.none, hintText: title),
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
            color: addProjectController.selectedPriority.value == priority.index
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
                  color: addProjectController.selectedPriority.value ==
                          priority.index
                      ? Colors.black
                      : null,
                ),
          ),
        ),
      ),
    );
  }

  // String getName(String name) {
  //   return '${name[0].toUpperCase()}${name.substring(1)}';
  // }

  // String getFileName(String url) {
  //   return url.split('/').last.split("?").first;
  // }

  // IconData getIconForAttachment(String attachment) {
  //   final extension = attachment.split('.').last.toLowerCase();
  //   switch (extension) {
  //     case 'pdf':
  //       return Icons.picture_as_pdf;
  //     case 'doc':
  //     case 'docx':
  //       return Icons.description;
  //     case 'xls':
  //     case 'xlxs':
  //       return Icons.grid_on;
  //     case 'jpg':
  //     case 'jpeg':
  //     case 'png':
  //     case 'gif':
  //       return Icons.image;
  //     default:
  //       return Icons.insert_drive_file;
  //   }
  // }

  // Future<void> downloadFile(String url, String savePath) async {
  //   try {
  //     final response = await http.get(Uri.parse(url));
  //     if (response.statusCode == 200) {
  //       // final file = File(savePath);
  //       // await file.writeAsBytes(response.bodyBytes);
  //       // print('File downloaded: ${file.path}');
  //       // Use your existing functions to get the file name and icon
  //       final fileName = getFileName(response.body);
  //       print(fileName);
  //       final fileIcon = getIconForAttachment(fileName);
  //       // Update the UI with the file name and icon
  //       attachments.add(fileName);
  //     } else {
  //       print('Failed to download file');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }
}
