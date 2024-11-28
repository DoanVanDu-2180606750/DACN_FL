import 'package:fit_25/Service/bodyAI_api.dart';
import 'package:flutter/material.dart'; 
import 'package:fit_25/Model/body_model.dart';

class BodyProvider with ChangeNotifier { 
  BodyInfo? _bodyInfo; 
  String _aiAdvice = "Nhập đầy đủ thông tin"; 
  bool _isLoading = false;

  BodyInfo? get bodyInfo => _bodyInfo; 
  String get aiAdvice => _aiAdvice; 
  bool get isLoading => _isLoading;

  final BodyService _bodyService = BodyService();

  void updateUserInfo(double height, double weight) { 
    _bodyInfo = BodyInfo(height: height, weight: weight);
    notifyListeners();
  }

  Future<void> fetchAIAdvice(double height, double weight) async { 
    _isLoading = true;
    notifyListeners();
    try {
      // Gọi dịch vụ BodyService để lấy lời khuyên AI
      await _bodyService.fetchAiAdvice(height, weight);
      // Lấy lời khuyên AI từ BodyService
      _aiAdvice = _bodyService.aiAdvice!;
    } catch (error) {
      _aiAdvice = "Một lỗi đã xảy ra khi lấy lời khuyên: $error";
    } finally {
      _isLoading = false; 
      notifyListeners();
    }
  }
}
