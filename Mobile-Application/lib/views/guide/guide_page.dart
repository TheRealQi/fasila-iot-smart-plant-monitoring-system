import 'package:fasila/controllers/guide_controller.dart';
import 'package:fasila/views/guide/plant_details/plant_details_page.dart';
import 'package:fasila/views/guide/plants_view_all_page.dart';
import 'package:fasila/views/widgets/custom_card_plants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../colors.dart';
import '../widgets/custom_card_diseases.dart';
import '../widgets/guide_header.dart';
import 'disease_details/diseases_details_page.dart';
import 'diseases_view_all_page.dart';

class GuidePage extends StatelessWidget {
  GuidePage({super.key});

  final GuideController guideController = Get.put(GuideController());

  @override
  Widget build(BuildContext context) {
    return GuideHeader(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      right: 16.w, left: 16.w, top: 16.h, bottom: 16.h),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Plants',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColor.text,
                          ),
                        ),
                        InkWell(
                          onTap: () => Get.to(() => PlantsViewAllPage()),
                          child: Text(
                            'View All',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColor.primary,
                            ),
                          ),
                        ),
                      ]),
                ),
                Obx((){
                  if (guideController.isPlantsLoading.value) {
                    return SizedBox(
                      height: 200.h,
                      child: Center(child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColor.primary),
                      )),
                    );
                  }
                  if (guideController.isPlantsError.value) {
                    return SizedBox(
                      height: 200.h,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/error.png',
                            width: 75.w,
                            height: 75.h,
                          ),
                          Text('Something Went Wrong!',
                            style: TextStyle(
                              color: AppColor.text,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text('Please try again.',
                            style: TextStyle(
                              color: AppColor.text,
                              fontSize: 14.sp,
                            ),
                          ),
                          TextButton(
                            onPressed: () => guideController.fetch2Plants(),
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
                                )
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: guideController.randomPlants.map((plant) {
                      int index = guideController.randomPlants.indexOf(plant);
                      return Row(
                        children: [
                          CustomCardPlants(
                            img_url: plant.imageUrls[0],
                            label_text: plant.commonName,
                            tap: () => {
                              Get.to(() => PlantDetailsPage(id: plant.id)),
                            },
                            sunlight: plant.light,
                            difficulty: plant.difficulty,
                          ),
                          if (index != guideController.randomPlants.length - 1)
                            SizedBox(width: 10.0.w),
                        ],
                      );
                    }).toList(),
                  );
                }),
              ],
            ),
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      right: 16.w, left: 16.w, top: 16.h, bottom: 16.h),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Diseases',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColor.text,
                          ),
                        ),
                        InkWell(
                          onTap: () => Get.to(() => DiseasesViewAllPage()),
                          child: Text(
                            'View All',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColor.primary,
                            ),
                          ),
                        ),
                      ]),
                ),
                Obx((){
                  if (guideController.isDiseasesLoading.value) {
                    return SizedBox(
                      height: 200.h,
                      child: Center(child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColor.primary),
                      )),
                    );
                  }
                  if (guideController.isDiseasesError.value) {
                    return SizedBox(
                      height: 200.h,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/error.png',
                            width: 75.w,
                            height: 75.h,
                          ),
                          Text('Something Went Wrong!',
                            style: TextStyle(
                              color: AppColor.text,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text('Please try again.',
                            style: TextStyle(
                              color: AppColor.text,
                              fontSize: 14.sp,
                            ),
                          ),
                          TextButton(
                            onPressed: () => guideController.fetch2Diseases(),
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
                                )
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: guideController.randomDiseases.map((disease) {
                      int index = guideController.randomDiseases.indexOf(disease);
                      return Row(
                        children: [
                          CustomCardDiseases(
                            img_url: disease.imageUrls[0],
                            label_text: disease.name,
                            tap: () => {
                              Get.to(() => DiseasesDetailsPage(id: disease.id)),
                            }
                          ),
                          if (index != guideController.randomPlants.length - 1)
                            SizedBox(width: 10.0.w),
                        ],
                      );
                    }).toList(),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}