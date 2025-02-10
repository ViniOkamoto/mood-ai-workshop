import 'dart:convert';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mood_ai/src/model/mood_request.dart';
import 'package:mood_ai/src/model/mood_result.dart';

class GeminiService {
  static const apiKey = 'YOUR_API_KEY';
  final model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: apiKey,
    safetySettings: [
      SafetySetting(
        HarmCategory.harassment,
        HarmBlockThreshold.high,
      ),
      SafetySetting(
        HarmCategory.dangerousContent,
        HarmBlockThreshold.high,
      ),
    ],
  );

  Future<MoodResult> analyzeMood(MoodRequest request) async {
    try {
      final prompt = _createPrompt(request);
      final content = [Content.text(prompt)];

      final response = await model.generateContent(content);
      final responseText = response.text ?? '';

      return _parseMoodResult(responseText);
    } catch (e) {
      throw Exception('Failed to analyze mood: $e');
    }
  }

  String _createPrompt(MoodRequest request) {
    return '''
    Act as an empathetic AI therapist analyzing a person's mood. Here's their input:

    Mood: ${request.mood.name}
    Factors affecting mood: ${request.factors.join(', ')}
    Description: ${request.description}

    Please provide a mood analysis in the following JSON format:
    {
      "score": {
        "value": <number between 1-100>,
        "description": "<score description>"
      },
      "summary": "<brief analysis of their mood and factors>",
      "recommendations": [
        {
          "icon": "<text icon>",
          "title": "<title of the recommendation>",
          "description": "<description of the recommendation>",
          "color": "<hex pastel tones color of the recommendation>"
        }
      ]
    }

    Guidelines:
    - Score should reflect overall mood (1=worst, 100=best)
    - Summary should be empathetic and acknowledge their feelings
    - Recommendation should be practical and specific to their situation
    - Keep responses concise but meaningful
    - Recommendation should be a list of recommendations at least 3 recommendations
    - recommendations colors should be pastel tones and should create a pleasant and calming effect, and contrast with the icons.
    - recommendations icons should be relevant to the recommendation and should be a text icon.
    ''';
  }

  MoodResult _parseMoodResult(String response) {
    try {
      // Remove any markdown formatting if present
      final cleanJson =
          response.replaceAll('```json', '').replaceAll('```', '');

      final Map<String, dynamic> data = jsonDecode(cleanJson);

      final scoreData = data['score'] as Map<String, dynamic>;
      final score = Score(
        value: scoreData['value'],
        description: scoreData['description'],
      );

      final recommendationsData = data['recommendations'] as List;
      final recommendations = recommendationsData
          .map((rec) => Recommendation(
                icon: rec['icon'],
                title: rec['title'],
                description: rec['description'],
                color: rec['color'],
              ))
          .toList();

      return MoodResult(
        score: score,
        summary: data['summary'],
        recommendations: recommendations,
      );
    } catch (e) {
      print(e);
      throw Exception('Failed to parse mood result: $e');
    }
  }
}
