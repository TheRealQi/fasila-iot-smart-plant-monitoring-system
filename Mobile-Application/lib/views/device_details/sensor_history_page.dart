import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math';

import '../widgets/custom_header.dart';

class SensorHistoryController extends GetxController {
  final RxString selectedDuration = '1d'.obs;
  final RxList<SensorData> _fullSensorData = <SensorData>[].obs;
  final RxList<SensorData> sensorData = <SensorData>[].obs;
  final RxDouble maxSensorValue = 0.0.obs;

  final Map<String, int> durationHours = {
    '1d': 24,
    '7d': 7 * 24,
    '2w': 14 * 24,
    '1m': 30 * 24,
    '6m': 6 * 30 * 24,
    '1y': 12 * 30 * 24,
    'Max': 365 * 24,
  };

  final RxList<String> availableDurationOptions = <String>[].obs;
  void changeDuration(String duration) {
    if (isDurationAvailable(duration)) {
      selectedDuration.value = duration;
      _filterSensorData(duration);
    } else {
      selectedDuration.value = 'Max';
      _filterSensorData('Max');
    }
  }

  bool isDurationAvailable(String duration) {
    int requiredHours = durationHours[duration] ?? 0;
    return _fullSensorData.length >= requiredHours;
  }

  void _filterSensorData(String duration) {
    int requiredHours = durationHours[duration] ?? 24;
    sensorData.value = _fullSensorData.where((data) {
      return _fullSensorData.last.time.difference(data.time).inHours <= requiredHours;
    }).toList();
    maxSensorValue.value = sensorData.map((data) => data.value).reduce((a, b) => a > b ? a : b);
  }

  void updateAvailableDurations() {
    List<String> newAvailableDurations = [];
    durationHours.forEach((duration, requiredHours) {
      if (duration != 'Max') {
        if (_fullSensorData.length >= requiredHours) {
          newAvailableDurations.add(duration);
        }
      }
    });
    if (_fullSensorData.isNotEmpty) {
      newAvailableDurations.add('Max');
    }
    if (newAvailableDurations.contains('1d')) {
      newAvailableDurations.remove('1d');
      newAvailableDurations.insert(0, '1d');
    }
    availableDurationOptions.value = newAvailableDurations;
  }

  List<SensorData> _generateFullMockData() {
    final Random random = Random();
    final int totalPoints = 3 * 7 * 24;
    return List.generate(totalPoints, (index) {
      double baseValue = 50;
      double amplitude = 30;

      double sinWave = sin(index * 0.1) * amplitude;
      double randomNoise = random.nextDouble() * 10 - 5;
      double value = baseValue + sinWave + randomNoise;
      value = max(0, min(100, value));
      return SensorData(
        DateTime.now().subtract(Duration(hours: index)),
        value,
      );
    }).reversed.toList();
  }

  String getDateFormat() {
    if (selectedDuration.value == '1d') {
      return 'HH:mm';
    } else if (selectedDuration.value == '7d' || selectedDuration.value == '2w') {
      return 'MMM d \nHH:mm';
    } else {
      return 'MMM yyyy';
    }
  }

  @override
  void onInit() {
    super.onInit();
    _fullSensorData.value = _generateFullMockData();
    updateAvailableDurations();
    changeDuration('1d');
  }
}

class SensorData {
  final DateTime time;
  final double value;
  SensorData(this.time, this.value);
}

class SensorHistoryPage extends StatelessWidget {
  const SensorHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SensorHistoryController controller = Get.put(SensorHistoryController());

    return CustomHeader(
      headerText: "Sensor History",
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Obx(() => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: controller.availableDurationOptions.map((duration) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                      onPressed: () => controller.changeDuration(duration),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: controller.selectedDuration.value == duration
                            ? Colors.blue
                            : Colors.grey[300],
                        foregroundColor: controller.selectedDuration.value == duration
                            ? Colors.white
                            : Colors.black,
                      ),
                      child: Text(duration),
                    ),
                  );
                }).toList(),
              ),
            )),
          ),
          Obx(() => SfCartesianChart(
            primaryXAxis: DateTimeAxis(
              intervalType: controller.selectedDuration.value == '1d'
                  ? DateTimeIntervalType.hours
                  : controller.selectedDuration.value == '7d' || controller.selectedDuration.value == '2w'
                  ? DateTimeIntervalType.days
                  : DateTimeIntervalType.months,
              dateFormat: DateFormat(controller.getDateFormat()),
              title: AxisTitle(text: 'Time'),
              edgeLabelPlacement: EdgeLabelPlacement.shift,
              minimum: controller.sensorData.isNotEmpty
                  ? controller.sensorData.first.time
                  : null,
              maximum: controller.sensorData.isNotEmpty
                  ? controller.sensorData.last.time
                  : null,
            ),
            primaryYAxis: NumericAxis(
              minimum: 0,
              maximum: 100,
              title: AxisTitle(text: 'Sensor Value'),
            ),
            series: <LineSeries<SensorData, DateTime>>[
              LineSeries<SensorData, DateTime>(
                dataSource: controller.sensorData,
                xValueMapper: (SensorData data, _) => data.time,
                yValueMapper: (SensorData data, _) => data.value,
                color: Colors.blue,
                width: 2,
              ),
            ],
            tooltipBehavior: TooltipBehavior(
              enable: true,
              header: 'Sensor Reading',
              format: 'point.x : point.y',
            ),
          )),
        ],
      ),
    );
  }
}
