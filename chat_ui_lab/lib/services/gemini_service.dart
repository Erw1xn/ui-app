import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat_message.dart';


class GeminiService {
  // IMPORTANT: Remember to replace this with your actual, secured API key.
  static const String apiKey = '';
  static const String apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';


  // 🗑️ We no longer need the static systemPrompt here. It will be passed in.
  // static const String systemPrompt = '''...''';

  static List<Map<String, dynamic>> _formatMessages(
      List<ChatMessage> messages,
      ) {
    return messages.map((msg) {
      return {
        'role': msg.role == 'user' ? 'user' : 'model',
        'parts': [{'text': msg.text}],
      };
    }).toList();
  }
  // ✨ MODIFIED METHOD ✨
  // It now accepts a 'systemPrompt' string as an argument.
  static Future<String> sendMultiTurnMessage({
    required List<ChatMessage> conversationHistory,
    required String systemPrompt, // ← ADD THIS ARGUMENT
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': _formatMessages(conversationHistory),
          // Use the passed-in systemPrompt
          'system_instruction': {
            'parts': [{'text': systemPrompt}] // ← USE THE ARGUMENT HERE
          },
          'generationConfig': {
            'temperature': 0.7,
            'topK': 1,
            'topP': 1,
            'maxOutputTokens': 2048, // Adjusted for typical chat responses
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Added safety check for response structure
        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          return data['candidates'][0]['content']['parts'][0]['text'];
        }
        return 'Error: Received an empty response from the API.';
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['error']?['message'] ?? 'Unknown error';
        return 'Error: ${response.statusCode} - $errorMessage';
      }
    } catch (e) {
      return 'Network Error: $e';
    }
  }
}
