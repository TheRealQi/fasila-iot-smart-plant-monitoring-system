import 'package:fasila/models/disease.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import '../models/plant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../mixins/auth_mixin.dart';

class GuideController extends GetxController with AuthMixin {
  RxBool isPlantsLoading = true.obs;
  RxBool isDiseasesLoading = true.obs;
  RxBool isPlantsError = false.obs;
  RxBool isDiseasesError = false.obs;
  var randomPlants = <Plant>[].obs;
  var randomDiseases = <Disease>[].obs;

  final String url = dotenv.env['API_URL']!;

  @override
  void onInit() {
    super.onInit();
    fetch2Plants();
    fetch2Diseases();
  }

  Future<void> fetch2Plants() async {
    try {
      isPlantsError(false);
      isPlantsLoading(true);
      final response =
      await http.get(Uri.parse("$url/plants/2randoms/"), headers: {
        'Authorization': 'Bearer ${await getToken()}',
        'Content-Type': 'application/json'
      });
      if (response.statusCode == 200) {
        List<dynamic> plants = json.decode(response.body);
        randomPlants.value = plants.map((e) => Plant.fromJson(e)).toList();
        if (randomPlants.isEmpty) {
          isPlantsError(true);
        }
      } else {
        isPlantsError(true);
      }
    } catch (e) {
      isPlantsError(true);
    } finally {
      isPlantsLoading(false);
    }
  }

  Future<void> fetch2Diseases() async {
    try {
      isDiseasesError(false);
      isDiseasesLoading(true);
      final response =
      await http.get(Uri.parse("$url/diseases/2randoms/"), headers: {
        'Authorization': 'Bearer ${await getToken()}',
        'Content-Type': 'application/json'
      });
      if (response.statusCode == 200) {
        List<dynamic> diseases = json.decode(response.body);
        randomDiseases.value =
            diseases.map((e) => Disease.fromJson(e)).toList();
        if (randomDiseases.isEmpty) {
          isDiseasesError(true);
        }
      } else {
        isDiseasesError(true);
      }
    } catch (e) {
      isDiseasesError(true);
    } finally {
      isDiseasesLoading(false);
    }
  }
}
