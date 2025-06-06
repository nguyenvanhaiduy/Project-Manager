import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:project_manager/models/file_metadata_flutter.dart';

class AttachmentsController extends GetxController {
  final baseUrl =
      // "http://192.168.1.18:8080/project/api/files"; // địa chỉ wifi dưới hn
      // final baseUrl =
      "http://172.72.125.27:8080/project/api/files"; // địa chỉ wifi ở nhà

  Future<void> updateList(List<String> attachmentsId) async {
    int count = 0;
    attachments.value = [];
    for (final id in attachmentsId) {
      FileMetadataFlutter? file = await getFileMetadata(id);
      if (file != null) {
        addAttachment(file);
        count++;
      }
    }
    if (count == 0) {
      attachments.value = [];
    }
  }

  @override
  void onInit() async {
    super.onInit();
  }

  final RxList<FileMetadataFlutter> attachments = <FileMetadataFlutter>[].obs;

  void addAttachment(FileMetadataFlutter file) {
    attachments.add(file);
  }

  void removeAttachment(int index) {
    attachments.removeAt(index);
  }

  Future<FileMetadataFlutter?> getFileMetadata(String fileId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/metadata/$fileId'));
      if (response.statusCode == 200) {
        final jsonRespose = jsonDecode(utf8.decode(response.bodyBytes));
        return FileMetadataFlutter(
            id: jsonRespose['id'],
            fileName: jsonRespose['fileName'] ?? '',
            fileType: jsonRespose['fileType'] ?? '',
            url: '$baseUrl/$fileId');
      } else {
        print("url: $baseUrl/$fileId");
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
