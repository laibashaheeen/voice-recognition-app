
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class OpenAIService {
  final List<Map<String, String>> messages = [];
  Future<String> isArtPromptAPI(String prompt) async {
    try {
      print('isArtPromptAPI: Starting function with prompt: "$prompt"');

      if (prompt.trim().isEmpty) {
        print('isArtPromptAPI: Empty prompt provided');
        return 'Oops! Looks like you forgot to type something. Give it another shot!';
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
                  'Analyze if this message is requesting to generate an AI picture, image, art or anything similar. Respond with only "yes" if it is, or "no" if it is not. Message: $prompt',
            }
          ]
        }),
      );

      print('isArtPromptAPI: API response status code: ${res.statusCode}');

      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'] ?? '';
        content = content.trim().toLowerCase();

        print('isArtPromptAPI: OpenAI API Response: "$content"');

        
        if (content == 'yes') {
          print('isArtPromptAPI: Detected art prompt, calling dallEAPI');
          final imageUrl = await dallEAPI(prompt);
          if (imageUrl.startsWith('http')) {
            return imageUrl;
          } else {
            print('dallEAPI failed, falling back to chatGPTAPI');
            return await chatGPTAPI(prompt);
          }
        } else if (content == 'no') {
          print('isArtPromptAPI: Detected non-art prompt, calling chatGPTAPI');
          final res = await chatGPTAPI(prompt);
          return res;
        } else {
          print('isArtPromptAPI: Unexpected response from OpenAI: "$content"');
          // Fallback to chatGPT for unexpected responses
          print('isArtPromptAPI: Falling back to chatGPTAPI');
          final res = await chatGPTAPI(prompt);
          return res;
        }
      } else {
        print('isArtPromptAPI: OpenAI API error: ${res.statusCode}');
        print('isArtPromptAPI: Response body: ${res.body}');
        return 'That was unexpected! Let’s try that again or maybe tweak your request.';
      }
    } catch (e) {
      print('isArtPromptAPI: Caught exception: $e');
      // Fallback to chatGPT for any exceptions
      print('isArtPromptAPI: Falling back to chatGPTAPI due to exception');
      try {
        final res = await chatGPTAPI(prompt);
        return res;
      } catch (chatError) {
        print('chatGPTAPI fallback error: $chatError');
        return 'Something went wrong! Try again, and if it keeps happening, let us know!';
      }
    }
  }

  Future<String> chatGPTAPI(String prompt) async {
    print('chatGPTAPI: Starting function');
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

      print('chatGPTAPI: API response status code: ${res.statusCode}');

      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'] ?? '';
        content = content.trim();
        messages.add({
          'role': 'assistant',
          'content': content,
        });
        print('chatGPTAPI: Successfully received response');
        return content;
      } else {
        print('chatGPTAPI: OpenAI API error: ${res.body}');
        return 'Something went wrong! Try again, and if it keeps happening, let us know!';
      }
    } catch (e) {
      print('chatGPTAPI: Caught exception: $e');
      return 'That was unexpected! Let’s try that again or maybe tweak your request.';
    }
  }

  Future<String> dallEAPI(String prompt) async {
    print('dallEAPI: Starting function with prompt: "$prompt"');
    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/images/generations'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${dotenv.env['OPENAI_API_KEY']}',
        },
        body: jsonEncode({
          'model': 'dall-e-3', // Specify the DALL-E 3 model
          'prompt': prompt,
          'n': 1,
          // 'size': "1024x1024",  // You can adjust this based on your needs and plan
        }),
      );

      print('dallEAPI: API response status code: ${res.statusCode}');

      if (res.statusCode == 200) {
        var jsonResponse = jsonDecode(res.body);
        String imageUrl = jsonResponse['data'][0]['url'];
        print('dallEAPI: Successfully received image URL: $imageUrl');
        return imageUrl;
      } else {
        print('dallEAPI: OpenAI API error: ${res.body}');
        return 'Uh-oh, we couldn’t create the image right now. Maybe try again in a few minutes?';
      }
    } catch (e) {
      print('dallEAPI: Caught exception: $e');
      return 'Unable to generate the image at the moment. Please try again.';
    }
  }
}
