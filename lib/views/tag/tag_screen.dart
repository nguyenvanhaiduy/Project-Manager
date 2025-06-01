import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/controllers/tag/tag_controller.dart';
import 'package:project_manager/routers/app_routers.dart';
import 'package:project_manager/views/widgets/custom_dialog.dart';

class TagScreen extends StatelessWidget {
  TagScreen({super.key});

  final RxList<String> tags = <String>[].obs;
  final TagController tagController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Collection Tag',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Obx(
            () => tagController.tags.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      Get.toNamed(AppRouters.addTag);
                    },
                    icon: const Icon(Icons.add))
                : const SizedBox(),
          )
        ],
      ),
      body: Obx(
        () => (tagController.tags.isEmpty)
            ? Stack(
                children: [
                  Center(
                    child: Text('oh!!!. You don\'t have any tags yet'.tr),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          Get.toNamed(AppRouters.addTag);
                        },
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal:
                                    (MediaQuery.of(context).size.width > 600)
                                        ? Get.size.width * 0.04
                                        : Get.size.width * 0.13),
                            child: const Icon(
                              Icons.add,
                              size: 30,
                            )),
                      ),
                    ),
                  ),
                ],
              )
            : Padding(
                padding: const EdgeInsets.all(12),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: Get.size.width ~/ 200,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: (MediaQuery.of(context).size.width > 600)
                        ? Get.size.width / 300
                        : Get.size.width / 150,
                  ),
                  itemCount: tagController.tags.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRouters.addTag, arguments: {
                          'isEdit': true,
                          'index': index,
                        });
                      },
                      onLongPress: () async {
                        await customDialog(
                          title:
                              'Bạn có chắc muốn xoá thẻ ${tagController.tags[index].title} chứ?',
                          onPress: () async {
                            Get.back();
                            await tagController
                                .deleteTag(tagController.tags[index].id);
                          },
                        );
                      },
                      child: Card(
                        color: Colors.blue.shade100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            tagController.tags[index].title,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
