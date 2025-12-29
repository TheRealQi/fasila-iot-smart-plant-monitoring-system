import 'package:get/get.dart';
import '../mixins/auth_mixin.dart';
import '../models/chemicalcontrol.dart';
import '../models/disease.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DiseaseDetailsController extends GetxController with AuthMixin {
  RxBool isLoading = true.obs;
  RxBool isChemicalsLoading = true.obs;
  RxBool isError = false.obs;
  Rx<Disease?> currentDisease = Rx<Disease?>(null);
  var chemicals = <Chemical>[].obs;

  final String url = "${dotenv.env['API_URL']!}/diseases";

  @override
  void onInit() {
    super.onInit();
  }

  Future<Disease?> getDiseaseById(int id) async {
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse("$url/$id"), headers: {
        'Authorization': 'Bearer ${await getToken()}',
        'Content-Type': 'application/json'
      });
      if (response.statusCode == 200) {
        final disease = Disease.fromJson(json.decode(response.body));
        currentDisease.value = disease;
        isLoading.value = false;
        getChemicals(id);
        return disease;
      }
    } catch (e) {
      isLoading.value = false;
      currentDisease.value = null;
      return null;
    }
    return null;
  }

  Future<void> getChemicals(int diseaseId) async {
    try {
      isChemicalsLoading.value = true;
      final response = await http.get(
        Uri.parse("$url/$diseaseId/chemical-controls/"),
        headers: {
          'Authorization': 'Bearer ${await getToken()}',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final List<dynamic> chemicalControls =
            responseBody['chemical_controls'];
        chemicals.value =
            chemicalControls.map((json) => Chemical.fromJson(json)).toList();
      } else {
        chemicals.value = [];
      }
    } catch (e) {
      isChemicalsLoading.value = false;
    } finally {
      isChemicalsLoading.value = false;
    }
  }
}
