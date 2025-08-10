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
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 100.h,
            width: double.infinity,
            color: AppColor.appBar,
            padding: EdgeInsets.only(bottom: 10.h, right: 16.w, left: 16.w),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
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
                          color: Colors.black,
                          fontSize: 16.0.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 40.w),
                ],
              ),
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
