import 'package:fasila/views/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../colors.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage(
      {super.key, required this.onRetry, this.error = 'Something Went Wrong!'});

  final VoidCallback? onRetry;
  final String error;

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
          child: Stack(
            children: [
              Positioned(
                left: 16.w,
                child: CustomIconButton(
                  tapAction: () => Get.back(),
                  icon: Icons.arrow_back,
                ),
              ),
              Center(
                child: SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/error.png',
                        width: 75.w,
                        height: 75.h,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        error,
                        style: TextStyle(
                          color: AppColor.text,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Please try again.',
                        style: TextStyle(
                          color: AppColor.text,
                          fontSize: 14.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.h),
                      TextButton(
                        onPressed: () {
                          if (onRetry != null) onRetry!();
                        },
                        style: TextButton.styleFrom(
                          side: BorderSide(color: AppColor.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0.r),
                          ),
                          minimumSize: Size(70.w, 40.h),
                          maximumSize: Size(100.w, 40.h),
                        ),
                        child: Text(
                          'Try Again',
                          style: TextStyle(
                            color: AppColor.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
