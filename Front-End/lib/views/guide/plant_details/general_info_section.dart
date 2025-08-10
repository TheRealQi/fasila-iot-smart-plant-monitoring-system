import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../colors.dart';

class PlantGeneralInfoSection extends StatelessWidget {
  const PlantGeneralInfoSection(
      {super.key,
      required this.commonName,
      required this.botanicalName,
      required this.type,
      required this.description,
      required this.waterConsumption,
      required this.light,
      required this.difficulty,
      required this.minHeight,
      required this.maxHeight,
      required this.minimumGrowthTime,
      required this.maximumGrowthTime});

  final String? commonName;
  final String? botanicalName;
  final String? type;
  final String? description;
  final String? waterConsumption;
  final String? light;
  final String? difficulty;
  final int? minHeight;
  final int? maxHeight;
  final int? minimumGrowthTime;
  final int? maximumGrowthTime;

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
                            "Common Name:",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            commonName!,
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
                            "Botanical Name:",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            botanicalName!,
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
                            "Type:",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            type!,
                            style: TextStyle(
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
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        description!,
                        style: TextStyle(
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.only(bottom: 10.h),
                        width: 171.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: Colors.white,
                        ),
                        child: Card(
                          margin: EdgeInsets.zero,
                          elevation: 2,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 8.w, right: 8.w, top: 8.h, bottom: 8.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.water_drop_rounded,
                                  color: Colors.blue,
                                  size: 24.w,
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Text(
                                  waterConsumption!,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                    SizedBox(
                      width: 16.w,
                    ),
                    Container(
                        margin: EdgeInsets.only(bottom: 10.h),
                        width: 171.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: Colors.white,
                        ),
                        child: Card(
                          margin: EdgeInsets.zero,
                          elevation: 2,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 8.w, right: 8.w, top: 8.h, bottom: 8.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.sunny,
                                  color: Colors.orange,
                                  size: 24.w,
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Text(
                                  light!,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Container(
                    //     margin: EdgeInsets.only(bottom: 10.h),
                    //     width: 171.w,
                    //     decoration: BoxDecoration(
                    //       borderRadius:
                    //       BorderRadius.circular(10.r),
                    //       color: Colors.white,
                    //     ),
                    //     child: Card(
                    //       margin: EdgeInsets.zero,
                    //       elevation: 2,
                    //       color: Colors.white,
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius:
                    //         BorderRadius.circular(10.r),
                    //       ),
                    //       child: Padding(
                    //         padding: EdgeInsets.only(
                    //             left: 8.w,
                    //             right: 8.w,
                    //             top: 8.h,
                    //             bottom: 8.h),
                    //         child: Row(
                    //           mainAxisAlignment:
                    //           MainAxisAlignment.start,
                    //           crossAxisAlignment:
                    //           CrossAxisAlignment.center,
                    //           children: [
                    //             Icon(
                    //               season == "Winter" ? Icons.ac_unit : season == "Summer" ? Icons.wb_sunny : season == "Spring" ? Icons.local_florist : season == "Autumn" ? Icons.park : Icons.wb_sunny,
                    //               color: season == "Winter" ? Colors.blue : season == "Summer" ? Colors.yellow : season == "Spring" ? AppColor.primary : season == "Autumn" ? Colors.orange : Colors.grey,
                    //               size: 24.w,
                    //             ),
                    //             SizedBox(
                    //               width: 5.w,
                    //             ),
                    //             Text(
                    //               season!,
                    //               style: TextStyle(
                    //                 fontSize: 14.sp,
                    //                 fontWeight: FontWeight.bold,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     )),
                    SizedBox(
                      width: 16.w,
                    ),
                    Container(
                        margin: EdgeInsets.only(bottom: 10.h),
                        width: 171.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: Colors.white,
                        ),
                        child: Card(
                          margin: EdgeInsets.zero,
                          elevation: 2,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 8.w, right: 8.w, top: 8.h, bottom: 8.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  difficulty == "Easy"
                                      ? "assets/icons/easy.png"
                                      : difficulty == "Medium"
                                          ? "assets/icons/medium.png"
                                          : "assets/icons/hard.png",
                                  width: 24.w,
                                  height: 24.h,
                                  color: difficulty == "Easy"
                                      ? AppColor.primary
                                      : difficulty == "Medium"
                                          ? Colors.orange
                                          : Colors.red,
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Text(
                                  difficulty!,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                  ],
                ),
              ],
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
                            "Height:",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            "$minHeight - $maxHeight cm",
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
                            "Growth Time:",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            "$minimumGrowthTime - $maximumGrowthTime days",
                            style: TextStyle(
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
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
