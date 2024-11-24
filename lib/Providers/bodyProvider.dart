import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserInfoProvider with ChangeNotifier {
  double _height = 0.0;
  double _weight = 0.0;
  String _aiAdvice = "Nhập đầy đủ thông tin";
  bool _isLoading = false;  // Track loading state

  double get height => _height;
  double get weight => _weight;
  String get aiAdvice => _aiAdvice;
  bool get isLoading => _isLoading;

  void updateUserInfo(double height, double weight) {
    _height = height;
    _weight = weight;
    notifyListeners();
  }

  Future<void> fetchAIAdvice(String height, String weight) async {
    _isLoading = true;
    notifyListeners();  // Notify listeners to show loading state

    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=AIzaSyDvh0xxPUrEu3rwChoKm4C0G7dGKpy7FN4');

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = json.encode({
      'contents': [
        {
          'parts': [
            {
              'text': " Tôi cao: $height m và cân nặng: $weight kg, tính chỉ số BMI và đưa ra nhận xét Và cho tôi. V iết khoảng 4 câu thôi.",
            }
          ]
        }
      ]
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print('cái này là cái đầu tiên nà: ${response.body} chấm hết ở đây nhaaaaaaaaaaaa');
        final responseData = json.decode(response.body);
        print(responseData);
        // Extract the AI response from the response
        _aiAdvice = responseData['candidates'][0]['content']['parts'][0]['text'] ?? "No advice returned";
        print(_aiAdvice);
      } else {
        _aiAdvice = "Failed to get AI advice.";
      }
    } catch (error) {
      _aiAdvice = "An error occurred: $error";
    }

    _isLoading = false;  // Set loading to false when request is done
    notifyListeners();  // Notify listeners to stop loading
  }
}
