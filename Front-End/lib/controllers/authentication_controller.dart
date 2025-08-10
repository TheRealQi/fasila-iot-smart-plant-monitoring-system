import 'package:fasila/views/authentication_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../shared_pref.dart';
import '../views/initial_loading_page.dart';
import 'notifications_controller.dart';

class AuthenticationController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final isLoginLoading = false.obs;
  final isRegisterLoading = false.obs;
  final isLogoutLoading = false.obs;
  final RxBool isSignIn = true.obs;

  static String apiUrl = dotenv.env['API_URL']!;
  static String loginEndpoint = '$apiUrl/auth/login/';
  static String registerEndpoint = '$apiUrl/auth/register/';
  static String logoutEndpoint = '$apiUrl/auth/logout/';

  void toggleAuthMode() {
    isSignIn.value = !isSignIn.value;
  }

  Future<void> loginWithConstantUser() async {
    usernameController.text = "Q_i99";
    passwordController.text = "Test123@";
    await login();
  }

  Future<void> login() async {
    try {
      isLoginLoading.value = true;
      final response = await http.post(
        Uri.parse(loginEndpoint),
        headers: {
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'username': usernameController.text,
          'password': passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await CacheHelper.saveDataToSharedPrefrence('access_token', data['access']);
        await CacheHelper.saveDataToSharedPrefrence(
            'refresh_token', data['refresh']);
        await CacheHelper.saveDataToSharedPrefrence(
            'user_id', data['user_id'].toString());
        usernameController.clear();
        passwordController.clear();

        Get.offAll(()=> InitialLoadingScreen());
      } else {
        print(response.statusCode);
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Login failed');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.bottom,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoginLoading.value = false;
    }
  }

  Future<void> register() async {
    try {
      isRegisterLoading.value = true;

      final response = await http.post(
        Uri.parse(registerEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': usernameController.text,
          'email': emailController.text,
          'password': passwordController.text,
        }),
      );

      if (response.statusCode == 201) {
        usernameController.clear();
        emailController.clear();
        passwordController.clear();
        Get.snackbar(
          'Success',
          'Registration successful. Please login.',
          snackPosition: SnackPosition.bottom,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        isSignIn.value = true;
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Registration failed');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.bottom,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isRegisterLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLogoutLoading.value = true;

      final fcmToken = await CacheHelper.getDataFromSharedPrefrence('last_fcm_token');
      if (fcmToken != null) {
        final notificationController = Get.find<NotificationController>();
        await notificationController.deleteCurrentToken();
      }
        await CacheHelper.clearData();
        Get.offAll(() => AuthenticationPage());
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.bottom,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLogoutLoading.value = false;
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
