import 'package:cached_network_image/cached_network_image.dart';
import 'package:fasila/controllers/disease_notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../colors.dart';
import '../guide/disease_details/diseases_details_page.dart';
import '../widgets/custom_header.dart';

class DiseaseNotificationPage extends StatelessWidget {
  DiseaseNotificationPage({
    super.key,
    required this.notification,
  }) : controller = Get.put(DiseaseNotificationController(notification_id: notification['id']));

  final Map<String, dynamic> notification;
  final DiseaseNotificationController controller;

  @override
  Widget build(BuildContext context) {
    final title = notification['title'] ?? 'Notification';
    final imageUrl = notification['disease_details']['disease_image_url'] ?? '';
    final timestamp = notification['timestamp'] ?? '';

    return CustomHeader(
      headerText: title,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageUrl.isNotEmpty)
                Center(
                  child: Container(
                    height: 250.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      image: DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Text(
                    'Detected Disease:',
                    style: TextStyle(
                      color: AppColor.text,
                      fontSize: 16.0.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Spacer(),
                  Text(
                    controller.formatTimestamp(timestamp),
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColor.primary),
                    ),
                  );
                }
                final disease = controller.disease.value;
                if (disease == null) {
                  return Center(
                    child: Text('No disease information available'),
                  );
                }
                return GestureDetector(
                  onTap: () {
                    Get.to(() => DiseasesDetailsPage(id: disease.id));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Card(
                      margin: EdgeInsets.zero,
                      elevation: 0,
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (disease.imageUrl != null)
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: CachedNetworkImage(
                                    imageUrl: disease.imageUrl!,
                                    width: 100.w,
                                    height: 100.h,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Center(
                                child: Text(
                                  disease.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                    color: AppColor.text,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }
}
