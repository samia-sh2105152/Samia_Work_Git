import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static Future<String> generateWorkoutPlan({
    required String goal,
    required String level,
    required String days,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("http://localhost:3000/generate-workout"),

        headers: {
          "Content-Type": "application/json",
        },

        body: jsonEncode({
          "goal": goal,
          "level": level,
          "days": days,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return data["result"];
      } else {
        return "Error generating workout";
      }
    } catch (e) {
      return "Connection Error: $e";
    }
  }
}