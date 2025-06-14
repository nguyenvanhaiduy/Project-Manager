import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/controllers/auth/auth_controller.dart';
import 'package:project_manager/logic/project_logic.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/models/task.dart';
import 'package:project_manager/views/widgets/loading_overlay.dart';

class TaskController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthController _authController = Get.find();
  RxList<Task> tasks = <Task>[].obs;

  Rxn<Project> currentProject = Rxn<Project>(); // Khởi tạo Rxn<Project>

  @override
  void onInit() {
    super.onInit();
    tasks.bindStream(fetchData());
  }

  Future<void> updateCurrentProject(Project project) async {
    currentProject.value = project;
    tasks.bindStream(fetchData(id: project.id));
    await Future.delayed(
        const Duration(milliseconds: 200)); // Đợi stream bind xong
    calculateProgress();
    print("ddax cập nhật project");
  } // để cập nhật lại nếu project có thêm người dùng thì ngay lập tức phần task có thể nhận được dữ liệu người dùng mới

  Stream<List<Task>> fetchData({String? id}) {
    return _firestore
        .collection('tasks')
        .where('projectOwner', isEqualTo: id ?? currentProject.value?.id)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return Task.fromMap(data: doc.data());
            }).toList());
  }

  Stream<List<Task>> yourFetchTask() {
    return _firestore
        .collection('tasks')
        .where('projectOwner', isEqualTo: currentProject.value!.id)
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
      // tìm các file đã được add mà chưa bị xoá khởi ui rồi thêm đánh dấu thành file đã có chủ
      if (task.attachments.isNotEmpty) {
        await markFileAsAdded(task.attachments);
      }
      tasks.bindStream(fetchData());
      await LoadingOverlay.hide();

      Get.back();
      // Get.snackbar('Success', 'Add task success',
      //     colorText: Colors.green, duration: const Duration(milliseconds: 300));
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
      tasks.bindStream(fetchData());

      await _firestore.collection('tasks').doc(task.id).update(task.toMap());
      // tìm các file đã được add mà chưa bị xoá khởi ui rồi thêm đánh dấu thành file đã có chủ
      if (task.attachments.isNotEmpty) {
        await markFileAsAdded(task.attachments);
      }
      await LoadingOverlay.hide();
      // Get.back();
      // Get.snackbar('Success', 'Update task success',
      //     colorText: Colors.green, duration: const Duration(milliseconds: 900));
    } catch (e) {
      if (kDebugMode) print('Update task with error: $e');
      Get.closeCurrentSnackbar();
      await LoadingOverlay.hide();
      Get.snackbar('Error', 'Failed to update task', colorText: Colors.green);
    }
  }

  Future<void> deleteTask(String taskId, List<String> fileId) async {
    Get.closeAllSnackbars();
    LoadingOverlay.show();
    try {
      tasks.bindStream(fetchData());

      await _firestore.collection('tasks').doc(taskId).delete();

      tasks.removeWhere((task) => task.id == taskId);
      if (fileId.isNotEmpty) {
        for (final id in fileId) {
          await deleteFileMetaData(id);
        }
      }

      await LoadingOverlay.hide();
      Get.snackbar(
        'Success',
        'Delete task success',
        colorText: Colors.green,
        duration: const Duration(milliseconds: 300),
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

  double calculateProgress() {
    double progress = 0;
    int totalTaskDone = tasks
        .where((task) => (task.status.name == 'completed' ||
            task.status.name == 'lateCompleted'))
        .length;
    int totalTaskInProgress =
        tasks.where((task) => task.status.name == 'inProgress').length;
    if (tasks.isNotEmpty) {
      progress =
          ((totalTaskDone * 100 + totalTaskInProgress * 50) / tasks.length) /
              100;
    }
    return progress;
  }
}
