// // // // import 'package:flutter/material.dart';
// // // // import 'package:flutter/services.dart';
// // // // import 'package:get/get.dart';
// // // // import 'package:project_manager/controllers/auth_controller.dart';
// // // // import 'package:project_manager/controllers/theme_controller.dart';
// // // // import 'package:rive/rive.dart';

// // // // class LoginScreen extends StatefulWidget {
// // // //   const LoginScreen({super.key});

// // // //   @override
// // // //   State<LoginScreen> createState() => _LoginScreenState();
// // // // }

// // // // class _LoginScreenState extends State<LoginScreen> {
// // // //   final _formKey = GlobalKey<FormState>();

// // // //   final _emailController = TextEditingController();

// // // //   final _passwordController = TextEditingController();

// // // //   var riveUrl = 'assets/animated_login_character.riv';
// // // //   var isSelectLanguage = false.obs;

// // // //   SMITrigger? failTrigger, successTrigger;

// // // //   SMIBool? isHandsUp, isChecking;

// // // //   SMINumber? lookNum;

// // // //   StateMachineController? stateMachineController;

// // // //   Artboard? artboard;

// // // //   final AuthController _authController = Get.find<AuthController>();

// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     rootBundle.load(riveUrl).then((value) {
// // // //       final file = RiveFile.import(value);
// // // //       final art = file.mainArtboard;
// // // //       stateMachineController =
// // // //           StateMachineController.fromArtboard(art, 'Login Machine');
// // // //       if (stateMachineController != null) {
// // // //         art.addController(stateMachineController!);
// // // //         for (var element in stateMachineController!.inputs) {
// // // //           if (element.name == 'isChecking') {
// // // //             isChecking = element as SMIBool;
// // // //           } else if (element.name == 'isHandsUp') {
// // // //             isHandsUp = element as SMIBool;
// // // //           } else if (element.name == 'trigSuccess') {
// // // //             successTrigger = element as SMITrigger;
// // // //           } else if (element.name == 'trigFail') {
// // // //             failTrigger = element as SMITrigger;
// // // //           } else if (element.name == 'numLook') {
// // // //             lookNum = element as SMINumber;
// // // //           }
// // // //         }
// // // //       }
// // // //       setState(() {
// // // //         artboard = art;
// // // //       });
// // // //     });
// // // //   }

// // // //   void lookAround() {
// // // //     isChecking?.change(true);
// // // //     isHandsUp?.change(false);
// // // //     lookNum?.change(0);
// // // //   }

// // // //   void moveEyes(value) {
// // // //     lookNum?.change(value.length.toDouble());
// // // //   }

// // // //   void handsUpOnEyes() {
// // // //     isHandsUp?.change(true);
// // // //     isChecking?.change(false);
// // // //   }

// // // //   void loginClick() {
// // // //     isChecking?.change(false);
// // // //     isHandsUp?.change(false);
// // // //     if (_emailController.text == 'email' && _passwordController.text == '123') {
// // // //       successTrigger?.fire();
// // // //     } else {
// // // //       failTrigger?.fire();
// // // //     }

// // // //     _authController.signInWithEmailAndPassword(
// // // //         _emailController.text, _passwordController.text);
// // // //     setState(() {});
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     final ThemeController themeController = Get.find();

// // // //     return SafeArea(
// // // //       child: Scaffold(
// // // //         appBar: AppBar(),
// // // //         drawer: Drawer(
// // // //           child: Obx(
// // // //             () {
// // // //               return Column(
// // // //                 children: [
// // // //                   const SizedBox(height: 10),
// // // //                   Row(
// // // //                     mainAxisAlignment: MainAxisAlignment.center,
// // // //                     children: [
// // // //                       Text('change theme'.tr),
// // // //                       const Icon(Icons.change_circle),
// // // //                     ],
// // // //                   ),
// // // //                   const SizedBox(height: 10),
// // // //                   RadioListTile(
// // // //                     title: Text('light mode'.tr),
// // // //                     value: ThemeMode.light,
// // // //                     groupValue: themeController.themeMode.value,
// // // //                     onChanged: (ThemeMode? value) {
// // // //                       if (value != null) {
// // // //                         themeController.setThemeMode(value);
// // // //                       }
// // // //                     },
// // // //                   ),
// // // //                   RadioListTile(
// // // //                     title: Text('dark mode'.tr),
// // // //                     value: ThemeMode.dark,
// // // //                     groupValue: themeController.themeMode.value,
// // // //                     onChanged: (ThemeMode? value) {
// // // //                       if (value != null) {
// // // //                         themeController.setThemeMode(value);
// // // //                       }
// // // //                     },
// // // //                   ),
// // // //                   RadioListTile(
// // // //                     title: Text('system default'.tr),
// // // //                     value: ThemeMode.system,
// // // //                     groupValue: themeController.themeMode.value,
// // // //                     onChanged: (ThemeMode? value) {
// // // //                       if (value != null) {
// // // //                         themeController.setThemeMode(value);
// // // //                       }
// // // //                     },
// // // //                   ),
// // // //                   const SizedBox(height: 10),
// // // //                   Row(
// // // //                     mainAxisAlignment: MainAxisAlignment.center,
// // // //                     children: [
// // // //                       Text('select language'.tr),
// // // //                       const Icon(Icons.language),
// // // //                     ],
// // // //                   ),
// // // //                   const SizedBox(height: 10),
// // // //                   Obx(
// // // //                     () => ElevatedButton(
// // // //                       style: ElevatedButton.styleFrom(
// // // //                           side: isSelectLanguage.value ? null : BorderSide()),
// // // //                       onPressed: () {
// // // //                         Get.updateLocale(const Locale('en', 'US'));
// // // //                         isSelectLanguage.value = false;
// // // //                       },
// // // //                       child: const Row(
// // // //                         children: [
// // // //                           Text('English'),
// // // //                           SizedBox(width: 10),
// // // //                         ],
// // // //                       ),
// // // //                     ),
// // // //                   ),
// // // //                   Obx(
// // // //                     () => ElevatedButton(
// // // //                       style: ElevatedButton.styleFrom(
// // // //                           side: isSelectLanguage.value ? BorderSide() : null),
// // // //                       onPressed: () {
// // // //                         Get.updateLocale(const Locale('vi', 'VN'));
// // // //                         isSelectLanguage.value = true;
// // // //                       },
// // // //                       child: const Row(
// // // //                         children: [
// // // //                           Text('Tiếng Việt'),
// // // //                           SizedBox(width: 10),
// // // //                         ],
// // // //                       ),
// // // //                     ),
// // // //                   ),
// // // //                 ],
// // // //               );
// // // //             },
// // // //           ),
// // // //         ),
// // // //         body: Form(
// // // //           key: _formKey,
// // // //           child: SingleChildScrollView(
// // // //             child: Center(
// // // //               child: Column(
// // // //                 mainAxisAlignment: MainAxisAlignment.center,
// // // //                 children: [
// // // //                   if (artboard != null)
// // // //                     SizedBox(
// // // //                       height: 300,
// // // //                       width: 500,
// // // //                       child: Rive(
// // // //                         artboard: artboard!,
// // // //                       ),
// // // //                     ),
// // // //                   const SizedBox(height: 4),
// // // //                   Text(
// // // //                     'login'.tr,
// // // //                     style: const TextStyle(
// // // //                         fontSize: 18, fontWeight: FontWeight.bold),
// // // //                   ),
// // // //                   const SizedBox(height: 4),
// // // //                   Padding(
// // // //                     padding: const EdgeInsets.symmetric(horizontal: 15),
// // // //                     child: TextFormField(
// // // //                       controller: _emailController,
// // // //                       onChanged: (value) => moveEyes(value),
// // // //                       onTap: lookAround,
// // // //                       decoration: InputDecoration(
// // // //                         labelText: 'email'.tr,
// // // //                         prefixIcon: const Icon(Icons.person),
// // // //                         labelStyle: const TextStyle(fontSize: 18),
// // // //                         contentPadding: const EdgeInsets.all(10),
// // // //                         border: OutlineInputBorder(
// // // //                           borderRadius: BorderRadius.circular(4),
// // // //                         ),
// // // //                       ),
// // // //                     ),
// // // //                   ),
// // // //                   const SizedBox(height: 16),
// // // //                   Padding(
// // // //                     padding: const EdgeInsets.symmetric(horizontal: 15.0),
// // // //                     child: TextFormField(
// // // //                       controller: _passwordController,
// // // //                       onChanged: (value) => (),
// // // //                       onTap: handsUpOnEyes,
// // // //                       obscureText: true,
// // // //                       decoration: InputDecoration(
// // // //                           prefixIcon: const Icon(Icons.lock),
// // // //                           labelText: 'password'.tr,
// // // //                           labelStyle: const TextStyle(fontSize: 18),
// // // //                           contentPadding: const EdgeInsets.all(10),
// // // //                           border: OutlineInputBorder(
// // // //                               borderRadius: BorderRadius.circular(4))),
// // // //                     ),
// // // //                   ),
// // // //                   const SizedBox(height: 10),
// // // //                   MaterialButton(
// // // //                     onPressed: () {},
// // // //                     child: Text(
// // // //                       'not having account? sign up!'.tr,
// // // //                     ),
// // // //                   ),
// // // //                   Container(
// // // //                     height: 50,
// // // //                     width: 250,
// // // //                     decoration: BoxDecoration(
// // // //                       color: Colors.blueGrey,
// // // //                       borderRadius: BorderRadius.circular(20),
// // // //                     ),
// // // //                     clipBehavior: Clip.hardEdge,
// // // //                     child: MaterialButton(
// // // //                       onPressed: () {
// // // //                         loginClick();
// // // //                       },
// // // //                       child: Text(
// // // //                         'login'.tr,
// // // //                         style: TextStyle(color: Colors.white, fontSize: 25),
// // // //                       ),
// // // //                     ),
// // // //                   )
// // // //                 ],
// // // //               ),
// // // //             ),
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // // import 'package:flutter/material.dart';
// // // import 'package:get/get.dart';

// // // class CardController extends GetxController with SingleGetTickerProviderMixin {
// // //   RxBool isCardVisible = false.obs;

// // //   late AnimationController animationController;
// // //   late Animation<double> rotationAnimation;
// // //   late Animation<Offset> slideAnimation;

// // //   @override
// // //   void onInit() {
// // //     super.onInit();
// // //     animationController = AnimationController(
// // //       vsync: this,
// // //       duration: const Duration(milliseconds: 500),
// // //     );

// // //     rotationAnimation = Tween<double>(begin: -0.2, end: 0.0).animate(
// // //         CurvedAnimation(parent: animationController, curve: Curves.easeOut));

// // //     slideAnimation = Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
// // //         .animate(CurvedAnimation(
// // //             parent: animationController, curve: Curves.easeOut));
// // //   }

// // //   void toggleCard() {
// // //     if (isCardVisible.value) {
// // //       animationController.reverse();
// // //     } else {
// // //       animationController.forward();
// // //     }
// // //     isCardVisible.value = !isCardVisible.value;
// // //   }

// // //   @override
// // //   void onClose() {
// // //     animationController.dispose();
// // //     super.onClose();
// // //   }
// // // }

// // // class ProfileCardPage extends StatelessWidget {
// // //   ProfileCardPage({super.key});

// // //   final CardController cardController = Get.put(CardController());

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final theme = Theme.of(context);
// // //     final isLightMode = theme.brightness == Brightness.light;

// // //     return Scaffold(
// // //       appBar: AppBar(title: const Text('Profile Card with Animation')),
// // //       body: Stack(
// // //         children: [
// // //           // Nền chính
// // //           Padding(
// // //             padding: const EdgeInsets.all(16.0),
// // //             child: ListView(
// // //               children: [
// // //                 GestureDetector(
// // //                   onTap: cardController.toggleCard,
// // //                   child: AnimatedContainer(
// // //                     duration: const Duration(milliseconds: 300),
// // //                     curve: Curves.easeInOut,
// // //                     decoration: BoxDecoration(
// // //                       gradient: LinearGradient(
// // //                         colors: isLightMode
// // //                             ? [Colors.blue.shade700, Colors.blue.shade300]
// // //                             : [Colors.grey.shade800, Colors.grey.shade600],
// // //                         begin: Alignment.topLeft,
// // //                         end: Alignment.bottomRight,
// // //                       ),
// // //                       borderRadius: BorderRadius.circular(15),
// // //                       boxShadow: [
// // //                         BoxShadow(
// // //                           color: Colors.black.withOpacity(0.2),
// // //                           blurRadius: 10,
// // //                           offset: const Offset(0, 5),
// // //                         ),
// // //                       ],
// // //                     ),
// // //                     child: const ListTile(
// // //                       leading: CircleAvatar(
// // //                         radius: 30,
// // //                         backgroundImage: AssetImage('assets/profile.jpg'),
// // //                       ),
// // //                       title: Text(
// // //                         'Hải Duy',
// // //                         style: TextStyle(
// // //                           fontWeight: FontWeight.bold,
// // //                           fontSize: 20,
// // //                           color: Colors.white,
// // //                         ),
// // //                       ),
// // //                       subtitle: Text(
// // //                         'Software Developer',
// // //                         style: TextStyle(color: Colors.white70),
// // //                       ),
// // //                       trailing: Icon(
// // //                         Icons.arrow_upward,
// // //                         color: Colors.white,
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),

// // //           // Card nổi lên với hiệu ứng xoay + rơi
// // //           Obx(() {
// // //             return Visibility(
// // //               visible: cardController.isCardVisible.value,
// // //               child: GestureDetector(
// // //                 onTap: cardController.toggleCard, // Đóng card khi nhấn ra ngoài
// // //                 child: Container(
// // //                   color: Colors.black54, // Nền mờ
// // //                   child: Center(
// // //                     child: SlideTransition(
// // //                       position: cardController.slideAnimation,
// // //                       child: AnimatedBuilder(
// // //                         animation: cardController.rotationAnimation,
// // //                         builder: (context, child) {
// // //                           return Transform.rotate(
// // //                             angle: cardController.rotationAnimation.value,
// // //                             child: Card(
// // //                               shape: RoundedRectangleBorder(
// // //                                 borderRadius: BorderRadius.circular(20),
// // //                               ),
// // //                               elevation: 12,
// // //                               child: Container(
// // //                                 width: 300,
// // //                                 padding: const EdgeInsets.all(20),
// // //                                 child: Column(
// // //                                   mainAxisSize: MainAxisSize.min,
// // //                                   children: [
// // //                                     const CircleAvatar(
// // //                                       radius: 50,
// // //                                       backgroundImage:
// // //                                           AssetImage('assets/profile.jpg'),
// // //                                     ),
// // //                                     const SizedBox(height: 10),
// // //                                     const Text(
// // //                                       'Hải Duy',
// // //                                       style: TextStyle(
// // //                                         fontWeight: FontWeight.bold,
// // //                                         fontSize: 22,
// // //                                       ),
// // //                                     ),
// // //                                     const SizedBox(height: 5),
// // //                                     const Text(
// // //                                       'Software Developer',
// // //                                       style: TextStyle(
// // //                                         color: Colors.grey,
// // //                                       ),
// // //                                     ),
// // //                                     const SizedBox(height: 20),
// // //                                     ElevatedButton.icon(
// // //                                       onPressed: cardController.toggleCard,
// // //                                       icon: const Icon(Icons.close),
// // //                                       label: const Text('Close'),
// // //                                     ),
// // //                                   ],
// // //                                 ),
// // //                               ),
// // //                             ),
// // //                           );
// // //                         },
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 ),
// // //               ),
// // //             );
// // //           }),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }

// // import 'dart:io';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/foundation.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:email_otp/email_otp.dart';
// // import '../models/user.dart';
// // import '../routes/app_pages.dart';
// // import 'resend_controller.dart'; // Import ResendController

// // // Các biến toàn cục
// // final FirebaseAuth _auth = FirebaseAuth.instance;
// // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// // Rx<User?> currentUser = Rx<User?>(null);

// // class AuthController extends GetxController {
// //   final EmailOTP myauth = EmailOTP();
// //   final RxString _code = ''.obs;
// //   String? name;
// //   File? image;
// //   Uint8List? webImage;
// //   String? email;
// //   String? password;
// //   final ResendController resendController =
// //       Get.put(ResendController()); // Khởi tạo ResendController

// //   //Getter for time, resend active and code
// //   bool get resendActive => resendController.isResendActive;
// //   int get time => resendController.time;
// //   String get code => _code.value;
// //   void updateCode(String value) {
// //     _code.value = value;
// //   }

// //   @override
// //   void onInit() {
// //     myauth.setConfig(
// //         appEmail: "Your Email",
// //         appName: "Project manager",
// //         userEmail: email!,
// //         otpLength: 6,
// //         otpType: OTPType.digitsOnly);
// //     resendController.startTimer();
// //     myauth.sendOTP();
// //     super.onInit();
// //   }

// //   Future<void> signUpWithEmailAndPassword(String name, File? image,
// //       Uint8List? webImage, String email, String password) async {
// //     this.name = name;
// //     this.image = image;
// //     this.webImage = webImage;
// //     this.email = email;
// //     this.password = password;
// //     try {
// //       Get.dialog(
// //         barrierDismissible: false,
// //         const Center(
// //           child: CircularProgressIndicator(),
// //         ),
// //       );
// //       Get.back(); // Remove progress indicator
// //       // Navigate to VerificationCode screen, and pass info for verification process
// //       Get.toNamed(Routes.VERIFICATION, arguments: email);
// //     } on TimeoutException catch (e) {
// //       Get.back();
// //       Get.closeAllSnackbars();
// //       Get.snackbar('Error', e.toString(), backgroundColor: Colors.red);
// //     } catch (e) {
// //       Get.back();
// //       Get.closeAllSnackbars();
// //       Get.snackbar('Error', e.toString(), backgroundColor: Colors.red);
// //     }
// //   }

// //   Future<void> _createUser() async {
// //     try {
// //       Get.dialog(
// //         barrierDismissible: false,
// //         const Center(
// //           child: CircularProgressIndicator(),
// //         ),
// //       );
// //       final credentialUser = await _auth
// //           .createUserWithEmailAndPassword(email: email!, password: password!)
// //           .timeout(
// //         const Duration(seconds: 10),
// //         onTimeout: () {
// //           Get.back();
// //           throw TimeoutException('Sign up time out. Please try again.');
// //         },
// //       );
// //       _completeSignUp(credentialUser);
// //     } on TimeoutException catch (e) {
// //       Get.back();
// //       Get.closeAllSnackbars();
// //       Get.snackbar('Error', e.toString(), backgroundColor: Colors.red);
// //     } catch (e) {
// //       Get.back();
// //       Get.closeAllSnackbars();
// //       Get.snackbar('Error', e.toString(), backgroundColor: Colors.red);
// //     }
// //   }

// //   Future<void> _completeSignUp(UserCredential credentialUser) async {
// //     try {
// //       String? imageUrl;
// //       credentialUser.user!.updateDisplayName(name);
// //       imageUrl = await _uploadImage(image ?? webImage);
// //       final user = credentialUser.user!;
// //       User newUser = User(
// //         id: user.uid,
// //         name: name!,
// //         email: email!,
// //         imageUrl: imageUrl,
// //         color: _generateRandomColor(),
// //       );
// //       currentUser.value = newUser;
// //       await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
// //       Get.back();
// //       Get.snackbar('Success', 'Login successful',
// //           backgroundColor: Colors.green);
// //       Get.offAllNamed(Routes.PROJECT);
// //     } catch (e) {
// //       Get.back();
// //       Get.closeAllSnackbars();
// //       Get.snackbar('Error', e.toString(), backgroundColor: Colors.red);
// //     }
// //   }

// //   Future<String?> _uploadImage(dynamic image) async {
// //     if (image == null) return null;
// //     try {
// //       final Reference storageReference =
// //           FirebaseStorage.instance.ref().child('images/${DateTime.now()}.png');
// //       UploadTask uploadTask;
// //       if (image is File) {
// //         uploadTask = storageReference.putFile(image);
// //       } else if (image is Uint8List) {
// //         uploadTask = storageReference.putData(image);
// //       } else {
// //         return null;
// //       }

// //       final TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
// //       final String downloadUrl = await snapshot.ref.getDownloadURL();
// //       return downloadUrl;
// //     } catch (e) {
// //       Get.snackbar('Error', 'Error while upload image',
// //           backgroundColor: Colors.red);
// //       return null;
// //     }
// //   }

// //   Color _generateRandomColor() {
// //     final random = Random();
// //     return Color.fromARGB(
// //       255,
// //       random.nextInt(256),
// //       random.nextInt(256),
// //       random.nextInt(256),
// //     );
// //   }

// //   void resendCode() {
// //     if (!resendController.isResendActive) return;
// //     myauth.sendOTP();
// //     resendController.resetTimer();
// //     resendController.startTimer();
// //   }

// //   Future<void> verifyOTP() async {
// //     if (_code.value.isEmpty) {
// //       Get.snackbar('Error', 'Please enter a code', backgroundColor: Colors.red);
// //       return;
// //     }
// //     if (await myauth.verifyOTP(otp: _code.value)) {
// //       Get.back();
// //       _createUser();
// //     } else {
// //       Get.snackbar('Error', 'Incorrect code, try again',
// //           backgroundColor: Colors.red);
// //     }
// //   }
// // }

// import 'dart:async';
// import 'dart:io';
// import 'dart:math';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloudinary_sdk/cloudinary_sdk.dart';
// import 'package:email_otp/email_otp.dart';
// import 'package:firebase_auth/firebase_auth.dart' as auth;
// // import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:project_manager/bindings/project_binding.dart';
// import 'package:project_manager/controllers/auth/resend_controller.dart';
// import 'package:project_manager/views/auths/verification_code.dart';
// import 'package:project_manager/models/user.dart';
// import 'package:project_manager/views/auths/login_screen.dart';
// import 'package:project_manager/views/projects/project_screen.dart';
// import 'package:project_manager/views/widgets/loading_overlay.dart';

// class AuthController extends GetxController {
//   final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   late Cloudinary _cloudinary;

//   final String cloudinaryCloudName = 'dcafv0pxk';
//   final String cloudinaryApiKey = '644694945142125';
//   final String cloudinaryApiSecret = 'pGI2hf7-AP3QsM1gA_rOpQqiTHk';

//   RxBool isShowPassword = true.obs;
//   RxBool isLogout = true.obs;
//   Rx<User?> currentUser = Rx<User?>(null);

//   final ResendController resendController = Get.put(ResendController());

//   bool get resendActive => resendController.isResendActive.value;
//   int get time => resendController.time.value;

//   @override
//   void onInit() {
//     super.onInit();

//     EmailOTP.config(
//       appName: 'Project Manager',
//       appEmail: 'haiduy2k3@gmail.com',
//       otpType: OTPType.numeric,
//       otpLength: 5,
//       emailTheme: EmailTheme.v4,
//       expiry: 60000,
//     );

//     _cloudinary = Cloudinary.full(
//       apiKey: cloudinaryApiKey,
//       apiSecret: cloudinaryApiSecret,
//       cloudName: cloudinaryCloudName,
//     );

//     // FirebaseMessaging.instance.getToken().then((token) {
//     //   if (token != null) {
//     //     _firestore
//     //         .collection('users')
//     //         .doc(currentUser.value!.id)
//     //         .update({'fcmToken': token});
//     //   }
//     // });

//     Future.delayed(const Duration(seconds: 1), () => checkIfUserIsLoggedIn());
//   }

//   void checkIfUserIsLoggedIn() async {
//     final user = _auth.currentUser;
//     if (user != null) {
//       final userDoc = await _firestore.collection('users').doc(user.uid).get();
//       if (userDoc.exists) {
//         final userData = userDoc.data();
//         currentUser.value = User.fromMap(data: userData!);
//         Get.offAll(() => ProjectScreen(), binding: ProjectBinding());
//         isLogout.value = false;
//       }
//     } else {
//       Get.offAll(() => LoginScreen());
//     }
//   }

//   Future<String?> _uploadImage(dynamic imageFile) async {
//     if (imageFile == null) {
//       return null;
//     }
//     try {
//       CloudinaryResponse? response;
//       if (imageFile is File) {
//         response = await _cloudinary.uploadResource(CloudinaryUploadResource(
//           filePath: imageFile.path,
//           resourceType: CloudinaryResourceType.auto,
//         ));
//       } else if (imageFile is Uint8List) {
//         response = await _cloudinary.uploadResource(CloudinaryUploadResource(
//           fileBytes: imageFile,
//           resourceType: CloudinaryResourceType.auto,
//         ));
//       }
//       if (response != null && response.isSuccessful) {
//         return response.secureUrl;
//       } else {
//         Get.snackbar('Error', 'Cloundiary upload failed: ${response?.error}');
//         throw Exception('Cloundiary upload failed: ${response?.error}');
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Error upload image: $e');
//       throw Exception('Error upload image: $e');
//     }
//   }

//   Future<void> signInWithEmailAndPassword(String email, String password) async {
//     try {
//       LoadingOverlay.show();
//       final credentialUser = await _auth
//           .signInWithEmailAndPassword(email: email, password: password)
//           .timeout(
//         const Duration(seconds: 10),
//         onTimeout: () {
//           Get.back();
//           throw TimeoutException('Login time out. Please try again.');
//         },
//       );

//       final userDoc = await _firestore
//           .collection('users')
//           .doc(credentialUser.user!.uid)
//           .get();
//       if (userDoc.exists) {
//         currentUser.value = User.fromMap(data: userDoc.data()!);
//         LoadingOverlay.hide();
//         Get.snackbar('Success', 'Login Success', colorText: Colors.green);
//         Get.offAll(() => ProjectScreen(), binding: ProjectBinding());
//         isLogout.value = false;
//       }
//     } on TimeoutException catch (e) {
//       LoadingOverlay.hide();
//       Get.closeAllSnackbars();
//       Get.snackbar('Error', e.toString(), colorText: Colors.red);
//     } catch (e) {
//       LoadingOverlay.hide();
//       Get.closeAllSnackbars();
//       Get.snackbar('Error', e.toString(), colorText: Colors.red);
//     }
//   }

//   void goToVerificationScreen(String name, String job, File? image,
//       Uint8List? webImage, String email, String password) async {
//     LoadingOverlay.show();

//     try {
//       final querySnapShot = await _firestore
//           .collection('users')
//           .where('email', isEqualTo: email)
//           .limit(1)
//           .get();
//       if (querySnapShot.docs.isEmpty) {
//         if (await EmailOTP.sendOTP(email: email)) {
//           LoadingOverlay.hide();
//           Get.to(() => VerificationCode(
//                 email: email,
//                 name: name,
//                 job: job,
//                 image: image,
//                 webImage: webImage,
//                 password: password,
//               ));
//           resendController.startTimer();
//         } else {
//           LoadingOverlay.hide();
//         }
//       } else {
//         Get.closeAllSnackbars();
//         LoadingOverlay.hide();
//         Get.snackbar(
//           'Error',
//           'Email address already in use',
//           colorText: Colors.red,
//         );
//       }
//     } catch (e) {
//       Get.closeAllSnackbars();
//       LoadingOverlay.hide();
//       Get.snackbar(
//         'Error',
//         e.toString(),
//         colorText: Colors.red,
//       );
//     }
//   }

//   void resendCode(String email) async {
//     if (!resendController.isResendActive.value) return;
//     await EmailOTP.sendOTP(email: email);
//     resendController.resetTimer();
//     resendController.startTimer();
//   }

//   Future<void> signUpWithEmailAndPassword(String name, String job, File? image,
//       Uint8List? webImage, String email, String password) async {
//     try {
//       LoadingOverlay.show();
//       final credentialUser = await _auth
//           .createUserWithEmailAndPassword(email: email, password: password)
//           .timeout(
//         const Duration(seconds: 10),
//         onTimeout: () {
//           Get.back();
//           throw TimeoutException('Sign up time out. Please try again.');
//         },
//       );
//       String? imageUrl;
//       credentialUser.user!.updateDisplayName(name);
//       imageUrl = await _uploadImage(image ?? webImage);
//       final user = credentialUser.user!;
//       User newUser = User(
//         id: user.uid,
//         name: name,
//         job: job,
//         email: email,
//         imageUrl: imageUrl,
//         color: _generateRandomColor(),
//       );
//       currentUser.value = newUser;
//       await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
//       LoadingOverlay.hide();
//       isLogout.value = false;
//       Get.snackbar('Success', 'Login successful', colorText: Colors.green);
//       Get.offAll(() => ProjectScreen(), binding: ProjectBinding());
//     } on TimeoutException catch (e) {
//       LoadingOverlay.hide();
//       Get.closeAllSnackbars();
//       Get.snackbar('Error', e.toString(), colorText: Colors.red);
//     } catch (e) {
//       LoadingOverlay.hide();
//       Get.closeAllSnackbars();
//       Get.snackbar('Error', e.toString(), colorText: Colors.red);
//     }
//   }

//   Future<void> updateUser(
//       {String? name,
//       String? job,
//       String? phone,
//       File? image,
//       Uint8List? imageWeb}) async {
//     try {
//       LoadingOverlay.show();
//       String? imageUrl = await _uploadImage(image ?? imageWeb);
//       await _auth.currentUser?.updateDisplayName(name);
//       if (_auth.currentUser != null) {
//         final userId = _auth.currentUser!.uid;
//         await _firestore.collection('users').doc(userId).update({
//           'name': name,
//           'job': job,
//           'phone': phone,
//           'imageUrl': imageUrl ?? currentUser.value!.imageUrl,
//         });
//         currentUser.value = User(
//           id: userId,
//           name: name ?? currentUser.value!.name,
//           phone: phone ?? currentUser.value!.phone,
//           job: job ?? currentUser.value!.job,
//           email: currentUser.value!.email,
//           imageUrl: imageUrl ?? currentUser.value!.imageUrl,
//           color: currentUser.value!.color,
//         );
//         await LoadingOverlay.hide();
//         Get.closeAllSnackbars();
//         Get.snackbar('Success', 'Update information successfull',
//             colorText: Colors.green);
//       } else {
//         await LoadingOverlay.hide();
//         Get.closeAllSnackbars();

//         Get.snackbar('Error', 'Not found user', colorText: Colors.red);
//       }
//     } on auth.FirebaseAuthException catch (e) {
//       await LoadingOverlay.hide();
//       Get.closeAllSnackbars();
//       Get.snackbar('Error', e.message ?? 'An error has occurred',
//           colorText: Colors.red);
//     } catch (e) {
//       await LoadingOverlay.hide();
//       Get.closeAllSnackbars();
//       Get.snackbar('Error', e.toString(), colorText: Colors.red);
//     }
//   }

//   Future<void> resetPassword(String email) async {
//     try {
//       await _auth.sendPasswordResetEmail(email: email);
//       Get.snackbar('Reset password', 'Please choose new password in email');
//     } catch (e) {
//       Get.snackbar('Error', e.toString(), backgroundColor: Colors.red);
//     }
//   }

//   Future<void> signOut() async {
//     try {
//       isLogout.value = true;
//       await _auth.signOut();
//       Get.offAll(() => LoginScreen());
//     } catch (e) {
//       Get.snackbar('Error', e.toString());
//     }
//   }

//   void showPassword() {
//     isShowPassword.value = !isShowPassword.value;
//   }
// }

// Color _generateRandomColor() {
//   final random = Random();
//   return Color.fromRGBO(
//     random.nextInt(256),
//     random.nextInt(256),
//     random.nextInt(256),
//     1,
//   );
// }
// SizedBox(
                //   height: 40,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Spacer(
                //         flex: kIsWeb ? 2 : 1,
                //       ),
                //       Expanded(
                //         flex: 10,
                //         child: Container(
                //           // color: Colors.purple,
                //           child: ListView(
                //             shrinkWrap: true,
                //             padding: const EdgeInsets.symmetric(horizontal: 0),
                //             scrollDirection: Axis.horizontal,
                //             children: [
                //               _customLable(context, label: 'all'.tr, ontap: () {}),
                //               SizedBox(
                //                 width: sizeWidth,
                //               ),
                //               _customLable(context,
                //                   label: 'not start'.tr, ontap: () {}),
                //               SizedBox(
                //                 width: sizeWidth,
                //               ),
                //               _customLable(context,
                //                   label: 'in progress'.tr, ontap: () {}),
                //               SizedBox(
                //                 width: sizeWidth,
                //               ),
                //               _customLable(context,
                //                   label: 'completed'.tr, ontap: () {}),
                //               SizedBox(
                //                 width: sizeWidth,
                //               ),
                //               _customLable(context,
                //                   label: 'late completed'.tr, ontap: () {}),
                //               SizedBox(
                //                 width: sizeWidth,
                //               ),
                //               _customLable(context,
                //                   label: 'unfinished'.tr, ontap: () {}),
                //             ],
                //           ),
                //         ),
                //       ),
                //       Spacer(
                //         flex: 1,
                //       ),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 10),