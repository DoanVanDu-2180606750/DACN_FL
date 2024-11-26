// services/step_counter_service.dart
import 'package:pedometer/pedometer.dart';
import 'package:flutter/material.dart';

class StepCounterService {
  late Stream<StepCount> _stepCountStream;

  StepCounterService() {
    _stepCountStream = Pedometer.stepCountStream;
  }

  Stream<StepCount> get stepCountStream => _stepCountStream;
}
