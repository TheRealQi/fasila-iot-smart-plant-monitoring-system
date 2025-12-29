import 'package:fasila/views/guide/plant_details/plant_details_page.dart';
import 'package:fasila/views/widgets/custom_card_plants.dart';
import 'package:fasila/views/widgets/custom_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../colors.dart';
import '../../controllers/plants_view_all_controller.dart';
import '../errors/error_page.dart';
import '../loading_page.dart';

class PlantsViewAllPage extends StatelessWidget {
  PlantsViewAllPage({super.key});

  final PlantsController plantsController = Get.put(PlantsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: Obx(() {
        if (plantsController.isLoading.value) {
          return LoadingPage();
        }
        if (plantsController.isError.value) {
          return ErrorPage(onRetry: () => plantsController.fetchPlants());
        }
        return CustomHeader(
            headerText: 'All Plants',
            body: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.808,
                crossAxisSpacing: 10.w,
                mainAxisSpacing: 10.h,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              itemCount: plantsController.plantList.length,
              itemBuilder: (context, index) {
                var plant = plantsController.plantList[index];
                return CustomCardPlants(
                  label_text: plant.commonName,
                  img_url: plant.imageUrls[0],
                  tap: () {
                    Get.to(() => PlantDetailsPage(id: plant.id));
                  },
                  sunlight: plant.light,
                  difficulty: plant.difficulty,
                );
              },
            ));
      }),
    );
  }
}
