import 'package:fasila/controllers/disease_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../../colors.dart';
import '../../../models/chemicalcontrol.dart';

class TreatmentsSection extends StatelessWidget {
  const TreatmentsSection({
    super.key,
    required this.cultural,
    required this.controller,
  });

  final List<String> cultural;
  final DiseaseDetailsController controller;

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
                "Treatments",
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColor.text,
                ),
              ),
            ),
            _buildTreatmentSection("Cultural Control", cultural),
            _buildChemicalControlSection(),
          ]),
    );
  }

  Widget _buildTreatmentSection(String title, List<String> controls) {
    return controls.isNotEmpty
        ? Container(
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
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.text,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    ...controls.map((control) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        child: Text(
                          "\u2022 $control",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColor.text,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          )
        : SizedBox();
  }

  Widget _buildChemicalControlSection() {
    return Container(
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
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Chemical Control",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColor.text,
                ),
              ),
              SizedBox(height: 10.h),
              Obx(() {
                if (controller.isChemicalsLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColor.primary),
                    ),
                  );
                }
                if (controller.chemicals.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: Text(
                      "No chemical control methods available.",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColor.text,
                      ),
                    ),
                  );
                }
                return Column(
                  children: [
                    Container(
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
                                'Warning',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            "Select and apply only one chemical control method at a time.",
                            style: TextStyle(
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    ...controller.chemicals.value
                        .map((chemical) => _buildChemicalTile(chemical)),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChemicalTile(Chemical chemical) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Theme(
        data: ThemeData(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        child: ExpansionTile(
          leading: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.local_drink_outlined,
              // Replace with spray icon if available
              color: Colors.grey[600],
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chemical.type,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                chemical.name,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColor.text,
                ),
              ),
            ],
          ),
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Active Ingredients",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.text,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    chemical.activeIngredients,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColor.text,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Application Methods",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColor.text,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  ...chemical.applicationMethods.map((method) => Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "• ",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColor.text,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                method,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColor.text,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
