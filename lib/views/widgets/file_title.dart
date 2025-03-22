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
      // decoration:
      //     BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      // padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(
                  icon,
                  color: color,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    fileName,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            // padding: EdgeInsets.all(0),
            // tooltip: 'Download',
            onPressed: download,
            icon: const Icon(
              Icons.download,
            ),
          )
        ],
      ),
    );
  }
}
