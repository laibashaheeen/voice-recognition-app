import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class OpenAIService {
  final List<Map<String, String>> messages = [];

  Future<String> isArtPromptAPI(String prompt) async {
    try {
      // Validate input
      if (prompt.trim().isEmpty) {
        return 'Please provide a valid prompt.';
      }

      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${dotenv.env['OPENAI_API_KEY']}',
        },
        body: jsonEncode({
          "model": dotenv.env['OPENAI_MODEL_NAME'],
          "messages": [
            {
              'role': 'user',
              'content':
                  'Does this message want to generate an AI picture, image, art or anything similar? $prompt . Simply answer with a yes or no.',
            }
          ]
        }),
      );

      if (res.statusCode == 200) {
        String content = jsonDecode(res.body)['choices'][0]['messages']?['content'] ?? '';
        content = content.trim();
        switch (content.toLowerCase()) {
          case 'yes':
            final res = await dallEAPI(prompt);
            return res;
          default:
            final res = await chatGPTAPI(prompt);
            return res;
        }
      } else {
        // Log the error
        print('OpenAI API error: ${res.body}');
        return 'An error occurred while processing your request. Please try again later.';
      }
    } catch (e) {
      // Log the error
      print('Error: $e');
      return 'An unexpected error occurred. Please try again later.';
    }
  }

  Future<String> chatGPTAPI(String prompt) async {
    messages.add({
      'role': 'user',
      'content': prompt,
    });
    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${dotenv.env['OPENAI_API_KEY']}',
        },
        body: jsonEncode({
          "model": dotenv.env['OPENAI_MODEL_NAME'],
          "messages": messages,
        }),
      );

      if (res.statusCode == 200) {
        String content = jsonDecode(res.body)['choices'][0]['messages']?['content'] ?? '';
        content = content.trim();
        messages.add({
          'role': 'assistant',
          'content': content,
        });
        return content;
      } else {
        // Log the error
        print('OpenAI API error: ${res.body}');
        return 'An error occurred while processing your request. Please try again later.';
      }
    } catch (e) {
      // Log the error
      print('Error: $e');
      return 'An unexpected error occurred. Please try again later.';
    }
  }

  Future<String> dallEAPI(String prompt) async {
    messages.add({
      'role': 'user',
      'content': prompt,
    });
    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/images/generations'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${dotenv.env['OPENAI_API_KEY']}',
        },
        body: jsonEncode({
          'prompt': prompt,
          'n': 1,
        }),
      );

      if (res.statusCode == 200) {
        String imageUrl = jsonDecode(res.body)['data'][0]['url'] ?? '';
        imageUrl = imageUrl.trim();
        messages.add({
          'role': 'assistant',
          'content': imageUrl,
        });
        return imageUrl;
      } else {
        // Log the error
        print('OpenAI API error: ${res.body}');
        return 'An error occurred while processing your request. Please try again later.';
      }
    } catch (e) {
      // Log the error
      print('Error: $e');
      return 'An unexpected error occurred. Please try again later.';
    }
  }
}


