import 'package:fasila/views/widgets/custom_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/device_details_controller.dart';
import '../../../colors.dart';
import 'disease_notification_page.dart';

class DeviceNotificationsPage extends StatelessWidget {
  const DeviceNotificationsPage(
      {super.key, required this.deviceDetailsController});

  final DeviceDetailsController deviceDetailsController;

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      headerText: "Device Notifications",
      body: Obx(() {
        final notifications = deviceDetailsController.notifications;
        return notifications.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications_off_outlined,
                        size: 80.sp, color: Colors.grey[400]),
                    SizedBox(height: 16.h),
                    Text(
                      "No notifications",
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return _buildNotificationCard(context, notification);
                },
              );
      }),
    );
  }

  Widget _buildNotificationCard(
      BuildContext context, Map<String, dynamic> notification) {
    Color severityIconColor;
    if (notification['severity'].toLowerCase() == 'critical') {
      severityIconColor = Colors.red;
    } else if (notification['severity'].toLowerCase() == 'high') {
      severityIconColor = Colors.orange;
    } else if (notification['severity'].toLowerCase() == 'medium') {
      severityIconColor = Colors.yellow;
    } else {
      severityIconColor = Colors.green;
    }

    String icon;
    Color iconColor;
    print(notification['notification_type']);
    if (notification['notification_type'].toLowerCase() == 'sensor') {
      if (notification['sensor_details']['sensor_type'].toLowerCase() ==
          'temperature') {
        icon = "assets/icons/temperature.png";
        iconColor = Colors.orange;
      } else if (notification['sensor_details']['sensor_type'].toLowerCase() ==
          'humidity') {
        icon = "assets/icons/humidity.png";
        iconColor = Colors.cyan;
      } else if (notification['sensor_details']['sensor_type'].toLowerCase() ==
          'moisture') {
        icon = "assets/icons/water_drop.png";
        iconColor = Colors.blue;
      } else if (notification['sensor_details']['sensor_type'].toLowerCase() ==
          'light') {
        icon = "assets/icons/sun.png";
        iconColor = Colors.yellow;
      } else if (notification['sensor_details']['sensor_type'].toLowerCase() ==
          'npk') {
        icon = "assets/icons/npk.png";
        iconColor = Colors.green;
      } else {
        icon = "assets/icons/bell.png";
        iconColor = Colors.grey;
      }
    }
    else if (notification['notification_type'].toLowerCase() == 'disease') {
      icon = "assets/icons/virus.png";
      iconColor = Colors.green;
    }
    else if (notification['notification_type'].toLowerCase() == 'water_tank') {
      icon = "assets/icons/water_tank.png";
      iconColor = Colors.blue;
    }
    else {
      icon = "assets/icons/bell.png";
      iconColor = Colors.grey;
    }
    return GestureDetector(
      onTap: () {
        if (notification['notification_type'].toLowerCase() == 'disease') {
          Get.to(() => DiseaseNotificationPage(
                notification: notification,
              ));
        }
        // else {
        //   Get.to(() => NotificationDetailsPage(
        //         notification: notification,
        //       ));
        // }
      },
      child: Container(
        margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 12.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 50.w,
                  height: 50.h,
                  child: Center(
                    child: ImageIcon(
                      AssetImage(icon),
                      color: iconColor,
                      size: 24.sp,
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        notification['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                          color: AppColor.text,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        notification['message'],
                        style: TextStyle(
                          color: AppColor.text,
                          fontSize: 14.sp,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            deviceDetailsController
                                .formatTimestamp(notification['timestamp']),
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12.sp,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: severityIconColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              notification['severity'] ?? 'Low',
                              style: TextStyle(
                                color: severityIconColor,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
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
  }
}
