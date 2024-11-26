import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class BodyService with ChangeNotifier {
  String? _aiAdvice;
  bool _isLoading = false;

  String? get aiAdvice => _aiAdvice;
  bool get isLoading => _isLoading;

  Future<void> fetchAiAdvice(double height, double weight) async {
    _isLoading = true; // Set loading to true
    notifyListeners(); // Notify listeners about loading state

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
              'text': "Tôi cao: $height m và cân nặng: $weight kg, tính chỉ số BMI và đưa ra nhận xét. Viết khoảng 4 câu thôi.",
            }
          ]
        }
      ]
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
        final responseData = json.decode(response.body);

        // Extract the AI response from the response
        _aiAdvice = responseData['candidates']?[0]['content']['parts']?[0]['text'] ?? "No advice returned";
        print(_aiAdvice);
      } else {
        _aiAdvice = "Failed to get AI advice.";
      }
    } catch (error) {
      _aiAdvice = "An error occurred: $error";
    } finally {
      _isLoading = false;  // Set loading to false when request is done
      notifyListeners(); // Notify listeners to update UI
    }
  }
}
