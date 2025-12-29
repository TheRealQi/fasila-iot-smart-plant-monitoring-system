import 'package:cached_network_image/cached_network_image.dart';
import 'package:fasila/colors.dart';
import 'package:fasila/controllers/plant_details_controller.dart';
import 'package:fasila/views/errors/error_page.dart';
import 'package:fasila/views/loading_page.dart';
import 'package:getwidget/getwidget.dart';
import '../../../models/plant.dart';
import './general_info_section.dart';
import 'package:fasila/views/widgets/custom_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'care_section.dart';
import 'diseases_section.dart';

class PlantDetailsPage extends StatelessWidget {
  PlantDetailsPage({super.key, required this.id});

  final PlantDetailsController controller = Get.put(PlantDetailsController());
  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: FutureBuilder<Plant?>(
        future: controller.getPlantById(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingPage();
          } else if (snapshot.hasError || snapshot.data == null) {
            return ErrorPage(onRetry: () {
              controller.getPlantById(id);
            });
          } else {
            final plant = snapshot.data!;
            final String commonName = plant.commonName;
            final String botanicalName = plant.botanicalName;
            final String type = plant.type;
            final String description = plant.description;
            final String waterConsumption = plant.waterConsumption;
            final String watering = plant.watering;
            final String difficulty = plant.difficulty;
            final int minHeight = plant.height['min'] ?? 0;
            final int maxHeight = plant.height['max'] ?? 0;
            final int minimumGrowthTime = plant.growthTime['min'] ?? 0;
            final int maximumGrowthTime = plant.growthTime['max'] ?? 0;
            final String light = plant.light;
            final String altLight = plant.alternativeLight;
            final int minimumTemperature = plant.recommendedTemperature['min'] ?? '';
            final int maximumTemperature = plant.recommendedTemperature['max'] ?? '';
            final double seedingDepth = plant.seedingDepth;
            final int minimumSeedSpacing = plant.seedSpacing['min'] ?? '';
            final int maximumSeedSpacing = plant.seedSpacing['max'] ?? '';
            final int minimumGerminationTime = plant.germinationTime['min'] ?? '';
            final int maximumGerminationTime = plant.germinationTime['max'] ?? '';
            final int minimumGermTemperature = plant.optimalGerminationTemperature['min'] ?? '';
            final int maximumGermTemperature = plant.optimalGerminationTemperature['max'] ?? '';
            final List<String> imageUrls = plant.imageUrls;


            return Scaffold(
              body: CustomHeader(
                headerText: plant.commonName,
                body: DefaultTabController(
                  length: 3,
                  child: NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverAppBar(
                          expandedHeight: 200.h,
                          floating: false,
                          pinned: false,
                          automaticallyImplyLeading: false,
                          flexibleSpace: imageUrls.length > 1
                              ? GFCarousel(
                                  height: double.infinity,
                                  viewportFraction: 1.0,
                                  aspectRatio: 16 / 9,
                                  items: imageUrls.map(
                                    (url) {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.zero,
                                        child: CachedNetworkImage(
                                          imageUrl: url,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                      );
                                    },
                                  ).toList(),
                                )
                              : CachedNetworkImage(
                                  imageUrl: imageUrls.first,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                        ),
                      ];
                    },
                    body: Column(
                      children: [
                        Container(
                          color: AppColor.appBar,
                          height: 50.h,
                          child: const TabBar(
                            tabs: [
                              Tab(text: "General Info"),
                              Tab(text: "Care"),
                              Tab(text: "Associated Diseases"),
                            ],
                            isScrollable: true,
                            tabAlignment: TabAlignment.start,
                            labelColor: AppColor.primary,
                            unselectedLabelColor: Colors.grey,
                            indicatorColor: AppColor.primary,
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              PlantGeneralInfoSection(
                                commonName: commonName,
                                botanicalName: botanicalName,
                                type: type,
                                description: description,
                                waterConsumption: waterConsumption,
                                difficulty: difficulty,
                                minHeight: minHeight,
                                maxHeight: maxHeight,
                                minimumGrowthTime: minimumGrowthTime,
                                maximumGrowthTime: maximumGrowthTime,
                                light: light,
                              ),
                              CareSection(
                                minimumTemperature: minimumTemperature,
                                maximumTemperature: maximumTemperature,
                                seedingDepth: seedingDepth,
                                minimumSeedSpacing: minimumSeedSpacing,
                                maximumSeedSpacing: maximumSeedSpacing,
                                minimumGerminationTime: minimumGerminationTime,
                                maximumGerminationTime: maximumGerminationTime,
                                minimumGermTemperature: minimumGermTemperature,
                                maximumGermTemperature: maximumGermTemperature,
                                watering: watering,
                                light: light,
                                altLight: altLight,
                              ),
                              DiseasesSection(controller: controller),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
