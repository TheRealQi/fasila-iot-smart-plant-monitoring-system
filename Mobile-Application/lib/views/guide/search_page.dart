import 'package:cached_network_image/cached_network_image.dart';
import 'package:fasila/views/guide/disease_details/diseases_details_page.dart';
import 'package:fasila/views/guide/plant_details/plant_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../colors.dart';
import '../../controllers/search_controller.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({
    super.key,
    required this.searchController,
  });

  final SearchController1 searchController;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(children: [
        Container(
          color: AppColor.appBar,
          height: 50.h,
          child: const TabBar(
            labelColor: AppColor.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColor.primary,
            tabs: [
              Tab(text: 'Plants'),
              Tab(text: 'Diseases'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            children: [
              Obx(() {
                if (searchController.plantResults.isEmpty) {
                  return const Center(
                    child: Text(
                      'No plants found.',
                      style: TextStyle(color: AppColor.text),
                    ),
                  );
                }
                print(searchController.plantResults[0].commonName);
                return MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: ListView.builder(
                    itemCount: searchController.plantResults.length,
                    itemBuilder: (context, index) {
                      final plant = searchController.plantResults[index];
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(() => PlantDetailsPage(id: plant.id));
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
                                      imageUrl: searchController
                                          .plantResults[index].imageUrls[0],
                                      progressIndicatorBuilder:
                                          (context, url, downloadProgress) =>
                                          Center(
                                            child: CircularProgressIndicator(
                                              value: downloadProgress.progress,
                                              valueColor:
                                              AlwaysStoppedAnimation<Color>(
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
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        searchController
                                            .plantResults[index].commonName,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      Text(searchController
                                          .plantResults[index].botanicalName),
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
                );
              }),
              Obx(() {
                if (searchController.diseaseResults.isEmpty) {
                  return const Center(
                    child: Text(
                      'No diseases found.',
                      style: TextStyle(color: AppColor.text),
                    ),
                  );
                }
                return MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: ListView.builder(
                    itemCount: searchController.diseaseResults.length,
                    itemBuilder: (context, index) {
                      final disease = searchController.diseaseResults[index];
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
                                      imageUrl: searchController
                                          .diseaseResults[index].imageUrls[0],
                                      progressIndicatorBuilder:
                                          (context, url, downloadProgress) =>
                                          Center(
                                            child: CircularProgressIndicator(
                                              value: downloadProgress.progress,
                                              valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  AppColor.primary),
                                            ),
                                          ),
                                      height: 100.h,
                                      width: 100.w,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Center(
                                    child: Text(
                                      searchController
                                          .diseaseResults[index].name,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
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
                );
              }),
            ],
          ),
        )
      ]),
    );
  }
}
