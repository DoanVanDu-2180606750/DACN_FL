// providers/steps_provider.dart
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';

import 'package:fit_25/Model/steps_model.dart';
import 'package:fit_25/Service/StepsService.dart';

class StepsProvider with ChangeNotifier {
  StepData _stepData = StepData(currentSteps: 0, targetSteps: 8000, elapsedTime: Duration.zero, runningSteps: 0, caloriesBurned: 0);
  final StepCounterService _stepCounterService = StepCounterService();

  StepsProvider() {
    _initializeStepCountStream();
  }

  StepData get stepData => _stepData;

  void _initializeStepCountStream() {
    _stepCounterService.stepCountStream.listen((StepCount event) {
      _updateSteps(event.steps);
    });
  }

  void _updateSteps(int newSteps) {
    _stepData = StepData(
      currentSteps: newSteps,
      targetSteps: _stepData.targetSteps,
      elapsedTime: _stepData.elapsedTime,
      runningSteps: _stepData.runningSteps + 1,
      caloriesBurned: _calculateCalories(newSteps),
    );
    notifyListeners();
  }

  int _calculateCalories(int steps) {
    return (steps * 0.04).toInt();
  }

  void updateTargetSteps(int newTarget) {
    _stepData = StepData(
      currentSteps: _stepData.currentSteps,
      targetSteps: newTarget,
      elapsedTime: _stepData.elapsedTime,
      runningSteps: _stepData.runningSteps,
      caloriesBurned: _stepData.caloriesBurned,
    );
    notifyListeners();
  }
}
