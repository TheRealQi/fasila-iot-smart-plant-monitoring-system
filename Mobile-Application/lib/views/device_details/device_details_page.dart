import 'package:fasila/views/device_details/environment_section.dart';
import 'package:fasila/views/device_details/plant_health_section.dart';
import 'package:fasila/views/errors/error_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../colors.dart';
import '../../controllers/device_details_controller.dart';
import '../loading_page.dart';
import '../widgets/custom_icon_button.dart';
import 'actuators_section.dart';
import 'notifications_page.dart';

class DeviceDetailsPage extends StatelessWidget {
  const DeviceDetailsPage({super.key, required this.deviceID});

  final int deviceID;

  @override
  Widget build(BuildContext context) {
    final DeviceDetailsController deviceDetailsController =
        Get.put(DeviceDetailsController(deviceID));
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Container(
          color: AppColor.background,
          child: Obx(() {
            if (deviceDetailsController.isLoading.value) {
              return LoadingPage();
            }
            if (deviceDetailsController.isLoadingError.value) {
              return ErrorPage(
                onRetry: () => deviceDetailsController.fetchDeviceDetails(),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 100.h,
                  color: AppColor.appBar,
                  padding: EdgeInsets.only(
                    left: 16.w,
                    right: 16.w,
                    top: MediaQuery.of(context).padding.top,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomIconButton(
                            tapAction: () {
                              if (Get.isRegistered<DeviceDetailsController>()) {
                                Get.delete<DeviceDetailsController>();
                              }
                              Get.back();
                            },
                            icon: Icons.arrow_back,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Obx(
                                  () => Icon(
                                    Icons.cloud,
                                    color: deviceDetailsController
                                            .deviceconnectionStatus.value
                                        ? Colors.green
                                        : Colors.red,
                                    size: 24.sp,
                                  ),
                                ),
                                SizedBox(width: 5.w),
                                Text(
                                  "Plant Pot 1",
                                  style: TextStyle(
                                    color: AppColor.text,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CustomIconButton(
                            tapAction: () => Get.to(() =>
                                DeviceNotificationsPage(
                                    deviceDetailsController:
                                        deviceDetailsController)),
                            icon: Icons.notifications_outlined,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  color: AppColor.appBar,
                  height: 50.h,
                  child: TabBar(
                    labelColor: AppColor.primary,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: AppColor.primary,
                    tabAlignment: TabAlignment.start,
                    isScrollable: true,
                    tabs: [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.health_and_safety, size: 24.sp),
                            SizedBox(
                              width: 8.w,
                            ),
                            Text("Plant Health"),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.grass, size: 24.sp),
                            SizedBox(
                              width: 8.w,
                            ),
                            Text("Environment"),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.propane_tank, size: 24.sp),
                            SizedBox(
                              width: 8.w,
                            ),
                            Text("Tank & Cover Status"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // TabBarView Section
                Expanded(
                  child: TabBarView(
                    children: [
                      PlantHealthSection(
                        deviceDetailsController: deviceDetailsController,
                      ),
                      EnvironmentSection(
                        deviceDetailsController: deviceDetailsController,
                      ),
                      ActuatorsSection(
                        deviceDetailsController: deviceDetailsController,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
