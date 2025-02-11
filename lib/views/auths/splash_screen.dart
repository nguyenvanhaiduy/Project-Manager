import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager/controllers/auth/auth_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final AuthController authController = Get.find();
    // nên để lại vì nó để đảm bảo ràng có instance của authcontroller

    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
