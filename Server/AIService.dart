import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  final String apiKey;

  AIService({required this.apiKey});

  Future<dynamic> generateResponse(String inputText) async {
    const url = 'https://guujiyae.me/proxy/openai/v1';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({'input': inputText}), // Gửi tham số input
    );

    if (response.statusCode == 200) {
      print('Response Body: ${response.body}'); // In ra phản hồi để kiểm tra
      return jsonDecode(response.body); // Phân tích JSON
    } else {
      print('Error Response: ${response.body}'); // In ra thông báo lỗi
      throw Exception('Failed to load AI response: ${response.body}');
    }
  }
}
