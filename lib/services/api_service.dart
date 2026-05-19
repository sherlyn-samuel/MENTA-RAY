import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiKey = "YOUR_API_KEY";

  static Future<Map<String, dynamic>> generateQuestion(String difficulty) async {
    final url = Uri.parse(
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey",
    );

    final prompt = """
Generate ONE arithmetic question.

Difficulty: $difficulty

Return ONLY JSON:
{
  "num1": 2,
  "num2": 3,
  "question": "What's 2+3?",
  "options": [5,6,4,3],
  "correctAnswer": 5
}
""";

    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": prompt}
            ]
          }
        ]
      }),
    );

    final data = jsonDecode(res.body);
    String text = data["candidates"][0]["content"]["parts"][0]["text"];

    text = text.replaceAll("```json", "").replaceAll("```", "").trim();

    return jsonDecode(text);
  }
}