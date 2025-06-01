import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/controllers/auth/auth_controller.dart';
import 'package:project_manager/logic/project_logic.dart';
import 'package:project_manager/models/project.dart';
import 'package:project_manager/models/user.dart';
import 'package:project_manager/views/widgets/loading_overlay.dart';

class ProjectController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthController _authController = Get.find();
  RxList<Project> projects = <Project>[].obs;
  late final RxList<Project> filteredProjects;
  RxString currentSort = 'date'.obs; // Mặc định sắp xếp theo ngày
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    filteredProjects = <Project>[].obs;

    projects.bindStream(fetchProjects());
    filteredProjects.bindStream(fetchProjects());
  }

  /// Hàm xử lý sắp xếp danh sách dự án
  void sortProjects() {
    if (currentSort.value == 'status') {
      projects.sort((a, b) => a.status.index.compareTo(b.status.index));
      filteredProjects.sort((a, b) => a.status.index.compareTo(b.status.index));
    } else if (currentSort.value == 'priority') {
      projects.sort((a, b) => a.priority.index.compareTo(b.priority.index));
      filteredProjects
          .sort((a, b) => a.priority.index.compareTo(b.priority.index));
    } else {
      projects.sort((a, b) => b.startDate.compareTo(a.startDate));
      filteredProjects.sort((a, b) => b.startDate.compareTo(a.startDate));
    }

    // Cập nhật danh sách kèm hiệu ứng
    // projects.refresh();
  }

  /// Thay đổi tiêu chí sắp xếp và cập nhật UI
  void changeSort(String newSort) {
    if (currentSort.value != newSort) {
      currentSort.value = newSort;
      sortProjects();
    }
  }

  void searchProject(String query) {
    if (query.isEmpty) {
      filteredProjects.assignAll(projects);
    } else {
      filteredProjects.assignAll(projects
          .where((p) => p.title.toLowerCase().contains(query.toLowerCase())));
    }
  }

  /// Lấy danh sách project từ Firestore
  Stream<List<Project>> fetchProjects() {
    return _firestore
        .collection('projects')
        .where('users', arrayContains: _authController.currentUser.value?.id)
        .snapshots()
        .map((snapshot) {
      isLoading.value = true; // Bắt đầu tải
      final data = snapshot.docs
          .map((doc) => Project.fromMap(data: doc.data()))
          .toList();
      isLoading.value = false; // Đã tải xong
      return data;
    });
  }

  /// Thêm project mới vào Firestore
  Future<void> addProject(Project project) async {
    try {
      LoadingOverlay.show();
      await _firestore
          .collection('projects')
          .doc(project.id)
          .set(project.toMap());

      // Nếu có file đính kèm, đánh dấu đã thêm
      if (project.attachments.isNotEmpty) {
        await markFileAsAdded(project.attachments);
      }

      LoadingOverlay.hide();
      Get.back();
      // Get.snackbar('Success', 'Project added successfully!',
      //     colorText: Colors.green);
    } catch (e) {
      LoadingOverlay.hide();
      if (kDebugMode) print('Failed to add project: $e');
      Get.snackbar('Error', 'Failed to add project', colorText: Colors.red);
    }
  }

  /// Cập nhật thông tin project
  Future<void> updateProject(Project project) async {
    try {
      LoadingOverlay.show();
      await _firestore
          .collection('projects')
          .doc(project.id)
          .update(project.toMap());

      if (project.attachments.isNotEmpty) {
        await markFileAsAdded(project.attachments);
      }

      LoadingOverlay.hide();
      // Get.snackbar('Success', 'Project updated successfully!',
      //     colorText: Colors.green);
    } catch (e) {
      LoadingOverlay.hide();
      if (kDebugMode) print('Failed to update project: $e');
      Get.snackbar('Error', 'Failed to update project', colorText: Colors.red);
    }
  }

  /// Xóa project (chỉ chủ sở hữu mới có quyền xóa)
  Future<void> deleteProject(
      String projectId, String projectOwner, List<String> fileId) async {
    try {
      if (projectOwner != _authController.currentUser.value?.id) {
        Get.snackbar('Error', 'You are not the owner of this project',
            colorText: Colors.red);
        return;
      }

      LoadingOverlay.show();
      await _firestore.collection('projects').doc(projectId).delete();

      // Xóa các tệp đính kèm nếu có
      for (final id in fileId) {
        await deleteFileMetaData(id);
      }

      LoadingOverlay.hide();
      Get.snackbar('Success', 'Project deleted successfully!',
          colorText: Colors.green);
    } catch (e) {
      LoadingOverlay.hide();
      if (kDebugMode) print('Delete project with error: $e');
      Get.snackbar('Error', 'Failed to delete project', colorText: Colors.red);
    }
  }

  /// Lấy thông tin user từ Firestore
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
