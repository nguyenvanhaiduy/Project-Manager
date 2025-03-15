import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/controllers/tag/tag_config_controller.dart';
import 'package:project_manager/controllers/tag/tag_controller.dart';

class ItemAddTag extends StatelessWidget {
  ItemAddTag({super.key, required this.index, required this.focusNode});

  final int index;
  final FocusNode focusNode;

  final TagConfigController tagConfigController = Get.find();
  final TagController tagController = Get.find();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    focusNode.requestFocus();
    return Form(
      key: formKey,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: tagConfigController.tagEdittingController[index],
                focusNode: focusNode,
                onChanged: (value) {
                  tagConfigController.isValids[index].value =
                      formKey.currentState!.validate();
                },
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return "Tag can't be empty";
                  }

                  bool isDuplicate = tagConfigController.tagEdittingController
                          .where((controller) =>
                              controller.text.trim() == value!.trim())
                          .length >
                      1;
                  if (isDuplicate) return "Duplicate tag";
                  return null;
                },
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey, width: 1),
                  ),
                )),
          ),
          IconButton(
              onPressed: () {
                tagConfigController.isActive.value = false;
                if (index < tagConfigController.tagEdittingController.length) {
                  tagConfigController.removeTag(index);
                }
              },
              icon: const Icon(
                Icons.close,
                color: Colors.red,
              )),
          IconButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  tagConfigController.confirmTag(index);
                  tagConfigController.addTag();
                }
              },
              icon: const Icon(
                Icons.check,
                color: Colors.green,
              ))
        ],
      ),
    );
  }
}
