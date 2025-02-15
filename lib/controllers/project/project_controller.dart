import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/controllers/auth/auth_controller.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/models/user.dart';
import 'package:project_manager/views/widgets/loading_overlay.dart';

class ProjectController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthController _authController = Get.find();
  RxList<Project> projects = <Project>[].obs;
  RxString currentSort = 'date'.obs; // Mặc định sắp xếp theo date

  @override
  void onInit() {
    super.onInit();
    projects.bindStream(fetchProjects());
  }

  // @override
  // void onReady() {
  //   super.onReady();
  //   projects.bindStream(fetchProjects());
  //   print('askldjflaksjdf');
  // }

  void sortProjects() {
    if (currentSort.value == 'status') {
      projects.sort((a, b) => a.status.index.compareTo(b.status.index));
    } else if (currentSort.value == 'priority') {
      projects.sort((a, b) => a.priority.index.compareTo(b.priority.index));
    } else {
      projects.sort((a, b) => b.startDate.compareTo(a.startDate));
    }
  }

  void changeSort(String newSort) {
    currentSort.value = newSort;
    sortProjects();
  }

  Stream<List<Project>> fetchProjects() {
    return _firestore
        .collection('projects')
        .where('users', arrayContains: _authController.currentUser.value!.id)
        .snapshots()
        .map((snapshot) {
      final List<Project> projects = snapshot.docs
          .map((doc) => Project.fromMap(data: doc.data()))
          .toList();

      if (currentSort.value == 'status') {
        projects.sort((a, b) => a.status.index.compareTo(b.status.index));
      } else if (currentSort.value == 'priority') {
        projects.sort((a, b) => a.priority.index.compareTo(b.priority.index));
      } else {
        projects.sort((a, b) => b.startDate.compareTo(a.startDate));
      }
      return projects;
    });
  }

  Future<void> addProject(Project project) async {
    Get.closeAllSnackbars();
    try {
      LoadingOverlay.show();
      await _firestore
          .collection('projects')
          .doc(project.id)
          .set(project.toMap());
      await LoadingOverlay.hide();
      Get.back();
      Get.snackbar('Success', 'Add project success', colorText: Colors.green);
    } catch (e) {
      await LoadingOverlay.hide();
      if (kDebugMode) print('Error: $e');

      Get.snackbar('Error', 'Failed to add project', colorText: Colors.red);
    }
  }

  Future<void> updateProject(Project project) async {
    Get.closeAllSnackbars();
    try {
      LoadingOverlay.show();
      await _firestore
          .collection('projects')
          .doc(project.id)
          .update(project.toMap());
      await LoadingOverlay.hide();
      Get.snackbar('Success', 'Update project success',
          colorText: Colors.green);
    } catch (e) {
      await LoadingOverlay.hide();
      if (kDebugMode) print('Failed to update project: $e');

      Get.snackbar('Error', 'Failed to update project', colorText: Colors.red);
    }
  }

  Future<void> deleteProject(String projectId, String projectOwner) async {
    Get.closeAllSnackbars();
    LoadingOverlay.show();
    try {
      if (projectOwner != _authController.currentUser.value!.id) {
        await LoadingOverlay.hide();
        Get.snackbar('Error', 'You are not the owner of this project',
            colorText: Colors.red, duration: const Duration(milliseconds: 600));
        return;
      } else {
        await _firestore.collection('projects').doc(projectId).delete();
        await LoadingOverlay.hide();
        Get.snackbar('Success', 'Delete project success',
            colorText: Colors.green,
            duration: const Duration(milliseconds: 600));
      }
    } catch (e) {
      await LoadingOverlay.hide();
      if (kDebugMode) print('Delete project with error: $e');
      Get.snackbar('Error', 'Failed to delete project',
          colorText: Colors.red, duration: const Duration(seconds: 2));
    }
  }

  Future<User?> getUser({
    String? userId,
    String? email,
  }) async {
    try {
      if (userId != null) {
        final doc = await _firestore
            .collection('users')
            .where('id', isEqualTo: userId)
            .get();
        return User.fromMap(data: doc.docs.first.data());
      } else if (email != null) {
        final doc = await _firestore
            .collection('users')
            .where('email', isEqualTo: email)
            .get();
        return User.fromMap(data: doc.docs.first.data());
      }
    } catch (e) {
      print('Load user failed: $e');
    }
    return null;
  }
}
