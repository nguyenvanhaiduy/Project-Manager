import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/controllers/project/project_controller.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/views/home/card_project_summary.dart';
import 'package:project_manager/views/projects/components/card_project_custom.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final ProjectController projectController = Get.find();
  final RxInt selectedProjectSum = (-1).obs;

  @override
  Widget build(BuildContext context) {
    List<Project> notStarted = [];
    List<Project> inProgress = [];
    List<Project> completed = [];
    List<Project> cancelled = [];
    for (final project in projectController.projects) {
      if (project.status.name == 'notStarted') {
        notStarted.add(project);
      } else if (project.status.name == 'inProgress') {
        inProgress.add(project);
      } else if (project.status.name == 'completed') {
        completed.add(project);
      } else if (project.status.name == 'cancelled') {
        cancelled.add(project);
      }
    }
    List<List<Project>> projectSummary = [
      notStarted,
      inProgress,
      completed,
      cancelled
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Project Summary',
                style: Get.textTheme.titleMedium!.copyWith(
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => selectedProjectSum.value = 0,
                      child: CardProjectSummary(
                        color: Colors.grey,
                        status: 'notStarted'.tr,
                        amount: notStarted.length,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => selectedProjectSum.value = 1,
                      child: CardProjectSummary(
                        color: Colors.blue,
                        status: 'inProgress'.tr,
                        amount: inProgress.length,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => selectedProjectSum.value = 2,
                      child: CardProjectSummary(
                        color: Colors.green,
                        status: 'completed'.tr,
                        amount: completed.length,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => selectedProjectSum.value = 3,
                      child: CardProjectSummary(
                        color: Colors.red,
                        status: 'cancelled'.tr,
                        amount: cancelled.length,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Obx(
                () => selectedProjectSum.value == -1
                    ? Container(
                        height: 200,
                        alignment: Alignment.center,
                        child: Text('Please select one project summary'),
                      )
                    : projectSummary[selectedProjectSum.value].isEmpty
                        ? const Text('data')
                        : ListView.separated(
                            shrinkWrap: true,
                            itemCount:
                                projectSummary[selectedProjectSum.value].length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              return CardProjectCustom(
                                onTap: () {},
                                project:
                                    projectSummary[selectedProjectSum.value]
                                        [index],
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
