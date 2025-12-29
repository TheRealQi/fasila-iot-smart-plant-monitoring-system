import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../colors.dart';
import '../../../controllers/plant_details_controller.dart';
import '../disease_details/diseases_details_page.dart';

class DiseasesSection extends StatelessWidget {
  const DiseasesSection({
    super.key,
    required this.controller,
  });

  final PlantDetailsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isDiseaseLoading.value) {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColor.primary),
          ),
        );
      }
      if (controller.associatedDiseases.isEmpty) {
        return Center(
          child: Text(
            "No associated diseases found",
            style: TextStyle(fontSize: 18.sp),
          ),
        );
      }
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(16.w),
              child: Text(
                "Associated Diseases",
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.associatedDiseases.length,
                itemBuilder: (context, index) {
                  final disease = controller.associatedDiseases[index];
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(() => DiseasesDetailsPage(id: disease.id));
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            bottom: 16.h,
                            top: 16.h,
                            right: 16.w,
                            left: 16.w,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          height: 100.h,
                          width: double.infinity,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                child: CachedNetworkImage(
                                  imageUrl: disease.imageUrl,
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          Center(
                                    child: CircularProgressIndicator(
                                      value: downloadProgress.progress,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          AppColor.primary),
                                    ),
                                  ),
                                  height: 100.h,
                                  width: 100.w,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    disease.name,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(
                        height: 0,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
