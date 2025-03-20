import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      return Icons.picture_as_pdf;
    case 'doc':
    case 'docx':
      return Icons.description;
    case 'xls':
    case 'xlsx':
      return Icons.grid_on;
    case 'jpg':
    case 'jpeg':
    case 'png':
    case 'gif':
      return Icons.image;
    default:
      return Icons.insert_drive_file;
  }
}
