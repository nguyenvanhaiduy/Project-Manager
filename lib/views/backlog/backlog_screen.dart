import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/controllers/backlog/backlog_controller.dart';

// ignore: must_be_immutable
class BacklogScreen extends StatelessWidget {
  BacklogScreen({super.key});

  final backlogController = Get.put(BacklogController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Backlog'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: Colors.red,
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Row(
                    children: [
                      Obx(
                        () => InkWell(
                          onTap: backlogController.toggleOpen,
                          child: backlogController.isOpen.value
                              ? const Icon(Icons.arrow_drop_down)
                              : const Icon(Icons.arrow_right),
                        ),
                      ),
                      Container(
                        constraints:
                            BoxConstraints(maxWidth: Get.size.width * 0.27),
                        child: const IntrinsicWidth(
                          child: TextField(
                            minLines: 1, // Bắt đầu với 1 dòng
                            maxLines:
                                null, // Mở rộng không giới hạn khi nhập nhiều
                            maxLength: 30,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              isCollapsed: true,
                              counterText: '',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                            ),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const Text(' 27/04 - 10/05'),
                      Container(color: Colors.red, child: Text(' (0 issues)')),
                      // Spacer()
                    ],
                  ),
                ),
                // Spacer(),
                Container(
                  color: Colors.grey,
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        splashColor: Colors.grey,
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  Get.isDarkMode ? Colors.white : Colors.grey,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 2.0),
                          child: Text(MediaQuery.of(context).size.width > 500
                              ? 'Start Sprint'.tr
                              : 'Start'.tr),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.more_horiz, size: 20),
                    ],
                  ),
                )
              ],
            ),
          ),
          Obx(
            () => backlogController.isOpen.value
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Text('issue one'),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
