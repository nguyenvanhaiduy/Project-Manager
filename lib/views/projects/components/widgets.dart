import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget customLable(
    {required IconData icon,
    required String title,
    required Color color,
    TextEditingController? controller,
    Function()? onTap,
    String? Function(String?)? onValidator,
    bool isTextField = true}) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 20,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
          ),
        ),
        const SizedBox(width: 10),
        isTextField
            ? SizedBox(
                width: 220,
                child: TextFormField(
                  readOnly: true,
                  controller: controller,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: title),
                  onTap: onTap,
                  validator: onValidator,
                ),
              )
            : GestureDetector(
                onTap: onTap,
                child: Text(
                  title,
                  style: Get.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      ],
    ),
  );
}

IconData getIconForAttachment(String attachment) {
  final extension = attachment.split('.').last.toLowerCase();
  switch (extension) {
    case 'pdf':
      return Icons.picture_as_pdf_outlined;
    case 'doc':
    case 'docx':
      return FontAwesomeIcons.fileWord;
    case 'xls':
    case 'xlsx':
      return FontAwesomeIcons.fileExcel;
    case 'ppt':
    case 'pptx':
      return FontAwesomeIcons.filePowerpoint;
    case 'txt':
      return FontAwesomeIcons.fileLines;
    case 'zip':
    case 'rar':
    case '7z':
      // ignore: deprecated_member_use
      return FontAwesomeIcons.save;
    // case 'mp3':
    // case 'wav':
    // case 'flac':
    //   return FontAwesomeIcons.fileAudio;
    // case 'mp4':
    // case 'avi':
    // case 'mkv':
    //   return FontAwesomeIcons.fileVideo;
    case 'jpg':
    case 'jpeg':
    case 'png':
    case 'gif':
    case 'svg':
      return FontAwesomeIcons.fileImage;
    case 'html':
    case 'css':
    case 'js':
    case 'json':
    case 'xml':
      return FontAwesomeIcons.fileCode;
    default:
      return FontAwesomeIcons.file;
  }
}

Color getColorForAttachment(String attachment) {
  final extension = attachment.split('.').last.toLowerCase();
  switch (extension) {
    case 'pdf':
      return Colors.red;
    case 'doc':
    case 'docx':
      return Colors.blue;
    case 'xls':
    case 'xlsx':
      return Colors.green;
    case 'ppt':
    case 'pptx':
      return Colors.orange;
    case 'txt':
      return Colors.grey;
    case 'zip':
    case 'rar':
    case '7z':
      return Colors.brown;
    // case 'mp3':
    // case 'wav':
    // case 'flac':
    //   return Colors.purple;
    // case 'mp4':
    // case 'avi':
    // case 'mkv':
    //   return Colors.indigo;
    case 'jpg':
    case 'jpeg':
    case 'png':
    case 'gif':
    case 'svg':
      return Colors.orange;
    case 'html':
    case 'css':
    case 'js':
    case 'json':
    case 'xml':
      return Colors.teal;
    default:
      return Colors.grey;
  }
}
