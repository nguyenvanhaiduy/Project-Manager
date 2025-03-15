import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/controllers/tag/tag_controller.dart';
import 'package:project_manager/routers/app_routers.dart';

class TagScreen extends StatelessWidget {
  TagScreen({super.key});

  final RxList<String> tags = <String>[].obs;
  final TagController tagController = Get.put(TagController());

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
        ),
        body: Obx(
          () => tagController.tags.isEmpty
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
                              padding: EdgeInsets.all(Get.size.width * 0.12),
                              child: const Icon(
                                Icons.add,
                                size: 50,
                              )),
                        ),
                      ),
                    ),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.all(12),
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 3,
                      ),
                      itemCount: tagController.tags.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: Card(
                            color: Colors.blue.shade100,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(),
                          ),
                        );
                      }),
                ),
        ));
  }
}
