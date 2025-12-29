import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';

class Device {
  RxInt device_id;
  RxBool status;
  RxInt unreadNotifications;
  RxBool healthy;
  RxBool top_cover;
  IOWebSocketChannel? channel;

  Device({
    required int device_id,
    required bool status,
    required int unreadNotifications,
    required bool healthy,
    required bool top_cover,
  })  : device_id = device_id.obs,
        status = status.obs,
        healthy = healthy.obs,
        top_cover = top_cover.obs,
        unreadNotifications = unreadNotifications.obs;

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      device_id: json['device_id'] ?? 0,
      status: json['status'] ?? false,
      unreadNotifications: json['unread_notifications'] ?? 0,
      healthy: json['healthy'] ?? false,
      top_cover: json['top_cover'] ?? false,
    );
  }
}
