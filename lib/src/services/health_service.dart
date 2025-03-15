import 'package:health/health.dart';

class HealthService {
  final Health health = Health();

  static const List<HealthDataType> healthTypes = [
    HealthDataType.HEART_RATE,
    HealthDataType.STEPS,
    HealthDataType.SLEEP_IN_BED,
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.SLEEP_AWAKE,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.DISTANCE_WALKING_RUNNING,
    HealthDataType.MINDFULNESS,
    HealthDataType.WATER,
    HealthDataType.BLOOD_OXYGEN,
    HealthDataType.BODY_TEMPERATURE,
  ];

  Future<bool> requestAuthorization() async {
    try {
      return await health.requestAuthorization(healthTypes);
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> fetchHealthData() async {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);
    final yesterday = midnight.subtract(const Duration(days: 1));
    final weekAgo = midnight.subtract(const Duration(days: 7));

    try {
      final authorized = await requestAuthorization();
      if (!authorized) {
        throw Exception('Authorization not granted');
      }

      // Fetch all health metrics
      final healthData = await Future.wait([
        _fetchMetric(HealthDataType.HEART_RATE, midnight, now),
        _fetchMetric(HealthDataType.STEPS, midnight, now),
        _fetchMetric(HealthDataType.SLEEP_ASLEEP, yesterday, now),
        _fetchMetric(HealthDataType.ACTIVE_ENERGY_BURNED, midnight, now),
        _fetchMetric(HealthDataType.DISTANCE_WALKING_RUNNING, midnight, now),
        _fetchMetric(HealthDataType.MINDFULNESS, weekAgo, now),
        _fetchMetric(HealthDataType.WATER, weekAgo, now),
        _fetchMetric(HealthDataType.BLOOD_OXYGEN, weekAgo, now),
        _fetchMetric(HealthDataType.BODY_TEMPERATURE, weekAgo, now),
      ]);

      return {
        'heartRate': _processHeartRateData(healthData[0]),
        'steps': _processStepsData(healthData[1]),
        'sleepHours': _processSleepData(healthData[2]),
        'activeEnergy': _processActiveEnergyData(healthData[3]),
        'distance': _processDistanceData(healthData[4]),
        'mindfulMinutes': _processMindfulnessData(healthData[5]),
        'waterIntake': _processWaterData(healthData[6]),
        'bloodOxygen': _processBloodOxygenData(healthData[7]),
        'bodyTemperature': _processTemperatureData(healthData[8]),
        'lastUpdated': now.toIso8601String(),
      };
    } catch (e) {
      return _getDefaultHealthData();
    }
  }

  Future<List<HealthDataPoint>> _fetchMetric(
    HealthDataType type,
    DateTime start,
    DateTime end,
  ) async {
    try {
      return await health.getHealthDataFromTypes(
        startTime: start,
        endTime: end,
        types: [type],
      );
    } catch (e) {
      return [];
    }
  }

  Map<String, dynamic> _getDefaultHealthData() {
    return {
      'heartRate': 0,
      'steps': 0,
      'sleepHours': 0,
      'activeEnergy': 0,
      'distance': 0,
      'mindfulMinutes': 0,
      'waterIntake': 0,
      'bloodOxygen': 0,
      'bodyTemperature': 0,
      'lastUpdated': DateTime.now().toIso8601String(),
    };
  }

  int _processHeartRateData(List<HealthDataPoint> data) {
    if (data.isEmpty) return 0;
    final values =
        data.map((e) => (e.value as NumericHealthValue).numericValue).toList();
    return (values.reduce((a, b) => a + b) / values.length).round();
  }

  int _processStepsData(List<HealthDataPoint> data) {
    if (data.isEmpty) return 0;
    return data
        .map((e) => (e.value as NumericHealthValue).numericValue.toInt())
        .reduce((a, b) => a + b);
  }

  int _processSleepData(List<HealthDataPoint> data) {
    if (data.isEmpty) return 0;
    final totalMinutes = data
        .map((e) => (e.value as NumericHealthValue).numericValue)
        .reduce((a, b) => a + b);
    return (totalMinutes / 60).round();
  }

  int _processActiveEnergyData(List<HealthDataPoint> data) {
    if (data.isEmpty) return 0;
    return data
        .map((e) => (e.value as NumericHealthValue).numericValue.toInt())
        .reduce((a, b) => a + b);
  }

  double _processDistanceData(List<HealthDataPoint> data) {
    if (data.isEmpty) return 0;
    final meters = data
        .map((e) => (e.value as NumericHealthValue).numericValue)
        .reduce((a, b) => a + b);
    return double.parse((meters / 1000).toStringAsFixed(2)); // Convert to km
  }

  int _processMindfulnessData(List<HealthDataPoint> data) {
    if (data.isEmpty) return 0;
    return data
        .map((e) => (e.value as NumericHealthValue).numericValue.toInt())
        .reduce((a, b) => a + b);
  }

  int _processWaterData(List<HealthDataPoint> data) {
    if (data.isEmpty) return 0;
    return data
        .map((e) => (e.value as NumericHealthValue).numericValue.toInt())
        .reduce((a, b) => a + b);
  }

  int _processBloodOxygenData(List<HealthDataPoint> data) {
    if (data.isEmpty) return 0;
    final values =
        data.map((e) => (e.value as NumericHealthValue).numericValue).toList();
    return (values.reduce((a, b) => a + b) / values.length).round();
  }

  double _processTemperatureData(List<HealthDataPoint> data) {
    if (data.isEmpty) return 0;
    final values =
        data.map((e) => (e.value as NumericHealthValue).numericValue).toList();
    return double.parse(
        (values.reduce((a, b) => a + b) / values.length).toStringAsFixed(1));
  }
}
