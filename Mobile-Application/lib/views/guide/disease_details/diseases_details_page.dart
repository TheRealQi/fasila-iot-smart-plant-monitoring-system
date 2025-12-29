import 'package:cached_network_image/cached_network_image.dart';
import 'package:fasila/colors.dart';
import 'package:fasila/views/guide/disease_details/prevention_section.dart';
import 'package:fasila/views/guide/disease_details/treatments_section.dart';
import 'package:fasila/views/loading_page.dart';
import 'package:fasila/views/widgets/custom_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/carousel/gf_carousel.dart';
import '../../../controllers/disease_details_controller.dart';
import '../../../models/chemicalcontrol.dart';
import '../../../models/disease.dart';
import './general_info_section.dart';

class DiseasesDetailsPage extends StatelessWidget {
  DiseasesDetailsPage({super.key, required this.id});

  final DiseaseDetailsController controller = Get.put(DiseaseDetailsController());
  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: FutureBuilder<Disease?>(
          future: controller.getDiseaseById(id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingPage();
            }
            if (snapshot.hasError || snapshot.data == null) {
              return const Scaffold(
                body: Center(
                  child: Text('Disease not found or an error occurred'),
                ),
              );
            }
            final disease = snapshot.data!;
            final String name = disease.name;
            final String description = disease.description;
            final List<String> symptoms = disease.symptoms;
            final List<String> cultural = disease.culturalControl;
            final List<Chemical> chemicals;
            final List<String> preventions = disease.prevention;
            return Scaffold(
              body: CustomHeader(
                headerText: disease.name,
                body: DefaultTabController(
                  length: 3,
                  child: NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      final List<String> imageList = disease.imageUrls;
                      return <Widget>[
                        SliverAppBar(
                          expandedHeight: 200.h,
                          floating: false,
                          pinned: false,
                          automaticallyImplyLeading: false,
                          flexibleSpace: GFCarousel(
                            height: double.infinity,
                            viewportFraction: 1.0,
                            aspectRatio: 16 / 9,
                            items: imageList.map(
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
                              Tab(text: "Treatments"),
                              Tab(text: "Prevention"),
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
                              DiseaseGeneralInfoSection(
                                name: name,
                                description: description,
                                symptoms: symptoms,
                              ),
                              TreatmentsSection(
                                cultural: cultural,
                                controller: controller,
                              ),
                              PreventionSection(
                                  preventions: preventions
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}