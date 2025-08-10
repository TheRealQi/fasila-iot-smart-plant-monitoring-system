import 'package:fasila/models/disease.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../mixins/auth_mixin.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DiseaseNotificationController extends GetxController with AuthMixin {
  final int notification_id;
  Rx<DiseaseSummary?> disease = Rx<DiseaseSummary?>(null);
  RxBool isLoading = false.obs;

  final String url = dotenv.env['API_URL']!;

  DiseaseNotificationController({required this.notification_id});

  @override
  void onInit() {
    getDiseaseNotification(notification_id);
    super.onInit();
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

  Future<void> getDiseaseNotification(int id) async { // Singular name for clarity
    try {
      isLoading.value = true;
      final response = await http
          .get(Uri.parse("$url/devices/notifications/$id/disease/"), headers: {
        'Authorization': 'Bearer ${await getToken()}',
        'Content-Type': 'application/json'
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody is Map<String, dynamic>) {
          disease.value = DiseaseSummary.fromJson(responseBody);
        } else if (responseBody['disease'] != null) {
          disease.value = DiseaseSummary.fromJson(responseBody['disease']);
        }
      }
    } catch (e) {
      print('Error fetching disease: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
