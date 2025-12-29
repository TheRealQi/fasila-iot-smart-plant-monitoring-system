import 'package:fasila/controllers/authentication_controller.dart';
import 'package:fasila/views/widgets/custom_card_pots.dart';
import 'package:fasila/views/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../colors.dart';
import '../controllers/user_devices_controller.dart';
import 'device_details/device_details_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final UserDevicesController deviceController =
      Get.put(UserDevicesController());
  final AuthenticationController authController =
      Get.find<AuthenticationController>();
  final double appBarHeight = 100.0.h;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: appBarHeight,
            width: double.infinity,
            color: Colors.transparent,
            padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 10.h),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/icons/plant_pot.png",
                        width: 40.w,
                        height: 40.h,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Home',
                        style: TextStyle(
                          color: AppColor.text,
                          fontSize: 24.0.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      CustomIconButton(
                        tapAction: () {
                          deviceController.addDevice(1);
                        },
                        icon: Icons.add,
                        iconColor: AppColor.primary,
                      ),
                      SizedBox(width: 8.w),
                      CustomIconButton(
                        tapAction: () {
                          authController.logout();
                        },
                        icon: Icons.exit_to_app,
                        bgColor: Colors.red.withOpacity(0.1),
                        iconColor: Colors.red,
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Plant Pots',
                    style: TextStyle(
                      color: AppColor.text,
                      fontSize: 16.0.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Obx(() {
                    if (deviceController.isLoading.value) {
                      return Expanded(
                        child: Center(
                            child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppColor.primary),
                        )),
                      );
                    }
                    if (deviceController.isError.value) {
                      return Expanded(
                        child: Center(
                          child: SizedBox(
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
                                Text(
                                  'Something Went Wrong!',
                                  style: TextStyle(
                                    color: AppColor.text,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Please try again.',
                                  style: TextStyle(
                                    color: AppColor.text,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      deviceController.fetchUserDevices(),
                                  style: TextButton.styleFrom(
                                    side: BorderSide(color: AppColor.primary),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(8.0.r),
                                    ),
                                    minimumSize: Size(70.w, 40.h),
                                    maximumSize: Size(100.w, 40.h),
                                  ),
                                  child: Text('Try Again',
                                      style: TextStyle(
                                        color: AppColor.primary,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    return Expanded(child: Obx(() {
                      return deviceController.devices.isEmpty
                          ? Center(child: Text('No devices found'))
                          : GridView.builder(
                              padding: EdgeInsets.only(top: 10.h),
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16.w,
                                mainAxisSpacing: 16.h,
                                childAspectRatio: (175.w / 110.h),
                              ),
                              itemCount: deviceController.devices.length,
                              itemBuilder: (context, index) {
                                final device = deviceController.devices[index];
                                return CustomCardPots(
                                  labelText:
                                      "Plant Pot ${device.device_id.value}",
                                  tap: () {
                                    Get.to(() => DeviceDetailsPage(
                                        deviceID: device.device_id.value));
                                  },
                                );
                              },
                            );
                    }));
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
