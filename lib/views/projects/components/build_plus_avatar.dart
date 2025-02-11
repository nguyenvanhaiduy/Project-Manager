import 'package:flutter/material.dart';

class BuildPlusAvatar extends StatelessWidget {
  const BuildPlusAvatar({super.key, required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: CircleAvatar(
        radius: 16,
        backgroundColor: Colors.grey,
        child: Center(
          child: Text('$count+', style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
