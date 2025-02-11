// import 'package:appwrite/appwrite.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:uuid/uuid.dart';

// class AppwriteController extends GetxController {
//   late final Client _client;
//   late final Storage _storage;
//   late final Account _account;
//   late final FirebaseFirestore _firestore;

//   late final String _projectId;
//   final box = GetStorage();

//   // ignore: unused_field
//   String? _userId;
//   String? _jwt;

//   @override
//   void onInit() {
//     super.onInit();

//     _client = Client();
//     _projectId = '678e3c4f0022f35b7d40';
//     _client
//         .setEndpoint('https://cloud.appwrite.io/v1')
//         .setProject(_projectId)
//         .setSelfSigned(status: true);
//     _account = Account(_client);
//     _storage = Storage(_client);
//     _firestore = FirebaseFirestore.instance;

//     _userId = box.read('userId');
//     _jwt = box.read('jwt');

//     if (_jwt != null) {
//       _client.setJWT(_jwt);
//     }
//     _client.addHeader('X-Appwrite-Response-Format', '0.15.0');
//   }

//   Future<bool> checkSession() async {
//     try {
//       final session = await _account.get();
//       return session != null;
//     } catch (e) {
//       print('Error checking session: $e');
//       return false; // Phiên không hợp lệ
//     }
//   }

//   // Future<User?> getAccount() async {
//   //   // print('box.read: ${box.read('userId')}');
//   //   try {
//   //     if (_jwt == null) {
//   //       throw Exception('JWT not set. User might not be logged in.');
//   //     }
//   //     final response = await _account.get();
//   //     return User(
//   //         id: response.$id,
//   //         name: response.name,
//   //         job: '',
//   //         email: response.email);
//   //   } on AppwriteException catch (e) {
//   //     print('Get count with error: $e');
//   //     return null;
//   //   }
//   // }

//   Future<bool> singIn(String email, String password) async {
//     try {
//       final session = await _account.createEmailPasswordSession(
//         email: email,
//         password: password,
//       ); //đăng nhập người dùng và tạo phiên
//       final jwtResponse =
//           await _account.createJWT(); // tạo jwt cho phiên hiện tại

//       box.write('userId', session.userId);
//       box.write('jwt', jwtResponse.jwt);

//       _client.setJWT(jwtResponse.jwt); //
//       return true;
//     } on AppwriteException catch (e) {
//       print('Error signin appwrite: $e');
//       return false;
//     }
//   }

//   Future<void> signUp(
//       String id, String email, String password, String name) async {
//     try {
//       final account = await _account.create(
//           userId: id, email: email, password: password, name: name);
//       await _account.createEmailPasswordSession(
//         email: email,
//         password: password,
//       );
//       final jwtResponse = await _account.createJWT();

//       box.write('userId', account.$id);
//       box.write('jwt', jwtResponse.jwt);

//       // print('User ID: ${box.read('userId')}');
//       // print('JWT: ${box.read('jwt')}');

//       _client.setJWT(jwtResponse.jwt);
//     } on AppwriteException catch (e) {
//       print('Signup appwrite with error: $e');
//     }
//   }

//   Future<String?> uploadFile(String projectId, BuildContext context) async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles();
//       if (result != null) {
//         final file = result.files.first;
//         final inputFile = InputFile.fromPath(path: file.path!);
//         final userId = box.read('userId');
//         final response = await _storage.createFile(
//             bucketId: '678e44be000722683a5b',
//             fileId: const Uuid().v4(),
//             file: inputFile,
//             permissions: [
//               Permission.read(Role.user(userId)),
//               Permission.write(Role.user(userId)),
//             ]);
//         final downloadURL = getDownloadFile(
//           response.$id,
//           '678e44be000722683a5b',
//         );
//         final projectRef = _firestore.collection('projects').doc(projectId);
//         await projectRef.update({
//           'attachments': FieldValue.arrayUnion([downloadURL])
//         });

//         showSnackbar(context, 'Success', 'File uploaded successfully');
//         return response.$id;
//       }
//       return null;
//     } on AppwriteException catch (e) {
//       // ignore: use_build_context_synchronously
//       showSnackbar(context, 'Error', 'Failed to upload file: ${e.message}');
//       print(e.message);
//       return null;
//     }
//   }

//   Future<bool> isLoggedIn() async {
//     try {
//       await _account.get(); // Thử lấy thông tin tài khoản
//       return true; // Nếu thành công, người dùng đã đăng nhập
//     } on AppwriteException catch (e) {
//       if (e.code == 401) {
//         // Unauthorized
//         return false; // Người dùng chưa đăng nhập
//       } else {
//         // Xử lý các lỗi khác (nếu cần)
//         print('Appwrite error: $e');
//         return false;
//       }
//     }
//   }

//   String getDownloadFile(String fileId, String bucketId) {
//     return '$_client.endPoint/storage/buckets/$bucketId/files/$fileId/view?project=$_projectId';
//   }

//   void showSnackbar(BuildContext context, String title, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('$title: $message'),
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }
// }
