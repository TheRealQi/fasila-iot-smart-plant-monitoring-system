import 'package:fasila/controllers/connectivity_controller.dart';
import 'package:fasila/mixins/auth_mixin.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import '../models/plant.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PlantsController extends GetxController with AuthMixin {
  var plantList = <Plant>[].obs;
  RxBool isError = false.obs;
  RxBool isLoading = true.obs;

  final ConnectivityController connectivityController = Get.find();

  final String url = "${dotenv.env['API_URL']!}/plants/";

  @override
  void onInit() {
    super.onInit();
    fetchPlants();
  }

  Future<void> fetchPlants() async {
    try {
      isLoading(true);
      isError(false);
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer ${await getToken()}',
        'Content-Type': 'application/json'
      });
      if (response.statusCode == 200) {
        List<dynamic> diseases = json.decode(response.body);
        plantList.value = diseases.map((e) => Plant.fromJson(e)).toList();
        if (plantList.isEmpty) {
          isError(true);
        }
      } else {
        isError(true);
      }
    } catch (e) {
      isError(true);
    } finally {
      isLoading(false);
    }
  }
}
