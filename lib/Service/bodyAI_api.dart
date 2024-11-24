import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> getAdviceFromGemini(String content) async {
  final response = await http.post(
    Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=AIzaSyDvh0xxPUrEu3rwChoKm4C0G7dGKpy7FN4'), // Endpoint
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'contents': [
        {
          'parts': [
            {'text': content}
          ]
        }
      ]
    }),
  );

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body);
    // Kiểm tra cấu trúc phản hồi và điều chỉnh theo API của bạn
    return jsonResponse['output']['content'].toString().trim(); // Trả về văn bản câu trả lời
  } else {
    throw Exception('Failed to load advice from AI: ${response.body}');
  }
}
