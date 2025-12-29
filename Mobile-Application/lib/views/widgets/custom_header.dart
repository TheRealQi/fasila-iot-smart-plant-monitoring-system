import 'package:fasila/views/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../colors.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({super.key, required this.body, required this.headerText});

  final Widget body;
  final String headerText;

  @override
  Widget build(BuildContext context) {
    final paddingTop = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColor.background,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 100.h,
            color: AppColor.appBar,
            padding: EdgeInsets.only(
              left: 16.w,
              right: 16.w,
              top: MediaQuery.of(context).padding.top,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomIconButton(
                      tapAction: () => Get.back(),
                      icon: Icons.arrow_back,
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          headerText,
                          style: TextStyle(
                            color: AppColor.text,
                            fontSize: 16.0.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 40.w), // Placeholder for alignment
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: body,
          ),
        ],
      ),
    );
  }
}
