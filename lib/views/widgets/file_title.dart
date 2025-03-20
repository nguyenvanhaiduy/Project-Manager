import 'package:flutter/material.dart';

class FileTitle extends StatelessWidget {
  const FileTitle(
      {super.key,
      required this.icon,
      required this.fileName,
      required this.color,
      required this.download});
  final IconData icon;
  final String fileName;
  final Color color;
  final Function() download;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color),
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Row(
            children: [
              Text(
                fileName,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
            ],
          )
        ],
      ),
    );
  }
}
