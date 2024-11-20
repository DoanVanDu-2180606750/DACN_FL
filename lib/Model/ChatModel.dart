import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatModel {
  final String apiKey;
  ChatModel(this.apiKey);

  Future<String> sendMessage(String message) async {
    final uri = Uri.parse('https://guujiyae.me/proxy/openai/v1');
    final response = await http.post(uri,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo', // Or whichever model you prefer
        'messages': [
          {'role': 'user', 'content': message}
        ],
      }),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['choices'][0]['message']['content'];
    } else {
      throw Exception('Failed to fetch response from API');
    }
  }
}
