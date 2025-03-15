import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/controllers/auth/auth_controller.dart';
import 'package:project_manager/controllers/tag/tag_config_controller.dart';
import 'package:project_manager/controllers/tag/tag_controller.dart';
import 'package:project_manager/models/tag.dart';
import 'package:project_manager/views/tag/item_add_tag.dart';
import 'package:project_manager/views/tag/item_tag.dart';
import 'package:uuid/uuid.dart';

class AddTagScreen extends StatelessWidget {
  AddTagScreen({super.key});

  final List<String> tags = <String>[];
  final TagController tagController = Get.find();

  final TagConfigController tagConfigController =
      Get.put(TagConfigController());

  final titleController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Tag',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Obx(
            () => tagConfigController.isActive.value
                ? const SizedBox()
                : IconButton(
                    onPressed: () {
                      tagConfigController.isActive.value = true;
                      tagConfigController.addTag();
                    },
                    icon: const Icon(Icons.add),
                  ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Obx(
          () => tagConfigController.tagEdittingController.isEmpty
              ? const Center(
                  child: Text('Nothing tag here!!!'),
                )
              : Obx(
                  () => Column(
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        itemCount:
                            tagConfigController.tagEdittingController.length,
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 10);
                        },
                        itemBuilder: (context, index) {
                          return (!tagConfigController
                                  .tagConfirmed[index].value)
                              ? ItemAddTag(
                                  key: UniqueKey(),
                                  index: index,
                                  focusNode:
                                      tagConfigController.focusNodes[index],
                                )
                              : Dismissible(
                                  key: UniqueKey(),
                                  direction: DismissDirection.endToStart,
                                  onDismissed: (direction) {
                                    if (direction ==
                                        DismissDirection.endToStart) {
                                      tagConfigController.removeTag(index);
                                    }
                                    for (var element in tagConfigController
                                        .tagEdittingController) {
                                      debugPrint(
                                          "index: ${tagConfigController.tagEdittingController.indexOf(element)} - ${element.text} - key: $key");
                                    }
                                  },
                                  background: Container(
                                    alignment: Alignment.centerRight,
                                    color: Colors.red,
                                    child: const Icon(Icons.delete),
                                  ),
                                  child: ItemTag(index: index),
                                );
                        },
                      ),
                      tagConfigController.isActive.value
                          ? const SizedBox()
                          : ElevatedButton(
                              onPressed: () {
                                bool isValid = true;

                                for (var isvalid
                                    in tagConfigController.isValids) {
                                  print("isvalid: ${isvalid.value}");
                                  if (!isvalid.value) {
                                    isValid = false;
                                    break;
                                  }
                                }

                                if (isValid) {
                                  Get.dialog(
                                    Center(
                                      child: Material(
                                        shadowColor: Colors.red,
                                        child: Container(
                                          width: 300,
                                          height: 180,
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Get.isDarkMode
                                                    ? Colors.black
                                                    : Colors.white,
                                                blurRadius: 10,
                                              )
                                            ],
                                            color: Get.isDarkMode
                                                ? Colors.black54
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Form(
                                            key: formKey,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text("Name Collection".tr),
                                                TextFormField(
                                                    controller: titleController,
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return "Name Tag Collection can't be empty";
                                                      }
                                                      return null;
                                                    },
                                                    decoration: InputDecoration(
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Colors.grey,
                                                          width: 1,
                                                        ),
                                                      ),
                                                      errorBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Colors.grey,
                                                          width: 1,
                                                        ),
                                                      ),
                                                      focusedErrorBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Colors.grey,
                                                          width: 1,
                                                        ),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        borderSide:
                                                            const BorderSide(
                                                          color: Colors.grey,
                                                          width: 1,
                                                        ),
                                                      ),
                                                    )),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    TextButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 40),
                                                        // : Colors.white,
                                                        backgroundColor:
                                                            const Color
                                                                .fromARGB(255,
                                                                213, 213, 213),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Get.back();
                                                      },
                                                      child: Text(
                                                        'close'.tr,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 40),
                                                        // : Colors.white,
                                                        backgroundColor:
                                                            const Color
                                                                .fromARGB(255,
                                                                3, 107, 224),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                      onPressed: () async {
                                                        if (formKey
                                                            .currentState!
                                                            .validate()) {
                                                          await tagController.createTag(Tag(
                                                              id: const Uuid()
                                                                  .v4(),
                                                              owner: Get.find<
                                                                      AuthController>()
                                                                  .currentUser
                                                                  .value!
                                                                  .id,
                                                              title:
                                                                  titleController
                                                                      .text,
                                                              tagNames: tagConfigController
                                                                  .tagEdittingController
                                                                  .map((controller) =>
                                                                      controller
                                                                          .text
                                                                          .trim())
                                                                  .toList()));
                                                          Get.close(1);
                                                          Get.back();
                                                        }
                                                      },
                                                      child: Text('confirm'.tr),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  if (Get.isSnackbarOpen) {
                                    Get.closeCurrentSnackbar();
                                  }
                                  Get.snackbar(
                                    'Error',
                                    'Please check your input',
                                    colorText: Colors.red,
                                  );
                                }
                                // Get.back();
                              },
                              child: const Text('Save'),
                            )
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
