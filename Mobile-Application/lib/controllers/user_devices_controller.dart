import 'package:fasila/mixins/auth_mixin.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/device.dart';
import 'dart:async';

class UserDevicesController extends GetxController with AuthMixin {
  RxList<Device> devices = <Device>[].obs;
  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  RxBool isAddingDeviceLoading = false.obs;
  RxBool isAddingDeviceError = false.obs;
  final baseUrl = dotenv.env['API_URL'];

  @override
  void onInit() {
    super.onInit();
    fetchUserDevices();
  }

  Future<void> fetchUserDevices() async {
    isLoading.value = true;
    isError.value = false;
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/user/devices/'), headers: {
        'Authorization': 'Bearer ${await getToken()}',
        'Content-Type': 'application/json'
      });
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        devices.value = await responseData
            .map((device) => Device.fromJson(device))
            .toList();
      } else {
        isError.value = true;
      }
    } catch (e) {
      isError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addDevice(int device) async {
    isAddingDeviceLoading.value = true;
    isAddingDeviceError.value = false;
    try {
      final response = await http.post(Uri.parse('$baseUrl/user/add-device/'),
          headers: {
            'Authorization': 'Bearer  ${await getToken()}',
            'Content-Type': 'application/json'
          },
          body: json.encode(
            {
              'device_id': device,
            },
          ));
      if (response.statusCode == 201) {
        final mapResponse = json.decode(response.body);
        final device = mapResponse['device'];
        devices.add(Device.fromJson(device));
      } else {
        isAddingDeviceError.value = true;
      }
      isAddingDeviceError.value = false;
      isAddingDeviceLoading.value = false;
    } catch (e) {
      isAddingDeviceError.value = true;
    } finally {
      isAddingDeviceLoading.value = false;
    }
  }

  void refreshDevices() {
    fetchUserDevices();
  }
}
