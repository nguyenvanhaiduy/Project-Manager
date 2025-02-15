import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project_manager/models/task.dart';

class CardTaskCustom extends StatelessWidget {
  const CardTaskCustom({super.key, required this.task});
  final Task task;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Get.isDarkMode ? Colors.black26 : Colors.white,
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                height: 20,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat('MM/dd/yyyy, HH:mm').format(task.startDate),
                    style: TextStyle(),
                  )
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Text(task.status.name.tr),
          ),
        ],
      ),
    );
  }
}
