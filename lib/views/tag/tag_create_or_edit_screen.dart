import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/controllers/auth/auth_controller.dart';
import 'package:project_manager/controllers/tag/tag_config_controller.dart';
import 'package:project_manager/controllers/tag/tag_controller.dart';
import 'package:project_manager/models/tag.dart';
import 'package:project_manager/views/tag/item_add_tag.dart';
import 'package:project_manager/views/tag/item_tag.dart';
import 'package:uuid/uuid.dart';

class TagCreateOrEditScreen extends StatelessWidget {
  TagCreateOrEditScreen({super.key});

  final List<String> tags = <String>[];
  final TagController tagController = Get.find();

  final titleController = TextEditingController();
  final Map<String, dynamic> arguments = (Get.arguments is Map<String, dynamic>)
      ? Map<String, dynamic>.from(Get.arguments)
      : {};

  final _formKey = GlobalKey<FormState>(); // Di chuyển ra đây

  @override
  Widget build(BuildContext context) {
    TagConfigController tagConfigController;
    final bool isEdit = arguments['isEdit'] ?? false;
    final int? index = arguments['index'];
    if (isEdit && index != null) {
      tagConfigController =
          Get.put(TagConfigController(tag: tagController.tags[index]));
    } else {
      tagConfigController = Get.put(TagConfigController());
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Tag' : 'Add Tag',
          style: const TextStyle(
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
                      const SizedBox(height: 1),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: tagConfigController.tagEdittingController
                            .asMap()
                            .entries
                            .map((entry) {
                          int index = entry.key;
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
                                  background: Container(
                                    alignment: Alignment.centerRight,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: const Icon(Icons.delete),
                                  ),
                                  onDismissed: (direction) {
                                    tagConfigController.removeTag(index);
                                  },
                                  child: ItemTag(index: index));
                        }).toList(),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          tagConfigController.isActive.value
                              ? const SizedBox()
                              : ElevatedButton(
                                  onPressed: () async {
                                    bool isValid = true;

                                    for (var isvalid
                                        in tagConfigController.isValids) {
                                      if (!isvalid.value) {
                                        isValid = false;
                                        break;
                                      }
                                    }

                                    if (isValid) {
                                      if (isEdit && index != null) {
                                        final tag = tagController.tags[index];
                                        Tag newTag = Tag(
                                            id: tag.id,
                                            owner: tag.owner,
                                            title: tag.title,
                                            tagNames: tagConfigController
                                                .tagEdittingController
                                                .map((controller) =>
                                                    controller.text.trim())
                                                .toList());
                                        if (tag.tagNames.length !=
                                            newTag.tagNames.length) {
                                          await tagController.editTag(newTag);
                                        }
                                      } else {
                                        Get.dialog(
                                          Center(
                                            child: Material(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(10),
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
                                                  key: _formKey,
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Text(
                                                          "Name Collection".tr),
                                                      TextFormField(
                                                          controller:
                                                              titleController,
                                                          onChanged: (value) {
                                                            _formKey
                                                                .currentState!
                                                                .validate();
                                                            tagController.tags
                                                                .map(
                                                              (tag) =>
                                                                  debugPrint(
                                                                tag.title,
                                                              ),
                                                            );
                                                          },
                                                          autovalidateMode:
                                                              AutovalidateMode
                                                                  .onUserInteraction,
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return "Name Tag Collection can't be empty";
                                                            }
                                                            if (tagController
                                                                .tags
                                                                .any((tag) =>
                                                                    tag.title
                                                                        .trim()
                                                                        .toLowerCase() ==
                                                                    titleController
                                                                        .text
                                                                        .trim()
                                                                        .toLowerCase())) {
                                                              return "Duplicate name tag";
                                                            }
                                                            return null;
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color:
                                                                    Colors.grey,
                                                                width: 1,
                                                              ),
                                                            ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color: Colors
                                                                    .white,
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
                                                            style: TextButton
                                                                .styleFrom(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          40),
                                                              // : Colors.white,
                                                              backgroundColor:
                                                                  const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      213,
                                                                      213,
                                                                      213),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              Get.back();
                                                            },
                                                            child: Text(
                                                              'close'.tr,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                          TextButton(
                                                            style: TextButton
                                                                .styleFrom(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          40),
                                                              // : Colors.white,
                                                              backgroundColor:
                                                                  const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      3,
                                                                      107,
                                                                      224),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              if (_formKey
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
                                                                        .map((controller) => controller
                                                                            .text
                                                                            .trim())
                                                                        .toList()));
                                                                Get.close(1);
                                                                Get.back();
                                                              }
                                                            },
                                                            child: Text(
                                                                'confirm'.tr),
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
                                      }
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
                                  child: Text(isEdit ? 'Update' : 'Save'),
                                ),
                        ],
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
