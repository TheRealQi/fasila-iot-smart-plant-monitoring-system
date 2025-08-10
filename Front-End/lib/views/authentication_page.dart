import 'package:fasila/controllers/authentication_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../colors.dart';

class AuthenticationPage extends StatelessWidget {
  AuthenticationPage({super.key});

  final double appBarHeight = 100.0.h;
  final AuthenticationController authController = Get.put(AuthenticationController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor.appBar,
            AppColor.background,
          ],
          stops: const [0.7, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: appBarHeight,
                width: double.infinity,
                color: Colors.transparent,
                padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 10.h),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(() => Text(
                                authController.isSignIn.value
                                    ? 'Sign In'
                                    : 'Sign Up',
                                style: TextStyle(
                                  color: AppColor.text,
                                  fontSize: 28.0.sp,
                                  fontWeight: FontWeight.w900,
                                ),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Obx(() => authController.isSignIn.value
                            ? _buildSignInContent()
                            : _buildSignUpContent()),
                        SizedBox(height: 16.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Obx(() => Text(
                                  authController.isSignIn.value
                                      ? "Don't have an account? "
                                      : 'Already have an account? ',
                                  style: TextStyle(color: AppColor.text),
                                )),
                            TextButton(
                              onPressed: authController.toggleAuthMode,
                              child: Obx(() => Text(
                                    authController.isSignIn.value
                                        ? 'Sign Up'
                                        : 'Sign In',
                                    style: TextStyle(
                                      color: AppColor.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignInContent() {
    return Column(
      children: [
        TextField(
          controller: authController.usernameController,
          decoration: InputDecoration(
            hintText: 'Username',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16.h),
        TextField(
          controller: authController.passwordController,
          decoration: InputDecoration(
            hintText: 'Password',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
        ),
        SizedBox(height: 24.h),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(AppColor.primary),
          ),
          onPressed: () {
            authController.login();
          },
          child: Text('Sign In',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpContent() {
    return Column(
      children: [
        TextField(
          controller: authController.usernameController,
          decoration: InputDecoration(
            hintText: 'Username',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16.h),
        TextField(
          controller: authController.emailController,
          decoration: InputDecoration(
            hintText: 'Email',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16.h),
        TextField(
          controller: authController.passwordController,
          decoration: InputDecoration(
            hintText: 'Password',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
        ),
        SizedBox(height: 24.h),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(AppColor.primary),
          ),
          onPressed: () {
            authController.register();
          },
          child: Text('Sign Up',
              style: TextStyle(
                color: Colors.white,
              ),
          ),
        ),
      ],
    );
  }
}
