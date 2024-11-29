import 'package:flutter/material.dart';
import 'package:heart_bpm/heart_bpm.dart';

class HeartRateProvider with ChangeNotifier {
  double _averageBPM = 0.0;
  List<SensorValue> _bpmValues = [];

  double get averageBPM => _averageBPM;
  List<SensorValue> get bpmValues => _bpmValues;

  void updateHeartRate(double averageBPM, List<SensorValue> bpmValues) {
    _averageBPM = averageBPM;
    _bpmValues = List.from(bpmValues); // Sử dụng List.from để tạo một bản sao.
    notifyListeners(); // Thông báo cho các widget lắng nghe.
  }
}
