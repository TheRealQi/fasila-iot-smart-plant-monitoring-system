import 'dart:convert';
import 'package:fasila/mixins/auth_mixin.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import '../models/disease.dart';
import 'package:http/http.dart' as http;

class DiseasesController extends GetxController with AuthMixin {
  var diseasesList = <Disease>[].obs;
  RxBool isError = false.obs;
  RxBool isLoading = true.obs;

  final String url = "${dotenv.env['API_URL']!}/diseases/";

  @override
  void onInit() {
    fetchDiseases();
    super.onInit();
  }

  Future<void> fetchDiseases() async {
    try {
      isLoading(true);
      isError(false);
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer ${await getToken()}',
        'Content-Type': 'application/json'
      });
      if (response.statusCode == 200) {
        List<dynamic> diseases = json.decode(response.body);
        diseasesList.value = diseases.map((e) => Disease.fromJson(e)).toList();
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
