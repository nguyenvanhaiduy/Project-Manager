// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:project_manager/services/appwrite_service.dart';

// class AppwriteController extends GetxController {
//   final AppwriteService appwriteService = AppwriteService();
//   final _storage = GetStorage();

//   Future<bool> signUpWithEmailAndPassword(
//       String id, String email, String name, String password) async {
//     try {
//       await appwriteService.signup({
//         'id': id,
//         'email': email,
//         'password': password,
//         'name': name,
//       });
//       return true;
//     } catch (e) {
//       if (kDebugMode) print('signup: appwrite error: $e');

//       return false;
//     }
//   }

//   Future<bool> loginWithEmailAndPassword(String email, String password) async {
//     try {
//       await appwriteService
//           .login({'email': email, 'password': password}).then((value) {
//         _storage.write('userId', value.userId);
//         _storage.write('session', value.$id);
//         print(_storage.read('userId'));
//       });
//       return true;
//     } catch (e) {
//       if (kDebugMode) print('login appwrite error: $e');
//       return false;
//     }
//   }

//   Future<String?> uploadFile(String projectId, BuildContext context) async {
//     try {
//       return await appwriteService.uploadFile(projectId, context);
//     } catch (e) {
//       return null;
//     }
//   }

//   Future<void> logout() async {
//     try {
//       await appwriteService.logout();
//     } catch (e) {
//       if (kDebugMode) print('Logout failed');
//     }
//   }
// }
