import 'package:heart_bpm/heart_bpm.dart';

class HeartRateModel {
  double averageBPM;
  List<SensorValue> bpmValues;

  HeartRateModel({
    required this.averageBPM,
    required this.bpmValues,
  });
}
