// import 'package:appwrite/appwrite.dart';
// import 'package:appwrite/models.dart' as models;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:uuid/uuid.dart';

// class AppwriteService {
//   Client client = Client();

//   Account? account;
//   final box = GetStorage();
//   late final _storage;
//   late final FirebaseFirestore _firestore;
//   late final _projectId;

//   AppwriteService() {
//     client
//         .setEndpoint("https://cloud.appwrite.io/v1")
//         .setProject('678e3c4f0022f35b7d40')
//         .setSelfSigned(status: true);
//     account = Account(client);
//     _storage = Storage(client);
//     _firestore = FirebaseFirestore.instance;
//     _projectId = '678e3c4f0022f35b7d40';
//   }

//   Future<models.User> signup(Map map) async {
//     final response = await account!.create(
//       userId: map['id'],
//       email: map['email'],
//       password: map['password'],
//       name: map['name'],
//     );

//     return response;
//   }

//   Future<models.Session> login(Map map) async {
//     await _deleteCurrentSession();
//     final response = await account!.createEmailPasswordSession(
//         email: map['email'], password: map['password']);

//     return response;
//   }

//   Future<void> logout() async {
//     await _deleteCurrentSession();
//   }

//   Future<void> _deleteCurrentSession() async {
//     try {
//       final sessionId = (await account!.getSession(sessionId: 'current')).$id;
//       await account!.deleteSession(sessionId: sessionId);
//       print('delete thanh cong');
//     } catch (e) {
//       print("Error deleting session: $e");
//     }
//   }

//   Future<String?> uploadFile(String projectId, BuildContext context) async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles();
//       if (result != null) {
//         final file = result.files.first;
//         final inputFile = InputFile.fromPath(path: file.path!);
//         // final userId = box.read('userId');
//         final id = const Uuid().v4();
//         final response = await _storage.createFile(
//             bucketId: '678e44be000722683a5b',
//             fileId: id,
//             file: inputFile,
//             permissions: [
//               Permission.read(Role.any()),
//               Permission.write(Role.any()),
//             ]);
//         print('upload success');
//         final downloadURL = getDownloadFile(
//           id,
//           '678e44be000722683a5b',
//         );

//         showSnackbar(context, 'Success', 'File uploaded successfully');
//         return downloadURL;
//       }
//       return null;
//     } on AppwriteException catch (e) {
//       showSnackbar(context, 'Error', 'Failed to upload file: ${e.message}');
//       print(e.message);
//       return null;
//     }
//   }

//   // String getDownloadFile(String fileId, String bucketId) {
//   //   return '$client.endPoint/storage/buckets/$bucketId/files/$fileId/view?project=$_projectId';
//   // }

//   String getDownloadFile(String fileId, String bucketId) {
//     print(
//         "https://cloud.appwrite.io/v1/storage/buckets/$bucketId/files/$fileId/view?project=$_projectId");

//     return "https://cloud.appwrite.io/v1/storage/buckets/$bucketId/files/$fileId/view?project=$_projectId";
//   }

// // https://cloud.appwrite.io/v1/storage/buckets/678e44be000722683a5b/files/5f2f13f6-3407-412d-b085-6056b8f259f2/view?project=678e3c4f0022f35b7d40&mode=admin
// // https://cloud.appwrite.io/v1/storage/buckets/678e44be000722683a5b/files/14681285-c62c-41ec-936b-66b566a0c975/view?project=678e3c4f0022f35b7d40&mode=admin
//   void showSnackbar(BuildContext context, String title, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('$title: $message'),
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }
// }
