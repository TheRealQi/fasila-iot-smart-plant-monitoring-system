import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../controllers/device_details_controller.dart';

class ActuatorsSection extends StatelessWidget {
  const ActuatorsSection({
    super.key,
    required this.deviceDetailsController,
  });

  final DeviceDetailsController deviceDetailsController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 8.h),
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
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.table_rows,
                              color: Colors.grey, size: 24.sp),
                          SizedBox(width: 8.w),
                          Text(
                            "Top Cover Panel",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      SingleChildScrollView(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Obx(
                              () => Icon(
                                deviceDetailsController.topCover.value
                                    ? Icons.panorama_horizontal_select
                                    : Icons.panorama_horizontal,
                                color: Colors.green,
                                size: 24.sp,
                              ),
                            ),
                            SizedBox(width: 5.w),
                            Obx(
                              () => Text(
                                deviceDetailsController.topCover.value
                                    ? "Closed"
                                    : "Open",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TankCard(
                          title: "NPK Tank",
                          value: deviceDetailsController.npkWaterTank.value,
                          maxValue: 100.0,
                          color: Colors.brown,
                          timestamp: deviceDetailsController
                                  .formatTimestamp(deviceDetailsController
                                      .npkWaterTankTimestamp.value)
                                  .isNotEmpty
                              ? deviceDetailsController.formatTimestamp(
                                  deviceDetailsController.npkWaterTankTimestamp.value)
                              : "No Data",
                        ),
                        SizedBox(width: 8.w),
                        TankCard(
                          title: "Irrigation Tank",
                          value:
                              deviceDetailsController.irrigationWaterTank.value,
                          maxValue: 100.0,
                          color: Colors.blue,
                          timestamp: deviceDetailsController
                                  .formatTimestamp(deviceDetailsController
                                      .irrigationWaterTankTimestamp.value)
                                  .isNotEmpty
                              ? deviceDetailsController.formatTimestamp(
                                  deviceDetailsController.irrigationWaterTankTimestamp.value)
                              : "No Data",
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TankCard extends StatelessWidget {
  final String title;
  final double value;
  final double? maxValue;
  final Color color;
  final String timestamp;

  const TankCard({
    super.key,
    required this.title,
    required this.value,
    this.maxValue,
    required this.color,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 175.w,
      height: 215.h,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 3,
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 16.h),
                  Center(
                    child: CircularPercentIndicator(
                      radius: 50.0.sp,
                      lineWidth: 12.0.w,
                      percent: (value / (maxValue ?? 100.0)).clamp(0.0, 1.0),
                      center: Text(
                        "${value.toStringAsFixed(1)}%",
                        style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      animation: true,
                      animateFromLastPercent: true,
                      progressColor: color,
                      backgroundColor: Colors.grey[300] as Color,
                    ),
                  ),
                  Spacer(),
                  Text(
                    timestamp.isNotEmpty ? timestamp : "No Data",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
