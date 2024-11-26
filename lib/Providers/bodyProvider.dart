import 'package:fit_25/Service/bodyAI_api.dart';
import 'package:flutter/material.dart';
import 'package:fit_25/Model/body_model.dart';

class BodyProvider with ChangeNotifier {
  BodyInfo? _bodyInfo;
  String _aiAdvice = "Nhập đầy đủ thông tin";
  bool _isLoading = false;  // Track loading state

  BodyInfo? get bodyInfo => _bodyInfo;
  String get aiAdvice => _aiAdvice;
  bool get isLoading => _isLoading;

  final BodyService _bodyService = BodyService();

  void updateUserInfo(double height, double weight) {
    _bodyInfo = BodyInfo(height: height, weight: weight); // Assume a constructor in BodyInfo
    notifyListeners(); // Notify listeners of user info update
  }

  Future<void> fetchAIAdvice(double height, double weight) async {
    _isLoading = true; // Set loading to true
    notifyListeners(); // Notify listeners to show loading state

    try {
      // Call the BodyService to fetch AI advice
      await _bodyService.fetchAiAdvice(height, weight); // Assuming this method accepts height and weight
      // Retrieve the AI advice from the BodyService
      _aiAdvice = _bodyService.aiAdvice!; // Get AI advice from BodyService
    } catch (error) {
      _aiAdvice = "An error occurred while fetching advice: $error";
    } finally {
      _isLoading = false; // Set loading to false
      notifyListeners(); // Notify listeners to update UI
    }
  }
}
