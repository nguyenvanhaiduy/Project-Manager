import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:project_manager/controllers/auth/resend_controller.dart';
import 'package:project_manager/routers/app_routers.dart';
import 'package:project_manager/models/user.dart';
import 'package:project_manager/views/auths/login_screen.dart';
import 'package:project_manager/views/widgets/loading_overlay.dart';

class AuthController extends GetxController {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Cloudinary _cloudinary;

  final String cloudinaryCloudName = 'dcafv0pxk';
  final String cloudinaryApiKey = '644694945142125';
  final String cloudinaryApiSecret = 'pGI2hf7-AP3QsM1gA_rOpQqiTHk';

  RxBool isShowPassword = true.obs;
  RxBool isLogout = true.obs;
  Rx<User?> currentUser = Rx<User?>(null);
  String? currentOtp;

  final ResendController resendController = Get.put(ResendController());

  bool get resendActive => resendController.isResendActive.value;
  int get time => resendController.time.value;

  @override
  void onInit() {
    super.onInit();

    _cloudinary = Cloudinary.full(
      apiKey: cloudinaryApiKey,
      apiSecret: cloudinaryApiSecret,
      cloudName: cloudinaryCloudName,
    );
  }

  @override
  void onReady() {
    super.onReady();
    Future.delayed(
      const Duration(seconds: 1),
      () async => await checkIfUserIsLoggedIn(),
    );
  }

  Future<void> checkIfUserIsLoggedIn() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        final userData = userDoc.data();
        currentUser.value = User.fromMap(data: userData!);
        // Get.offAllNamed(AppRouters.project);
        print("User logged in, going to HOME");

        Get.offAllNamed(AppRouters.home);
        isLogout.value = false;
      }
    } else {
      print("User not found, going to LOGIN");

      Get.offAllNamed(AppRouters.login);
    }
  }

  Future<String?> _uploadImage(dynamic imageFile) async {
    if (imageFile == null) {
      return null;
    }
    try {
      CloudinaryResponse? response;
      if (imageFile is File) {
        response = await _cloudinary.uploadResource(CloudinaryUploadResource(
          filePath: imageFile.path,
          resourceType: CloudinaryResourceType.auto,
        ));
      } else if (imageFile is Uint8List) {
        response = await _cloudinary.uploadResource(CloudinaryUploadResource(
          fileBytes: imageFile,
          resourceType: CloudinaryResourceType.auto,
        ));
      }
      if (response != null && response.isSuccessful) {
        return response.secureUrl;
      } else {
        Get.snackbar('Error', 'Cloundiary upload failed: ${response?.error}');
        throw Exception('Cloundiary upload failed: ${response?.error}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error upload image: $e');
      throw Exception('Error upload image: $e');
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    LoadingOverlay.show();
    try {
      final credentialUser = await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          Get.back();
          throw TimeoutException('Login time out. Please try again.');
        },
      );

      final userDoc = await _firestore
          .collection('users')
          .doc(credentialUser.user!.uid)
          .get();
      if (userDoc.exists) {
        currentUser.value = User.fromMap(data: userDoc.data()!);
        Get.snackbar('Success', 'Login Success', colorText: Colors.green);
        // Get.offAll(() => ProjectScreen(), binding: ProjectBinding());
        Get.offAllNamed(AppRouters.home);

        isLogout.value = false;
      }
      LoadingOverlay.hide();
    } catch (e) {
      LoadingOverlay.hide();
      Get.closeAllSnackbars();
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
    } finally {
      LoadingOverlay.hide();
    }
  }

  void goToVerificationScreen(String name, String job, File? image,
      Uint8List? webImage, String email, String password) async {
    LoadingOverlay.show();

    try {
      final querySnapShot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      if (querySnapShot.docs.isEmpty) {
        if (await sendOTP(email)) {
          LoadingOverlay.hide();
          Get.toNamed(AppRouters.verification, arguments: {
            'email': email,
            'name': name,
            'job': job,
            'image': image,
            'webImage': webImage,
            'password': password,
          });
          resendController.resetTimer();
          resendController.startTimer();
        } else {
          LoadingOverlay.hide();
        }
      } else {
        Get.closeAllSnackbars();
        LoadingOverlay.hide();
        Get.snackbar(
          'Error',
          'Email address already in use',
          colorText: Colors.red,
        );
      }
    } catch (e) {
      if (Get.isSnackbarOpen) Get.closeAllSnackbars();
      LoadingOverlay.hide();
      Get.snackbar(
        'Error',
        e.toString(),
        colorText: Colors.red,
      );
    }
  }

  void resendCode(String email) async {
    if (!resendController.isResendActive.value) return;
    await sendOTP(email);
    resendController.resetTimer();
    resendController.startTimer();
  }

  Future<bool> sendOTP(String email) async {
    final otp = generateOTP();
    currentOtp = otp;
    final smtpServer = gmail('testmode2k3@gmail.com', 'bfvs wrdw vzoe lczo');
    final message = Message()
      ..from = const Address('testmode2k3@gmail.com', 'Duy Nguyễn')
      ..recipients.add(email)
      ..subject = 'Mã OTP xác thực tài khoản'
      ..html = '''
    <!DOCTYPE html>
    <html lang="vi">
      <head>
        <meta charset="UTF-8">
        <title>Mã OTP của bạn</title>
        <style>
          body {
            font-family: sans-serif;
            background-color: #f4f4f4;
            color: #333;
          }
          .container {
            width: 600px;
            margin: 0 auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
          }
          h1 {
            color: #007bff; /* Blue color */
          }
          .otp-code {
            font-size: 24px;
            font-weight: bold;
            letter-spacing: 2px;
            margin-bottom: 20px;
            padding: 10px;
            background-color: #e9ecef;
            border-radius: 5px;
            text-align: center; 
          }
          .expiry {
            font-size: 12px;
            color: #6c757d; /* Gray color */
          }
        </style>
      </head>
      <body>
        <div class="container">
          <h1>Xin chào,</h1>
          <p>Mã OTP của bạn để xác thực tài khoản là:</p>
          <div class="otp-code">$otp</div>
          <p class="expiry">Mã này sẽ hết hạn sau 2 phút.</p>
          <p>Nếu bạn không yêu cầu mã này, vui lòng bỏ qua email này.</p>
        </div>
      </body>
    </html>
  ''';
    try {
      final sendReport = await send(message, smtpServer);
      if (kDebugMode) {
        print('OTP sent: $sendReport');
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error sending OTP: $e');
      }
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
      return false;
    }
  }

  String generateOTP() {
    final random = Random();
    return (10000 + random.nextInt(90000)).toString();
  }

  Future<void> signUpWithEmailAndPassword(String name, String job, File? image,
      Uint8List? webImage, String email, String password) async {
    try {
      LoadingOverlay.show();
      final credentialUser = await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          Get.back();
          throw TimeoutException('Sign up time out. Please try again.');
        },
      );
      final user = credentialUser.user!;
      print(user.displayName);

      String? imageUrl;
      credentialUser.user!.updateDisplayName(name);
      imageUrl = await _uploadImage(image ?? webImage);
      User newUser = User(
        id: user.uid,
        name: name,
        job: job,
        email: email,
        imageUrl: imageUrl,
        color: _generateRandomColor(),
      );
      currentUser.value = newUser;

      await _firestore.collection('users').doc(user.uid).set(newUser.toMap());

      Get.snackbar('Success', 'Login successful', colorText: Colors.green);
      // Get.offAll(() => ProjectScreen(), binding: ProjectBinding());
      Get.offAllNamed(AppRouters.home);

      LoadingOverlay.hide();
      isLogout.value = false;
    } on TimeoutException catch (e) {
      LoadingOverlay.hide();
      if (Get.isSnackbarOpen) Get.closeAllSnackbars();
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
    } catch (e) {
      LoadingOverlay.hide();
      if (Get.isSnackbarOpen) Get.closeAllSnackbars();
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
    } finally {
      LoadingOverlay.hide();
    }
  }

  Future<void> updateUser(
      {String? name,
      String? job,
      String? phone,
      File? image,
      Uint8List? imageWeb}) async {
    try {
      LoadingOverlay.show();
      String? imageUrl = await _uploadImage(image ?? imageWeb);
      await _auth.currentUser?.updateDisplayName(name);
      if (_auth.currentUser != null) {
        final userId = _auth.currentUser!.uid;
        await _firestore.collection('users').doc(userId).update({
          'name': name,
          'job': job,
          'phone': phone,
          'imageUrl': imageUrl ?? currentUser.value!.imageUrl,
        });
        currentUser.value = User(
          id: userId,
          name: name ?? currentUser.value!.name,
          phone: phone ?? currentUser.value!.phone,
          job: job ?? currentUser.value!.job,
          email: currentUser.value!.email,
          imageUrl: imageUrl ?? currentUser.value!.imageUrl,
          color: currentUser.value!.color,
        );
        await LoadingOverlay.hide();
        if (Get.isSnackbarOpen) Get.closeAllSnackbars();

        Get.snackbar('Success', 'Update information successfull',
            colorText: Colors.green);
      } else {
        await LoadingOverlay.hide();
        if (Get.isSnackbarOpen) Get.closeAllSnackbars();
        Get.snackbar('Error', 'Not found user', colorText: Colors.red);
      }
    } on auth.FirebaseAuthException catch (e) {
      await LoadingOverlay.hide();
      if (Get.isSnackbarOpen) Get.closeAllSnackbars();
      Get.snackbar('Error', e.message ?? 'An error has occurred',
          colorText: Colors.red);
    } catch (e) {
      await LoadingOverlay.hide();
      Get.closeAllSnackbars();
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Get.snackbar('Reset password', 'Please choose new password in email');
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red);
    }
  }

  Future<void> signOut() async {
    LoadingOverlay.show();
    try {
      isLogout.value = true;
      await _auth.signOut();
      Get.offAll(() => LoginScreen());
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      LoadingOverlay.hide();
    }
  }

  void showPassword() {
    isShowPassword.value = !isShowPassword.value;
  }
}

Color _generateRandomColor() {
  final random = Random();
  return Color.fromRGBO(
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
    1,
  );
}
