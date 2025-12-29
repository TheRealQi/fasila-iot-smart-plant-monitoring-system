import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../colors.dart';
import '../../controllers/device_details_controller.dart';
import '../../models/chemicalcontrol.dart';
import '../guide/disease_details/diseases_details_page.dart';
import '../widgets/custom_card_diseases.dart';

class PlantHealthSection extends GetView<DeviceDetailsController> {
  const PlantHealthSection({super.key, required this.deviceDetailsController});

  final DeviceDetailsController deviceDetailsController;

  @override
  Widget build(BuildContext context) {
    ever(
        deviceDetailsController.diseaseDetections, (_) => Get.forceAppUpdate());
    ever(deviceDetailsController.healthStatus, (_) => Get.forceAppUpdate());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: 8.h),
                // Health Status Card
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.health_and_safety,
                              color: Colors.green, size: 24.sp),
                          SizedBox(width: 8.w),
                          Text(
                            "Plant Health Status",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Obx(
                        () => Row(
                          children: [
                            Icon(
                              deviceDetailsController.healthStatus.value
                                  ? Icons.check_circle
                                  : Icons.error,
                              color: deviceDetailsController.healthStatus.value
                                  ? Colors.green
                                  : Colors.red,
                              size: 24.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              deviceDetailsController.healthStatus.value
                                  ? "Healthy"
                                  : "Unhealthy",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color:
                                    deviceDetailsController.healthStatus.value
                                        ? Colors.green
                                        : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      // Disease Detection Section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Diseases Detected",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Obx(
                                () => deviceDetailsController.healthStatus.value
                                    ? SizedBox()
                                    : TextButton(
                                        onPressed: () {
                                          deviceDetailsController
                                              .fetchTodayDiseaseDetections();
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            backgroundColor: Colors.white,
                                            builder: (BuildContext context) {
                                              return SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.5,
                                                child: Obx(() {
                                                  final diseaseDetections =
                                                      deviceDetailsController
                                                          .diseaseDetections;

                                                  return diseaseDetections
                                                          .isNotEmpty
                                                      ? PageView.builder(
                                                          itemCount:
                                                              diseaseDetections
                                                                  .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            final detection =
                                                                diseaseDetections[
                                                                    index];
                                                            return Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SizedBox(
                                                                    height:
                                                                        16.h),
                                                                Text(
                                                                  detection[
                                                                      'disease_name'],
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        20.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    height:
                                                                        16.h),
                                                                Expanded(
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.r),
                                                                    ),
                                                                    padding: EdgeInsets
                                                                        .all(16
                                                                            .w),
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.r),
                                                                      child:
                                                                          CachedNetworkImage(
                                                                        imageUrl:
                                                                            detection['disease_image_url'],
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        )
                                                      : Center(
                                                          child: Text(
                                                            'No images available',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize:
                                                                    16.sp),
                                                          ),
                                                        );
                                                }),
                                              );
                                            },
                                          );
                                        },
                                        child: Text(
                                          "View Images",
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          SizedBox(
                            height: 175.h,
                            child: Obx(() {
                              final healthStatus =
                                  deviceDetailsController.healthStatus.value;
                              final diseaseDetections =
                                  deviceDetailsController.diseaseDetections;

                              if (healthStatus) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.check_circle_outline,
                                        color: Colors.green,
                                        size: 32.sp,
                                      ),
                                      SizedBox(height: 8.h),
                                      Text(
                                        'No diseases detected',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: diseaseDetections.length,
                                  itemBuilder: (context, index) {
                                    final detection = diseaseDetections[index];
                                    return Padding(
                                      padding: EdgeInsets.only(right: 16.w),
                                      child: CustomCardDiseases(
                                        img_url: detection['disease_image_url'],
                                        tap: () {
                                          Get.to(() => DiseasesDetailsPage(
                                              id: detection['disease_id']));
                                        },
                                        label_text: detection['disease_name'],
                                      ),
                                    );
                                  },
                                );
                              }
                            }),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                // Recommended Actions Section
                Obx(
                  () => !deviceDetailsController.healthStatus.value
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 16.h),
                          child: Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: Colors.orange[50],
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.warning_amber_rounded,
                                        color: Colors.orange),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'Recommended Actions',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16.h),
                                // Actions List
                                Obx(() {
                                  final actions = deviceDetailsController
                                      .diseaseRecommendedActions['actions'];
                                  if (actions != null && actions.isNotEmpty) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Required Steps:',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 8.h),
                                        ...List.generate(
                                          actions.length,
                                          (index) => Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 8.h),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${index + 1}. ',
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: Colors.grey[800],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    actions[index],
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      color: Colors.grey[800],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                  return SizedBox();
                                }),
                                SizedBox(height: 16.h),
                                // Chemical Treatment Section
                                Obx(() {
                                  final chemical = deviceDetailsController.diseaseRecommendedActions['recommended_chemical_medicine'];
                                  if (chemical != null) {
                                    // Check if chemical id is 0
                                    if (chemical['id'] == 0) {
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Recommended Chemical Treatment:',
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(height: 8.h),
                                          Center(
                                            child: Container(
                                              padding: EdgeInsets.all(12.w),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(8.r),
                                                border: Border.all(
                                                  color: Colors.orange.shade200,
                                                ),
                                              ),
                                              child: Text(
                                                'No chemical treatments recommended',
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Recommended Chemical Treatment:',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 8.h),
                                        Center(
                                          child: Container(
                                            padding: EdgeInsets.all(12.w),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(8.r),
                                              border: Border.all(
                                                color: Colors.orange.shade200,
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.science_outlined,
                                                      color: Colors.orange,
                                                      size: 20.sp,
                                                    ),
                                                    SizedBox(width: 8.w),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            chemical['name'] ?? '',
                                                            style: TextStyle(
                                                              fontSize: 14.sp,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                          Text(
                                                            chemical['type'] ?? '',
                                                            style: TextStyle(
                                                              fontSize: 12.sp,
                                                              color: Colors.grey[600],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                if (chemical['active_ingredients'] != null) ...[
                                                  SizedBox(height: 12.h),
                                                  Text(
                                                    'Active Ingredients:',
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4.h),
                                                  Text(
                                                    chemical['active_ingredients'],
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: Colors.grey[800],
                                                    ),
                                                  ),
                                                ],
                                                if (chemical['application_methods'] != null &&
                                                    chemical['application_methods'].isNotEmpty) ...[
                                                  SizedBox(height: 12.h),
                                                  Text(
                                                    'Application Methods:',
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4.h),
                                                  ...List.generate(
                                                    chemical['application_methods'].length,
                                                        (index) => Padding(
                                                      padding: EdgeInsets.only(bottom: 4.h),
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            '• ',
                                                            style: TextStyle(
                                                              fontSize: 12.sp,
                                                              color: Colors.grey[800],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              chemical['application_methods'][index],
                                                              style: TextStyle(
                                                                fontSize: 12.sp,
                                                                color: Colors.grey[800],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                                if (chemical['preparation_methods'] != null &&
                                                    chemical['preparation_methods'].isNotEmpty) ...[
                                                  SizedBox(height: 12.h),
                                                  Text(
                                                    'Preparation Instructions:',
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4.h),
                                                  Text(
                                                    chemical['preparation_methods'],
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: Colors.grey[800],
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                  return SizedBox();
                                }),
                              ],
                            ),
                          ),
                        )
                      : SizedBox(height: 0.h),
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
