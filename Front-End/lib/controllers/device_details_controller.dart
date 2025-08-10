import 'dart:async';
import 'package:fasila/mixins/auth_mixin.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DeviceDetailsController extends GetxController with AuthMixin {
  DeviceDetailsController(this.deviceID);

  RxBool deviceconnectionStatus = false.obs;
  RxDouble temperature = 0.0.obs;
  RxString temperatureTimestamp = "".obs;
  RxDouble humidity = 0.0.obs;
  RxString humidityTimestamp = "".obs;
  RxDouble moisture = 0.0.obs;
  RxString moistureTimestamp = "".obs;
  RxDouble lightIntensity = 0.0.obs;
  RxString lightIntensityTimestamp = "".obs;
  RxDouble nitrogen = 0.0.obs;
  RxDouble phosphorus = 0.0.obs;
  RxDouble potassium = 0.0.obs;
  RxString npkTimestamp = "".obs;
  RxBool healthStatus = true.obs;
  RxDouble npkWaterTank = 0.0.obs;
  RxString npkWaterTankTimestamp = "".obs;
  RxDouble irrigationWaterTank = 0.0.obs;
  RxString irrigationWaterTankTimestamp = "".obs;
  RxBool topCover = false.obs;
  RxBool wsconnectionStatus = false.obs;
  RxBool isLoading = true.obs;
  RxBool isLoadingError = false.obs;
  RxList<dynamic> notifications = <dynamic>[].obs;
  RxList<dynamic> diseaseDetections = <dynamic>[].obs;
  RxMap<String, dynamic> diseaseRecommendedActions = <String, dynamic>{}.obs;

  final int deviceID;

  late IOWebSocketChannel channel;
  late StreamSubscription _connectionSubscription;

  String apiUrl = dotenv.env['API_URL']!;
  String wsUrl = dotenv.env['WS_URL']!;

  @override
  void onInit() {
    fetchDeviceDetails();
    fetchTodayDiseaseDetections();
    super.onInit();
  }

  @override
  void onClose() {
    _closeWebSocket();
    Get.delete<DeviceDetailsController>();
    super.onClose();
  }

  String formatTimestamp(String timestamp) {
    try {
      final DateTime dateTime = DateTime.parse(timestamp).toLocal();
      final DateFormat formatter = DateFormat('dd/MM/yy hh:mm a');
      return formatter.format(dateTime);
    } catch (e) {
      return "";
    }
  }

  Future<void> fetchDeviceDetails() async {
    try {
      isLoading(true);
      isLoadingError(false);
      final latestStatusResponse = await http
          .get(Uri.parse("$apiUrl/devices/$deviceID/latest-status/"), headers: {
        'Authorization': 'Bearer ${await getToken()}',
        'Content-Type': 'application/json'
      });
      final latestValuesResponse = await http.get(
          Uri.parse("$apiUrl/devices/$deviceID/sensors/latest/"),
          headers: {
            'Authorization': 'Bearer ${await getToken()}',
            'Content-Type': 'application/json'
          });
      if (latestStatusResponse.statusCode == 200 &&
          latestValuesResponse.statusCode == 200) {
        dynamic latestStatus =
            json.decode(latestStatusResponse.body) as Map<String, dynamic>;
        dynamic latestValues =
            json.decode(latestValuesResponse.body) as Map<String, dynamic>;
        deviceconnectionStatus.value = latestStatus['status'];
        healthStatus.value = latestStatus['healthy'];
        topCover.value = latestStatus['top_cover'];
        moisture.value =
            (latestValues['moisture']?['moisture'] ?? 0.0).toDouble();
        moistureTimestamp.value = latestValues['moisture']?['timestamp'] ?? "";
        temperature.value =
            (latestValues['temperature']?['temperature'] ?? 0.0).toDouble();
        temperatureTimestamp.value =
            latestValues['temperature']?['timestamp'] ?? "";
        humidity.value =
            (latestValues['humidity']?['humidity'] ?? 0.0).toDouble();
        humidityTimestamp.value = latestValues['humidity']?['timestamp'] ?? "";
        lightIntensity.value =
            (latestValues['light_intensity']?['light_intensity'] ?? 0.0)
                .toDouble();
        lightIntensityTimestamp.value =
            latestValues['light_intensity']?['timestamp'] ?? "";
        nitrogen.value =
            (latestValues['nutrient']?['nitrogen'] ?? 0.0).toDouble();
        phosphorus.value =
            (latestValues['nutrient']?['phosphorus'] ?? 0.0).toDouble();
        potassium.value =
            (latestValues['nutrient']?['potassium'] ?? 0.0).toDouble();
        npkTimestamp.value = latestValues['nutrient']?['timestamp'] ?? "";

        irrigationWaterTank.value =
            (latestValues['irrigation_water_tank']?['water_level'] ?? 0.0)
                .toDouble();
        irrigationWaterTankTimestamp.value =
            latestValues['irrigation_water_tank']?['timestamp'] ?? "";
        npkWaterTank.value =
            (latestValues['npk_water_tank']?['water_level'] ?? 0.0).toDouble();
        npkWaterTankTimestamp.value =
            latestValues['npk_water_tank']?['timestamp'] ?? "";
        isLoading(false);
        getNotifications();
        connectWebSocket(deviceID);
      } else {
        isLoadingError(true);
      }
    } catch (e) {
      isLoadingError(true);
    } finally {
      isLoading(false);
    }
  }

  void connectWebSocket(int deviceID) async {
    try {
      channel = IOWebSocketChannel.connect(
        Uri.parse("$wsUrl/$deviceID/data/?token=${await getToken()}"),
      );
      wsconnectionStatus.value = true;
      _connectionSubscription = channel.stream.listen((message) {
        final data = json.decode(message) as Map<String, dynamic>;
        if (data['type'] == 'device.status') {
          if (data['status'] == false || data['status'] == true) {
            deviceconnectionStatus.value = data['status'];
          }
          if (data['healthy'] != null) {
            healthStatus.value = data['healthy'];
            if (data['healthy'] == false) {
              fetchTodayDiseaseDetections();
            } else {
              diseaseDetections.value = [];
            }
          }
          if (data['top_cover'] != null) {
            topCover.value = data['top_cover'];
          }
        }
        else if (data['type'] == 'sensors.data') {
          print(data);
          data.forEach((key, value) {
            if (key == 'type' || key == 'device_id' || key == 'timestamp') {
              return;
            }
            switch (key) {
              case 'temperature':
                temperature.value = (value ?? temperature.value).toDouble();
                temperatureTimestamp.value = data['timestamp'];
                break;
              case 'humidity':
                humidity.value = (value ?? humidity.value).toDouble();
                humidityTimestamp.value = data['timestamp'];
                break;
              case 'moisture':
                moisture.value = (value ?? moisture.value).toDouble();
                moistureTimestamp.value = data['timestamp'];
                break;
              case 'light_intensity':
                lightIntensity.value =
                    (value ?? lightIntensity.value).toDouble();
                lightIntensityTimestamp.value = data['timestamp'];
                break;
              case 'nitrogen':
                nitrogen.value = (value ?? nitrogen.value).toDouble();
                npkTimestamp.value = data['timestamp'];
                print("Nitrogen: $value");
              case 'phosphorus':
                phosphorus.value = (value ?? phosphorus.value).toDouble();
                npkTimestamp.value = data['timestamp'];
                print("Phosphorus: $value");
              case 'potassium':
                potassium.value = (value ?? potassium.value).toDouble();
                npkTimestamp.value = data['timestamp'];
                print("Potassium: $value");
                print("Timestamp: ${data['timestamp']}");
                break;
            }
          });
        } else if (data['type'] == 'notification') {
          notifications.insert(0, data['notification']);
        } else if (data['type'] == 'water_tanks.data') {
          if (data['tank_type'] == 'npk') {
            npkWaterTank.value = data['water_level'].toDouble();
            npkWaterTankTimestamp.value = data['timestamp'];
          } else if (data['tank_type'] == 'irrigation') {
            irrigationWaterTank.value = data['water_level'].toDouble();
            irrigationWaterTankTimestamp.value = data['timestamp'];
          }
        }
      }, onDone: () {
        wsconnectionStatus.value = false;
        _reconnectWithDelay();
      }, onError: (error) {
        wsconnectionStatus.value = false;
        _reconnectWithDelay();
      });
    } catch (e) {
      wsconnectionStatus.value = false;
      _reconnectWithDelay();
    }
  }

  void getNotifications() async {
    try {
      final response = await http
          .get(Uri.parse("$apiUrl/devices/notifications/$deviceID/"), headers: {
        'Authorization': 'Bearer ${await getToken()}',
        'Content-Type': 'application/json'
      });
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody['success'] == true) {
          notifications.value = responseBody['notifications'];
        } else {}
      } else {}
    } catch (e) {}
  }

  void _closeWebSocket() {
    _connectionSubscription.cancel();
    channel.sink.close();
  }

  void _reconnectWithDelay() async {
    await Future.delayed(Duration(seconds: 10));
    if (!wsconnectionStatus.value) {
      connectWebSocket(deviceID);
    }
  }

  Future fetchTodayDiseaseDetections() async {
    try {
      final response = await http.get(
        Uri.parse("$apiUrl/devices/$deviceID/disease-detections/"),
        headers: {
          'Authorization': 'Bearer ${await getToken()}',
          'Content-Type': 'application/json'
        },
      );
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody['success'] == true) {
          final List<dynamic> currentDetections = [...diseaseDetections]; // Create a new list
          final newDetections = responseBody['detections'];

          if (newDetections is List) {
            for (var newDetection in newDetections) {
              bool exists = currentDetections.any((existingDetection) =>
              existingDetection['disease_id'] == newDetection['disease_id']);
              if (!exists) {
                currentDetections.insert(0, newDetection);
              }
            }
            diseaseDetections.value = [...currentDetections]; // Assign a new list reference
            await fetchRecommendedActions();
          }
        }
      }
    } catch (e) {
      print("Error fetching disease detections: $e");
    }
  }


  Future<void> fetchRecommendedActions() async {
    try {
      print("Fetching recommended actions");
      final specificDiseaseIds = [2, 11, 12];
      final detectedDiseaseIds =
      diseaseDetections.map((d) => d['disease_id']).toList();
      final matchedIds = specificDiseaseIds
          .where((id) => detectedDiseaseIds.contains(id))
          .toList();

      int targetDiseaseId;
      if (matchedIds.isNotEmpty) {
        print("Fetching recommended actions for specific diseases");
        targetDiseaseId = matchedIds[0];
      } else if (diseaseDetections.value.isNotEmpty) {
        targetDiseaseId = diseaseDetections.value[0]['disease_id'];
      } else {
        print("No diseases to fetch recommendations for");
        return;
      }

      final response = await http.get(
        Uri.parse("$apiUrl/diseases/$targetDiseaseId/recommended-actions/"),
        headers: {
          'Authorization': 'Bearer ${await getToken()}',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final recommendedActions = responseData['recommended_actions'];

        if (recommendedActions != null && recommendedActions is List && recommendedActions.isNotEmpty) {
          // Store the first recommended action as our map
          diseaseRecommendedActions.value = {
            'id': recommendedActions[0]['id'],
            'disease_id': targetDiseaseId,
            'actions': recommendedActions[0]['actions'] ?? [],
            'recommended_chemical_medicine': recommendedActions[0]['recommended_chemical_medicine'] ?? {
              'id': 0,
              'name': '',
              'type': '',
              'active_ingredients': '',
              'preparation_methods': '',
              'application_methods': []
            }
          };
          print("Updated recommended actions: ${diseaseRecommendedActions.value}");
        } else {
          print("No recommended actions found in response");
          diseaseRecommendedActions.clear();
        }
      } else if (response.statusCode == 404) {
        print("No recommended actions found for disease");
        diseaseRecommendedActions.clear();
      } else {
        print("Error fetching recommended actions: ${response.statusCode}");
        final errorData = json.decode(response.body);
        print("Error details: ${errorData['error']}");
        diseaseRecommendedActions.clear();
      }
    } catch (e) {
      print("Error fetching recommended actions: $e");
      diseaseRecommendedActions.clear();
    }
  }
}
