import 'dart:async';
import 'package:fasila/controllers/authentication_controller.dart';
import 'package:fasila/views/authentication_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../colors.dart';
import '../shared_pref.dart';
import 'home.dart';

class InitialLoadingScreen extends StatefulWidget {
  const InitialLoadingScreen({super.key});

  @override
  State<InitialLoadingScreen> createState() => _InitialLoadingScreen();
}

var access_token = CacheHelper.getDataFromSharedPrefrence('access_token');

startTimer() {
  Timer(Duration(seconds: 3), () async {
    if (access_token != null) {
      Get.offAll(() => Home());
    } else {
      Get.offAll(() => AuthenticationPage());
    }
  });
}

class _InitialLoadingScreen extends State<InitialLoadingScreen> {

  AuthenticationController authController = Get.find<AuthenticationController>();
  @override
  void initState() {
    super.initState();
    authController.loginWithConstantUser();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColor.appBar,
              AppColor.background,
            ],
            stops: [0.7, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColor.primary),
            ),
          ),
        ),
      ),
    );
  }
}
