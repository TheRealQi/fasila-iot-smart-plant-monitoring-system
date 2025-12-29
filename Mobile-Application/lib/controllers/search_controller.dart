import 'dart:async';
import 'dart:convert';
import 'package:fasila/mixins/auth_mixin.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../models/disease.dart';
import '../models/plant.dart';

class SearchController1 extends GetxController with AuthMixin {
  final TextEditingController textController = TextEditingController();
  final RxBool isSearching = false.obs;
  final RxBool isEditing = false.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<Plant> plantResults = <Plant>[].obs;
  final RxList<Disease> diseaseResults = <Disease>[].obs;

  Timer? _debounce;
  final String url = dotenv.env['API_URL'] ?? '';

  @override
  void onInit() {
    super.onInit();
    if (url.isEmpty) {
      errorMessage.value = 'API URL not configured';
      return;
    }
    textController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    isEditing.value = textController.text.isNotEmpty;
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      filterSearchResults(textController.text);
    });
  }

  @override
  void onClose() {
    textController.dispose();
    _debounce?.cancel();
    super.onClose();
  }

  void closeSearch() {
    textController.clear();
    isSearching.value = false;
    isEditing.value = false;
    isLoading.value = false;
    errorMessage.value = '';
    plantResults.clear();
    diseaseResults.clear();
  }

  Future<void> filterSearchResults(String query) async {
    if (query.isEmpty) {
      plantResults.clear();
      diseaseResults.clear();
      errorMessage.value = 'Query cannot be empty';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final token = await getToken();
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      };

      final futures = await Future.wait([
        http.get(
          Uri.parse('$url/plants/search').replace(
            queryParameters: {'query': query},
          ),
          headers: headers,
        ),
        http.get(
          Uri.parse('$url/diseases/search').replace(
            queryParameters: {'query': query},
          ),
          headers: headers,
        ),
      ]);
      final plantResponse = futures[0];
      final diseaseResponse = futures[1];
      if (plantResponse.statusCode == 200) {
        final List<dynamic> plantData = json.decode(plantResponse.body);
        plantResults.assignAll(
          plantData.map((json) => Plant.fromJson(json)).toList(),
        );
      } else {
        plantResults.clear();
        _handleErrorResponse('Plant search failed', plantResponse);
      }

      if (diseaseResponse.statusCode == 200) {
        final List<dynamic> diseaseData = json.decode(diseaseResponse.body);
        print(diseaseData);
        diseaseResults.assignAll(
          diseaseData.map((json) => Disease.fromJson(json)).toList(),
        );
      } else {
        diseaseResults.clear();
        _handleErrorResponse('Disease search failed', diseaseResponse);
      }
    } catch (e) {
      errorMessage.value = 'Search failed: ${e.toString()}';
      plantResults.clear();
      diseaseResults.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void _handleErrorResponse(String context, http.Response response) {
    try {
      final errorData = json.decode(response.body);
      errorMessage.value =
      '$context: ${errorData['error'] ?? 'Unknown error occurred'}';
    } catch (e) {
      errorMessage.value = '$context: Status ${response.statusCode}';
    }
  }
}
