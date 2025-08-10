import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../colors.dart';

class PreventionSection extends StatelessWidget {
  const PreventionSection({
    super.key,
    required this.preventions,
  });

  final List<String> preventions;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.all(16.w),
            child: Text(
              "Preventions",
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: AppColor.text,
              ),
            ),
          ),
          _buildPreventionSection(preventions),
        ],
      ),
    );
  }

  Widget _buildPreventionSection(List<String> preventions) {
    return preventions.isNotEmpty
        ? Container(
            margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: Colors.white,
            ),
            child: Card(
              margin: EdgeInsets.zero,
              elevation: 2,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.only(
                    left: 16.w, right: 16.w, top: 16.h, bottom: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Preventions",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.text,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    ...preventions.map((prevention) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        child: Text(
                          "\u2022 $prevention",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColor.text,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          )
        : SizedBox();
  }
}
