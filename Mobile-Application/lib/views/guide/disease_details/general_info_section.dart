import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../colors.dart';

class DiseaseGeneralInfoSection extends StatelessWidget {
  const DiseaseGeneralInfoSection({
    super.key,
    required this.name,
    required this.description,
    required this.symptoms,
  });

  final String name;
  final String description;
  final List<String> symptoms;

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
                "General Info",
                style: TextStyle(
                  color: AppColor.text,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
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
                      Row(
                        children: [
                          Text(
                            "Name:",
                            style: TextStyle(
                              color: AppColor.text,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            name,
                            style: TextStyle(
                              color: AppColor.text,

                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      SizedBox(height: 10.h),
                      Text(
                        "Description:",
                        style: TextStyle(
                          color: AppColor.text,

                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        description,
                        style: TextStyle(
                          color: AppColor.text,

                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _buildListSection("Symptoms", symptoms),
          ]),
    );
  }
  Widget _buildListSection(String title, List<String> list) {
    return symptoms.isNotEmpty
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
                title,
                style: TextStyle(
                  color: AppColor.text,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.h),
              ...list.map((list) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Text(
                    "\u2022 $list",
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
    ) : SizedBox();
  }
}
