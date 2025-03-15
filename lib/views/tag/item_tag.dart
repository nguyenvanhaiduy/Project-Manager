import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/controllers/tag/tag_config_controller.dart';

class ItemTag extends StatelessWidget {
  ItemTag({super.key, required this.index});
  final int index;
  final TagConfigController tagConfigController = Get.find();

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
                controller: tagConfigController.tagEdittingController[index],
                autovalidateMode: AutovalidateMode.always,
                onTap: () {
                  tagConfigController.isValids[index].value =
                      formKey.currentState!.validate();
                },
                onChanged: (value) {
                  tagConfigController.isValids[index].value =
                      formKey.currentState!.validate();
                  print(tagConfigController.isValids[index].value);
                },
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return "Tag can't be empty";
                  }

                  bool isDuplicate = tagConfigController.tagEdittingController
                          .where((controller) =>
                              controller.text.trim() == value!.trim() &&
                              tagConfigController
                                  .tagConfirmed[tagConfigController
                                      .tagEdittingController
                                      .indexOf(controller)]
                                  .value)
                          .length >
                      1;
                  if (isDuplicate) return "Duplicate tag";
                  return null;
                },
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey, width: 1),
                  ),
                )),
          ),
          // IconButton(
          //     onPressed: () {},
          //     icon: const Icon(
          //       Icons.close,
          //       color: Colors.red,
          //     )),
          // IconButton(
          //     onPressed: () {},
          //     icon: const Icon(
          //       Icons.check,
          //       color: Colors.green,
          //     ))
        ],
      ),
    );
  }
}
