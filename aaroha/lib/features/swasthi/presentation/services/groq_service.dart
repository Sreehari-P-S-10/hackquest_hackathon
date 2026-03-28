import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GroqService {
  static String get _apiKey => dotenv.env['GROQ_API_KEY'] ?? '';
  static const _model = 'llama-3.3-70b-versatile';
  static const _baseUrl = 'https://api.groq.com/openai/v1/chat/completions';

  static const _systemPrompt = '''
You are Swasthi, a compassionate AI companion inside Aaroha — a recovery support app for people in Kerala, India dealing with substance use disorders.

Guidelines:
- Be warm, empathetic, and non-judgmental at all times
- Keep responses concise: 2–4 sentences max per reply
- When the user mentions cravings, suggest grounding, breathwork, or journaling
- Reference their recovery streak naturally when relevant
- Use occasional Malayalam words warmly (e.g. Njan manasilakkunnu = I understand)
- NEVER give medical advice, medication names, or dosage info
- If the user seems in crisis or mentions self-harm, gently direct them to call 1800-599-0019 (Vandrevala Foundation, 24/7 free)
- You are NOT a therapist — you are a supportive, caring companion

Tone: Like a wise, gentle older sibling who truly listens.
''';

  final List<Map<String, String>> _history = [];

  Future<String> sendMessage(String userMessage, {int streakDays = 0}) async {
    if (_apiKey.isEmpty) {
      return 'Configuration error — GROQ_API_KEY not found in .env 🔑';
    }

    // Inject streak context on the very first message
    final enriched = (_history.isEmpty && streakDays > 0)
        ? '$userMessage\n\n[System context: User has a $streakDays-day recovery streak. Acknowledge this warmly when relevant.]'
        : userMessage;

    _history.add({'role': 'user', 'content': enriched});

    try {
      final response = await http
          .post(
            Uri.parse(_baseUrl),
            headers: {
              'Authorization': 'Bearer $_apiKey',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'model': _model,
              'messages': [
                {'role': 'system', 'content': _systemPrompt},
                ..._history,
              ],
              'max_tokens': 220,
              'temperature': 0.72,
              'top_p': 0.9,
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply =
            (data['choices'][0]['message']['content'] as String).trim();
        _history.add({'role': 'assistant', 'content': reply});

        // Keep history bounded to last 20 turns (10 exchanges)
        if (_history.length > 20) {
          _history.removeRange(0, 2);
        }

        return reply;
      } else if (response.statusCode == 429) {
        return "I need a moment to breathe too 🌿 Try again in a few seconds.";
      } else {
        return "Something didn't connect. Take a slow breath — I'm still here. 💚";
      }
    } on Exception {
      return "Network hiccup. You're not alone — try again in a moment. 🙏";
    }
  }

  void clearHistory() => _history.clear();

  int get messageCount => _history.length;
}