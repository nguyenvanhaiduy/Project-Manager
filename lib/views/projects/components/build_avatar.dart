import 'package:flutter/material.dart';
import 'package:project_manager/models/user.dart';
import 'package:project_manager/utils/color_utils.dart';

class BuildAvatar extends StatelessWidget {
  const BuildAvatar({super.key, required this.user, required this.size});
  final User user;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0), // Khoảng cách giữa các avatar
      child: CircleAvatar(
        radius: size,
        backgroundColor: Colors.white,
        child: user.imageUrl != null
            ? CircleAvatar(
                radius: size - 1,
                backgroundImage: NetworkImage(user.imageUrl!),
              )
            : CircleAvatar(
                radius: size - 1,
                backgroundColor: user.color,
                foregroundColor: getContrastingTextColor(user.color!),
                child: Text(
                  user.name[0].toUpperCase(),
                ),
              ),
      ),
    );
  }
}
