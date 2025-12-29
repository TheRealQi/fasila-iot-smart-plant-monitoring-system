import 'package:fasila/controllers/disease_view_all_controller.dart';
import 'package:fasila/views/loading_page.dart';
import 'package:fasila/views/widgets/custom_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../colors.dart';
import '../errors/error_page.dart';
import '../widgets/custom_card_diseases.dart';
import 'disease_details/diseases_details_page.dart';

class DiseasesViewAllPage extends StatelessWidget {
  DiseasesViewAllPage({super.key});

  final DiseasesController diseasesController =
      Get.put(DiseasesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: Obx(() {
        if (diseasesController.isLoading.value) {
          return LoadingPage();
        }
        if (diseasesController.isError.value) {
          return ErrorPage(onRetry: () => diseasesController.fetchDiseases());
        }
        return CustomHeader(
          headerText: 'All Diseases',
          body: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: 10.w,
              mainAxisSpacing: 10.h,
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            itemCount: diseasesController.diseasesList.length,
            itemBuilder: (context, index) {
              var disease = diseasesController.diseasesList[index];
              return CustomCardDiseases(
                img_url: disease.imageUrls.isNotEmpty
                    ? disease.imageUrls.first
                    : '',
                label_text: disease.name,
                tap: () => Get.to(() => DiseasesDetailsPage(id: disease.id)),
              );
            },
          ),
        );
      }),
    );
  }
}
