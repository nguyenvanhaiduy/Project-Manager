import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/controllers/auth/auth_controller.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/models/task.dart';
import 'package:project_manager/views/widgets/loading_overlay.dart';

class TaskController extends GetxController {
  TaskController({this.currentProject});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthController _authController = Get.find();
  RxList<Task> tasks = <Task>[].obs;

  Rx<Project>? currentProject;

  @override
  void onInit() {
    super.onInit();
    tasks.bindStream(fetchData());
  }

  void updateCurrentProject(Project project) {
    currentProject = project.obs;
  }

  Stream<List<Task>> fetchData() {
    if (currentProject == null) {
      return Stream.value([]);
    }
    return _firestore
        .collection('tasks')
        .where('projectOwner', isEqualTo: currentProject!.value.id)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return Task.fromMap(data: doc.data());
            }).toList());
  }

  Stream<List<Task>> yourFetchTask() {
    return _firestore
        .collection('tasks')
        .where('assignTo', isEqualTo: _authController.currentUser.value!.id)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Task.fromMap(data: doc.data()))
            .toList());
  }

  Future<void> addTask(Task task) async {
    Get.closeAllSnackbars();
    LoadingOverlay.show();
    try {
      await _firestore.collection('tasks').doc(task.id).set(task.toMap());
      // tasks.add(task);
      await LoadingOverlay.hide();
      Get.back();
      Get.snackbar('Success', 'Add task success', colorText: Colors.green);
    } catch (e) {
      if (kDebugMode) print('Add task with error: $e');
      await LoadingOverlay.hide();
      Get.snackbar('Error', 'Failed to add task', colorText: Colors.green);
    }
  }

  Future<void> updateTask(Task task) async {
    Get.closeAllSnackbars();
    LoadingOverlay.show();
    try {
      await _firestore.collection('tasks').doc(task.id).update(task.toMap());
      await LoadingOverlay.hide();
      Get.back();
      Get.snackbar('Success', 'Update task success', colorText: Colors.green);
    } catch (e) {
      if (kDebugMode) print('Update task with error: $e');
      await LoadingOverlay.hide();
      Get.snackbar('Error', 'Failed to update task', colorText: Colors.green);
    }
  }

  Future<void> deleteTask(String taskId) async {
    Get.closeAllSnackbars();
    LoadingOverlay.show();
    try {
      await _firestore.collection('tasks').doc(taskId).delete();
      tasks.removeWhere((task) => task.id == taskId);
      await LoadingOverlay.hide();
      Get.snackbar(
        'Success',
        'Delete task success',
        colorText: Colors.green,
        duration: const Duration(milliseconds: 600),
      );
    } catch (e) {
      if (kDebugMode) print('Delete task with error: $e');
      await LoadingOverlay.hide();
      Get.snackbar(
        'Error',
        'Failed to delete task',
        colorText: Colors.red,
        duration: const Duration(seconds: 2),
      );
    }
  }
}
