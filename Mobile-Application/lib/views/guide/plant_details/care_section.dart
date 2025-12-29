import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../colors.dart';
import 'light_guide.dart';

class CareSection extends StatelessWidget {
  const CareSection({
    super.key,
    required this.light,
    required this.altLight,
    required this.minimumTemperature,
    required this.maximumTemperature,
    required this.seedingDepth,
    required this.minimumSeedSpacing,
    required this.maximumSeedSpacing,
    required this.minimumGerminationTime,
    required this.maximumGerminationTime,
    required this.minimumGermTemperature,
    required this.maximumGermTemperature,
    required this.watering,
  });

  final String? light;
  final String? altLight;
  final int? minimumTemperature;
  final int? maximumTemperature;
  final double? seedingDepth;
  final int? minimumSeedSpacing;
  final int? maximumSeedSpacing;
  final int? minimumGerminationTime;
  final int? maximumGerminationTime;
  final int? minimumGermTemperature;
  final int? maximumGermTemperature;
  final String? watering;

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
                "Care",
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColor.text,
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
                      Text(
                        "Sunlight & Temperature",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColor.text,
                        ),
                      ),
                      Divider(),
                      SizedBox(height: 10.h),
                      Text(
                        "Recommended Sunlight",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColor.text,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.sunny,
                                  color: Colors.orange, size: 40.w),
                              SizedBox(width: 10.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    light!,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.text,
                                    ),
                                  ),
                                  Text(
                                    light == "Full Sun"
                                        ? "6-8 hours"
                                        : "5-6 hours",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColor.text,
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () => Get.to(() => LightGuide()),
                                child: Text(
                                  "More Details",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Divider(),
                      SizedBox(height: 10.h),
                      Text(
                        "Recommended Temperature",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColor.text,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('0°C',
                                  style: TextStyle(
                                      fontSize: 16.sp, color: AppColor.text)),
                              Text('100°C',
                                  style: TextStyle(
                                      fontSize: 16.sp, color: AppColor.text)),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 30.h,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              Positioned(
                                left: (20 / 100) *
                                    MediaQuery.of(context).size.width.w *
                                    0.75,
                                right: (100 - 80) /
                                    100 *
                                    MediaQuery.of(context).size.width.w *
                                    0.75,
                                child: Container(
                                  height: 30.h,
                                  decoration: BoxDecoration(
                                    color: AppColor.primary,
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                child: Center(
                                  child: Text(
                                    '$minimumTemperature - $maximumTemperature °C',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
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
                      Text(
                        "Seeding",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Text(
                            "Seeding Depth:",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            "$seedingDepth cm",
                            style: TextStyle(
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Text(
                            "Seed Spacing:",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            "$minimumSeedSpacing - $maximumSeedSpacing cm",
                            style: TextStyle(
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Text(
                            "Germination Time:",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            '$minimumGerminationTime - $maximumGerminationTime days',
                            style: TextStyle(
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Recommended Germination Temperature:",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('0°C', style: TextStyle(fontSize: 16.sp)),
                              Text('100°C', style: TextStyle(fontSize: 16.sp)),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 30.h,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              Positioned(
                                left: (20 / 100) *
                                    MediaQuery.of(context).size.width.w *
                                    0.75,
                                right: (100 - 80) /
                                    100 *
                                    MediaQuery.of(context).size.width.w *
                                    0.75,
                                child: Container(
                                  height: 30.h,
                                  decoration: BoxDecoration(
                                    color: AppColor.primary,
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                child: Center(
                                  child: Text(
                                    '$minimumGermTemperature - $maximumGermTemperature °C',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Container(
            //   margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
            //   width: double.infinity,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(10.r),
            //     color: Colors.white,
            //   ),
            //   child: Card(
            //     margin: EdgeInsets.zero,
            //     elevation: 2,
            //     color: Colors.white,
            //     child: Padding(
            //       padding: EdgeInsets.only(
            //           left: 16.w, right: 16.w, top: 16.h, bottom: 16.h),
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text(
            //             "Soil & Fertilizing",
            //             style: TextStyle(
            //               fontSize: 18.sp,
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //           Divider(),
            //           SizedBox(height: 10.h),
            //           Text(
            //             "Recommended Soil Type:",
            //             style: TextStyle(
            //               fontSize: 16.sp,
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //           SizedBox(width: 5.w),
            //           Text(
            //             soilType!,
            //             style: TextStyle(
            //               fontSize: 14.sp,
            //             ),
            //           ),
            //           SizedBox(height: 10.h),
            //           Row(
            //             children: [
            //               Text(
            //                 "Recommended Soil Depth:",
            //                 style: TextStyle(
            //                   fontSize: 16.sp,
            //                   fontWeight: FontWeight.bold,
            //                 ),
            //               ),
            //               SizedBox(width: 5.w),
            //               Text(
            //                 soilDepth!,
            //                 style: TextStyle(
            //                   fontSize: 14.sp,
            //                 ),
            //               ),
            //             ],
            //           ),
            //           const Divider(),
            //           SizedBox(height: 10.h),
            //           Text(
            //             "Fertilizing",
            //             style: TextStyle(
            //               fontSize: 16.sp,
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //           SizedBox(height: 10.h),
            //           Text(
            //             "Recommended Fertilizers:",
            //             style: TextStyle(
            //               fontSize: 16.sp,
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //           Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               for (var fertilizer in fertilizing!)
            //                 Text(
            //                   fertilizer,
            //                   style: TextStyle(
            //                     fontSize: 14.sp,
            //                   ),
            //                 ),
            //             ],
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
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
                      Text(
                        "Watering",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        watering!,
                        style: TextStyle(
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
    );
  }
}
