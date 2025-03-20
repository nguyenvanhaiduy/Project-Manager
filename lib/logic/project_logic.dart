import 'dart:convert';
import 'dart:io' as io;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:project_manager/controllers/project/attachments_controller.dart';
import 'package:project_manager/models/file_metadata_flutter.dart';
import 'package:universal_html/html.dart' as web;
import 'package:path_provider/path_provider.dart'; // thư viện này để có thể xử dụng được các hàm download có sẵn
import 'package:path/path.dart'
    as path; // thư viện này để tạo đường dãn lưu file

// const baseUrl = "http://192.168.1.23:8080/project/api/files";// địa chỉ wifi dứoi hn
const baseUrl =
    "http://192.168.1.221:8080/project/api/files"; // địa chỉ wifi ở nhà

class ProjectLogic {
  final attachmentController = Get.find<AttachmentsController>();

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      PlatformFile file = result.files.first;
      await uploadFile(file);
    } else {
      print('No file selected');
    }
  }

  Future<void> uploadFile(PlatformFile file) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/upload'));
      // Kiểm tra nền tangr
      if (kIsWeb) {
        // Sử dụng http.MultipartFile.fromBytes để tạo một phần file từ mảng byte của file
        request.files.add(
          http.MultipartFile.fromBytes(
            'file', // key
            file.bytes!
                .toList(), // chuyển đổi mảng byte thành List<int> phù hợp với y/c FromByte
            filename: file.name,
            contentType: MediaType(
                'application', 'octet-stream'), // đặt loại nội dung của file
          ),
        );
      } else {
        // trên các nền tảng khác sử dụng path
        request.files.add(await http.MultipartFile.fromPath(
          'file',
          file.path!,
          contentType: MediaType('Application', 'octet-stream'),
        ));
      }

      var response = await request.send();
      final responseBody = await response.stream
          .bytesToString(); //Chuyển đổi phản hồi từ server thành chuỗi bằng
      if (response.statusCode == 200) {
        print('Uploaded');
        final jsonResponse = jsonDecode(responseBody);
        String fileId = jsonResponse['fileId'];
        String fileName = jsonResponse['fileName'];
        String fileType = jsonResponse['fileType'];
        String fileUrl =
            '$baseUrl/$fileId'; //Tạo URL của file trên server: $baseUrl/$fileId.
        attachmentController.addAttachment(FileMetadataFlutter(
            id: fileId, fileName: fileName, fileType: fileType, url: fileUrl));
      } else {
        print('Upload failed with status ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading file: $e');
    }
  }

// filename: tên file lưa trên thiết bị, url: đường dẫn tới tệp cần tải
  Future<void> downloadFile(String url, String fileName) async {
    try {
      final response = await http
          .get(Uri.parse(url)); // Gửi yêu cầu HTTP GET để lấy dữ liệu tệp
      if (response.statusCode == 200) {
        if (kIsWeb) {
          final blob = web.Blob([
            response.bodyBytes
          ]); // Tạo một blob chứa dữ liệu tệp tải về (response.bodyBytes).
          //web.AnchorElement: Tạo một phần tử <a> ẩn để tải file xuống
          // ignore: unused_local_variable
          final anchor = web.AnchorElement(
              href: web.Url.createObjectUrlFromBlob(blob).toString())
            ..setAttribute('download', fileName) // Đặt tên file sẽ tải xuống.
            ..click(); // Giả lập việc bấm vào liên kết, giúp tải file ngay lập tức.
          Get.snackbar('Thành công', 'Đang tải file $fileName...',
              snackPosition: SnackPosition.BOTTOM);
        } else {
          final io.Directory? downloadDir;
          if (io.Platform.isAndroid) {
            downloadDir = await getExternalStorageDirectory();
            //Android: Lưu trong thư mục getExternalStorageDirectory().
          } else if (io.Platform.isIOS) {
            downloadDir = await getApplicationDocumentsDirectory();
            //iOS: Lưu trong getApplicationDocumentsDirectory().
          } else {
            downloadDir = await getDownloadsDirectory();
            //Desktop (Windows, macOS, Linux): Lưu trong getDownloadsDirectory().
          }

          if (downloadDir != null) {
            final String savePath = path.join(downloadDir.path, fileName);
            final io.File file = io.File(savePath);
            await file.writeAsBytes(response.bodyBytes);
            Get.snackbar('Thành công', 'Đang tải file $fileName...',
                snackPosition: SnackPosition.BOTTOM);

            print("File downloaded to $savePath");
          }
        }
      } else {
        print('Failed to download file. Status code: ${response.statusCode}');
      }
    } catch (e) {}
  }

  Future<FileMetadataFlutter?> getFileMetadata(String fileId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$fileId'));
      if (response.statusCode == 200) {
        final jsonRespose = jsonDecode(response.body);
        return FileMetadataFlutter(
            id: jsonRespose['fileId'],
            fileName: jsonRespose['fileName'],
            fileType: jsonRespose['fileType'],
            url: '$baseUrl/$fileId');
      } else {
        print(
            'Failed to get file metadata. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error getting file metadata: $e');
      return null;
    }
  }
}

Future<void> deleteFileMetaData(String fileId) async {
  try {
    final request =
        http.MultipartRequest('DELETE', Uri.parse('$baseUrl/delete/$fileId'));
    final response = await request.send();
    if (response.statusCode != 200) {
      print(
          'Failed to delete file metadata. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error getting file metadata: $e');
  }
}

Future<void> markFileAsAdded(List<String> fileIds) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/markAsAdded'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(fileIds),
    );
    if (response.statusCode == 200) {
      print('Files marked as added successfully');
    } else {
      print(
          'Failed to mark files as added. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error marking files as added: $e');
  }
}
