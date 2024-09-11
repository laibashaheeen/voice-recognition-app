// import 'dart:convert';

// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;

// class OpenAIService {
//   final List<Map<String, String>> messages = [];

//   Future<String> isArtPromptAPI(String prompt) async {
//     try {
//       // Validate input
//       if (prompt.trim().isEmpty) {
//         return 'Please provide a valid prompt.';
//       }

//       final res = await http.post(
//         Uri.parse('https://api.openai.com/v1/chat/completions'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${dotenv.env['OPENAI_API_KEY']}',
//         },
//         body: jsonEncode({
//           "model": dotenv.env['OPENAI_MODEL_NAME'],
//           "messages": [
//             {
//               'role': 'user',
//               'content':
//                   'Does this message want to generate an AI picture, image, art or anything similar? $prompt . Simply answer with a yes or no.',
//             }
//           ]
//         }),
//       );

//       if (res.statusCode == 200) {
//         String content = jsonDecode(res.body)['choices'][0]['messages']?['content'] ?? '';
//         content = content.trim();
//         switch (content.toLowerCase()) {
//           case 'yes':
//             final res = await dallEAPI(prompt);
//             return res;
//           default:
//             final res = await chatGPTAPI(prompt);
//             return res;
//         }
//       } else {
//         // Log the error
//         print('OpenAI API error: ${res.body}');
//         return 'An error occurred while processing your request. Please try again later.';
//       }
//     } catch (e) {
//       // Log the error
//       print('Error: $e');
//       return 'An unexpected error occurred. Please try again later.';
//     }
//   }

//   Future<String> chatGPTAPI(String prompt) async {
//     messages.add({
//       'role': 'user',
//       'content': prompt,
//     });
//     try {
//       final res = await http.post(
//         Uri.parse('https://api.openai.com/v1/chat/completions'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${dotenv.env['OPENAI_API_KEY']}',
//         },
//         body: jsonEncode({
//           "model": dotenv.env['OPENAI_MODEL_NAME'],
//           "messages": messages,
//         }),
//       );

//       if (res.statusCode == 200) {
//         String content = jsonDecode(res.body)['choices'][0]['messages']?['content'] ?? '';
//         content = content.trim();
//         messages.add({
//           'role': 'assistant',
//           'content': content,
//         });
//         return content;
//       } else {
//         // Log the error
//         print('OpenAI API error: ${res.body}');
//         return 'An error occurred while processing your request. Please try again later.';
//       }
//     } catch (e) {
//       // Log the error
//       print('Error: $e');
//       return 'An unexpected error occurred. Please try again later.';
//     }
//   }

//   Future<String> dallEAPI(String prompt) async {
//     messages.add({
//       'role': 'user',
//       'content': prompt,
//     });
//     try {
//       final res = await http.post(
//         Uri.parse('https://api.openai.com/v1/images/generations'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer ${dotenv.env['OPENAI_API_KEY']}',
//         },
//         body: jsonEncode({
//           'prompt': prompt,
//           'n': 1,
//         }),
//       );

//       if (res.statusCode == 200) {
//         String imageUrl = jsonDecode(res.body)['data'][0]['url'] ?? '';
//         imageUrl = imageUrl.trim();
//         messages.add({
//           'role': 'assistant',
//           'content': imageUrl,
//         });
//         return imageUrl;
//       } else {
//         // Log the error
//         print('OpenAI API error: ${res.body}');
//         return 'An error occurred while processing your request. Please try again later.';
//       }
//     } catch (e) {
//       // Log the error
//       print('Error: $e');
//       return 'An unexpected error occurred. Please try again later.';
//     }
//   }
// }

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
        return 'Error: Please provide a valid prompt.';
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

        // if (content == 'yes') {
        //   print('isArtPromptAPI: Detected art prompt, calling dallEAPI');
        //   final res = await dallEAPI(prompt);
        //   return res;
        // }
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
        return 'Error: API request failed with status ${res.statusCode}. Please try again later.';
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
        return 'Error: An unexpected error occurred. Please try again later.';
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
        return 'Error: ChatGPT request failed. Please try again later.';
      }
    } catch (e) {
      print('chatGPTAPI: Caught exception: $e');
      return 'Error: An unexpected error occurred in chatGPTAPI. Please try again later.';
    }
  }

// Future<String> dallEAPI(String prompt) async {
//   print('dallEAPI: Starting function');
//   messages.add({
//     'role': 'user',
//     'content': prompt,
//   });
//   try {
//     final res = await http.post(
//       Uri.parse('https://api.openai.com/v1/images/generations'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer ${dotenv.env['OPENAI_API_KEY']}',
//       },
//       body: jsonEncode({
//         'prompt': prompt,
//         'n': 1,
//       }),
//     );

//     print('dallEAPI: API response status code: ${res.statusCode}');

//     if (res.statusCode == 200) {
//       String imageUrl = jsonDecode(res.body)['data'][0]['url'] ?? '';
//       imageUrl = imageUrl.trim();
//       messages.add({
//         'role': 'assistant',
//         'content': imageUrl,
//       });
//       print('dallEAPI: Successfully received image URL: $imageUrl');
//       return imageUrl;
//     } else {
//       print('dallEAPI: OpenAI API error: ${res.body}');
//       return 'Error: DALL-E image generation failed. Please try again later.';
//     }
//   } catch (e) {
//     print('dallEAPI: Caught exception: $e');
//     return 'Error: An unexpected error occurred in dallEAPI. Please try again later.';
//   }
// }

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
          'model': 'dall-e-3', // Specify the DALL-E 2 model
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
        return 'Error: DALL-E image generation failed. Please try again later.';
      }
    } catch (e) {
      print('dallEAPI: Caught exception: $e');
      return 'Error: An unexpected error occurred in dallEAPI. Please try again later.';
    }
  }
}
