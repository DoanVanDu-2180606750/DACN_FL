import 'package:flutter/foundation.dart';

class StepsData {
  int currentSteps;
  int targetSteps;
  double caloriesBurned;

  StepsData({
    this.currentSteps = 0,
    this.targetSteps = 5000, // Giá trị mặc định
    this.caloriesBurned = 0.0,
  });
}

class StepsProvider with ChangeNotifier {
  StepsData _stepData = StepsData();

  StepsData get stepData => _stepData;

  void updateSteps(int newSteps) {
    _stepData.currentSteps = newSteps;
    _stepData.caloriesBurned = newSteps * 0.04;
    notifyListeners();
  }

  void resetSteps() {
    _stepData = StepsData();
    notifyListeners();
  }
}
