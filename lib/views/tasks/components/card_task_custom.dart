import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project_manager/controllers/project/project_controller.dart';
import 'package:project_manager/models/task.dart';

class CardTaskCustom extends StatelessWidget {
  CardTaskCustom({super.key, required this.task});
  final Task task;
  final ProjectController projectController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Get.isDarkMode ? Colors.grey[850] : Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 5,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromRGBO(244, 67, 54, 1),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              task.title,
              style: const TextStyle(
                fontSize: 18,
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
                // color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('MM/dd/yyyy, HH:mm').format(task.startDate),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            FutureBuilder(
              future: projectController.getUser(userId: task.assignTo),
              builder: (context, snapshot) {
                String assignedTo = snapshot.connectionState ==
                        ConnectionState.waiting
                    ? ''
                    : (snapshot.data != null ? snapshot.data!.name : 'Unknown');
                return Text(
                  'Assigned to: $assignedTo',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      overflow: TextOverflow.ellipsis),
                );
              },
            ),
            const SizedBox(height: 4),
            Text(
              'Status: ${task.status.name.tr}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Priority: ${task.priority.name.tr}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Complex: ${task.complexity.name.tr}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
