import 'package:fasila/models/disease.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import '../mixins/auth_mixin.dart';
import '../models/plant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlantDetailsController extends GetxController with AuthMixin {
  RxBool isLoading = true.obs;
  RxBool isDiseaseLoading = false.obs;
  RxBool isError = false.obs;
  Rx<Plant?> currentPlant = Rx<Plant?>(null);
  RxList<DiseaseSummary> associatedDiseases = <DiseaseSummary>[].obs;

  final String url = dotenv.env['API_URL']!;

  @override
  void onInit() {
    super.onInit();
  }

  Future<Plant?> getPlantById(int id) async {
    try {
      isLoading.value = true;
      isError.value = false;
      final response = await http.get(Uri.parse("$url/plants/$id"), headers: {
        'Authorization': 'Bearer ${await getToken()}',
        'Content-Type': 'application/json'
      });
      if (response.statusCode == 200) {
        final plantData = json.decode(response.body);
        final plant = Plant.fromJson(plantData);
        currentPlant.value = plant;
        associatedDiseases.clear();
        _loadDiseasesInBackground(id);
        isLoading.value = false;
        return plant;
      } else {
        isError.value = true;
        isLoading.value = false;
        currentPlant.value = null;
        return null;
      }
    } catch (e) {
      isError.value = true;
      isLoading.value = false;
      currentPlant.value = null;
      return null;
    }
  }

  void _loadDiseasesInBackground(int id) async {
    isDiseaseLoading.value = true;
    try {
      final response =
          await http.get(Uri.parse("$url/plants/$id/diseases/"), headers: {
        'Authorization': 'Bearer ${await getToken()}',
        'Content-Type': 'application/json'
      });
      if (response.statusCode == 200) {
        final diseasesData = json.decode(response.body);
        final diseases = diseasesData as List;
        associatedDiseases.clear();
        diseases.forEach((disease) {
          associatedDiseases.add(DiseaseSummary.fromJson(disease));
        });
      } else {
        isDiseaseLoading.value = false;
      }
    } catch (e) {
      isDiseaseLoading.value = false;
    } finally {
      isDiseaseLoading.value = false;
    }
  }
}
