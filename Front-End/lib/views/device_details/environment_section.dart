import 'package:fasila/views/device_details/sensor_history_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../controllers/device_details_controller.dart';
import '../guide/plant_details/plant_details_page.dart';

class EnvironmentSection extends StatelessWidget {
  const EnvironmentSection({
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
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SensorCard(
                            icon: CupertinoIcons.thermometer,
                            title: "Temperature",
                            value: deviceDetailsController.temperature.value,
                            maxValue: 100.0,
                            color: Colors.orangeAccent,
                            useCircularIndicator: false,
                            timestamp: deviceDetailsController.formatTimestamp(
                                deviceDetailsController
                                    .temperatureTimestamp.value)),
                        SizedBox(width: 8.w),
                        SensorCard(
                            icon: Icons.water,
                            title: "Humidity",
                            value: deviceDetailsController.humidity.value,
                            maxValue: 100.0,
                            color: Colors.cyan,
                            timestamp: deviceDetailsController.formatTimestamp(
                                deviceDetailsController
                                    .humidityTimestamp.value)),
                      ],
                    )),
                SizedBox(height: 8.h),
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SensorCard(
                            icon: Icons.light_mode,
                            title: "Light Intensity",
                            value: deviceDetailsController.lightIntensity.value,
                            maxValue: 100.0,
                            color: Colors.yellowAccent,
                            useCircularIndicator: false,
                            timestamp: deviceDetailsController.formatTimestamp(
                                deviceDetailsController
                                    .lightIntensityTimestamp.value)),
                        SizedBox(width: 8.w),
                        SensorCard(
                            icon: Icons.water_drop,
                            title: "Soil Moisture",
                            value: deviceDetailsController.moisture.value,
                            maxValue: 100.0,
                            color: Colors.blueAccent,
                            timestamp: deviceDetailsController.formatTimestamp(
                                deviceDetailsController
                                    .temperatureTimestamp.value)),
                      ],
                    )),
                SizedBox(height: 8.h),
                Container(
                  height: 215.h,
                  margin: EdgeInsets.only(right: 8.w, left: 8.w, bottom: 8.h),
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.grass, color: Colors.green, size: 24.sp),
                          SizedBox(width: 8.w),
                          Text(
                            "Soil NPK Levels",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Spacer(),
                          Obx(
                            () => Text(
                              deviceDetailsController
                                      .formatTimestamp(deviceDetailsController
                                          .npkTimestamp.value)
                                      .isNotEmpty
                                  ? deviceDetailsController.formatTimestamp(
                                      deviceDetailsController
                                          .npkTimestamp.value)
                                  : "No Data",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IntrinsicHeight(
                                child: Obx(
                              () => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  NutrientIndicator(
                                    label: "N",
                                    value: deviceDetailsController
                                            .nitrogen.value ??
                                        0,
                                    color: Colors.red,
                                  ),
                                  VerticalDivider(
                                    color: Colors.grey,
                                  ),
                                  NutrientIndicator(
                                    label: "P",
                                    value: deviceDetailsController
                                            .phosphorus.value ??
                                        0,
                                    color: Colors.blue,
                                  ),
                                  VerticalDivider(
                                    color: Colors.grey,
                                  ),
                                  NutrientIndicator(
                                    label: "K",
                                    value: deviceDetailsController
                                            .potassium.value ??
                                        0,
                                    color: Colors.orange,
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
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SensorCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final double value;
  final double? maxValue;
  final Color color;
  final bool useCircularIndicator;
  final String timestamp;

  const SensorCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.maxValue,
    required this.color,
    this.useCircularIndicator = true,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 24.sp),
                SizedBox(width: 8.w),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            Spacer(),
            if (!useCircularIndicator)
              Text(
                "${value.toStringAsFixed(1)}${title == "Temperature" ? "°C" : " lx"}",
                style: TextStyle(
                  fontSize: 20.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              )
            else
              CircularPercentIndicator(
                radius: 50.0.sp,
                lineWidth: 12.0.w,
                percent: (value / (maxValue ?? 100.0)).clamp(0.0, 1.0),
                center: Text(
                  "${value.toStringAsFixed(1)}${title == "Temperature" ? "°C" : "%"}",
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
    );
  }
}

class NutrientIndicator extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const NutrientIndicator({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Icon(Icons.circle, size: 12.sp, color: color),
            SizedBox(width: 4.w),
            Text(
              label,
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          value.toStringAsFixed(1),
          style: TextStyle(
              fontSize: 20.sp,
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ),
        Text(
          "mg/kg",
          style: TextStyle(
              fontSize: 12.sp,
              color: Colors.black,
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
