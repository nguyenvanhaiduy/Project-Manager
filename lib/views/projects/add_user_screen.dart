// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:project_manager/controllers/theme_controller.dart';
// import 'package:project_manager/views/widgets/widgets.dart';

// class AddUserScreen extends StatelessWidget {
//   AddUserScreen({super.key});

//   final emailController = TextEditingController();
//   final themecontroller = Get.find<ThemeController>();
//   final formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add User'.tr),
//       ),
//       body: Center(
//         child: Form(
//           key: formKey,
//           child: Column(
//             children: [
//               customTextField(
//                 context,
//                 emailController,
//                 'Email',
//                 Icons.email,
//                 (p0) => null,
//                 themecontroller,
//               ),
//               TextButton(
//                 onPressed: () {},
//                 child: const Text('Add User'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
