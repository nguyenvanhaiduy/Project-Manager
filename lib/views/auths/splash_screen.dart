import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/controllers/auth/auth_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final AuthController authController = Get.find();

    // Gọi kiểm tra đăng nhập khi màn hình được hiển thị
    // Future.delayed(Duration.zero, () => authController.checkIfUserIsLoggedIn());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Spacer(),
            // Thêm logo hoặc tên ứng dụng
            Image.asset(
              'assets/images/logo.png', // Đảm bảo bạn có file logo trong thư mục assets
              height: 120,
            ),
            const SizedBox(height: 20),
            const Text(
              "Project Manager",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            const Text(
              "Loading...",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
