import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mood_ai/src/model/mood_request.dart';
import 'package:mood_ai/src/model/mood_result.dart';
import 'package:mood_ai/src/model/mood.dart';

class GeminiService {
  static const apiKey = 'AIzaSyAXbdrHXAM07gMuhBcI4YMk3SO9NyupIHE';
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

  Future<MoodResult> analyzeVoiceMood(String audioPath) async {
    try {
      print('Debug: Starting voice analysis process');

      // TODO: Replace with actual speech-to-text service
      final transcription = await _transcribeAudio(audioPath);
      print('Debug: Audio transcribed: $transcription');

      final moodRequest =
          await _createMoodRequestFromTranscription(transcription);
      print('Debug: Created mood request from transcription');

      return analyzeMood(moodRequest);
    } catch (e) {
      print('Debug: Error in analyzeVoiceMood: $e');
      throw Exception('Failed to analyze voice mood: $e');
    }
  }

  Future<String> _transcribeAudio(String audioPath) async {
    // TODO: Integrate with Google Cloud Speech-to-Text or other service
    // For now, return a simulated transcription
    await Future.delayed(
        const Duration(seconds: 2)); // Simulate processing time
    return _getRandomDescription();
  }

  // Temporary helper methods for development
  String _getRandomMood() {
    final moods = ['pretty good', 'a bit tired', 'okay', 'not so good'];
    return moods[DateTime.now().millisecond % moods.length];
  }

  String _getRandomDescription() {
    final descriptions = [
      'I had a productive morning and enjoyed my workout.',
      'Work has been challenging but I\'m managing.',
      'I\'m looking forward to the weekend.',
      'There\'s been a lot on my mind lately.',
      'Just taking things one day at a time.'
    ];
    return descriptions[DateTime.now().millisecond % descriptions.length];
  }

  Future<MoodRequest> _createMoodRequestFromTranscription(
      String transcription) async {
    try {
      final prompt = '''
You are a mood analysis AI. Analyze the following transcribed speech and extract the mood, factors, and description. 
Respond ONLY with a valid JSON object in the exact format shown below, with no additional text or formatting:
{
  "mood": "HAPPY",
  "factors": ["WORK", "HEALTH"],
  "description": "Brief description here"
}

Notes:
- mood MUST be one of: "EXCITED", "HAPPY", "SAD", "ANGRY", "NEUTRAL"
- factors should be 1-3 relevant keywords
- description should be a brief summary

Text to analyze: "$transcription"
''';

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      final responseText = response.text ?? '';

      print('Debug: Raw Gemini response: $responseText');

      // Clean up the response text to ensure it's valid JSON
      final cleanJson =
          responseText.replaceAll('```json', '').replaceAll('```', '').trim();

      print('Debug: Cleaned JSON: $cleanJson');

      final data = jsonDecode(cleanJson);

      // Validate required fields
      if (!data.containsKey('mood') ||
          !data.containsKey('factors') ||
          !data.containsKey('description')) {
        throw Exception('Invalid response format: missing required fields');
      }

      // Validate mood value
      final moodStr = data['mood'].toString().toUpperCase();
      if (!['EXCITED', 'HAPPY', 'SAD', 'ANGRY', 'NEUTRAL'].contains(moodStr)) {
        throw Exception('Invalid mood value: $moodStr');
      }

      return MoodRequest(
        mood: _parseMood(moodStr),
        factors: List<String>.from(data['factors']),
        description: data['description'],
      );
    } catch (e) {
      print('Debug: Error parsing mood request: $e');
      throw Exception('Failed to create mood request from transcription: $e');
    }
  }

  Mood _parseMood(String mood) {
    switch (mood.toUpperCase()) {
      case 'HAPPY':
        return Mood.happy;
      case 'SAD':
        return Mood.sad;
      case 'ANGRY':
        return Mood.angry;
      default:
        return Mood.neutral;
    }
  }

  String _createPrompt(MoodRequest request) {
    final healthContext = request.healthData != null
        ? '''

Health Context:
${_formatHealthData(request.healthData!)}
'''
        : '';

    return '''
Act as an empathetic AI therapist analyzing a person's mood and health data. Here's their input:

Mood: ${request.mood.name}
Factors affecting mood: ${request.factors.join(', ')}
Description: ${request.description}$healthContext

Please provide a comprehensive mood analysis considering both emotional state and physical health metrics in the following JSON format:
{
  "score": {
    "value": <number between 1-100>,
    "description": "<score description considering both mood and health metrics>"
  },
  "summary": "<analysis of mood, factors, and health data correlations>",
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
- Score should reflect overall well-being (1=worst, 100=best)
- Consider how health metrics might be affecting mood
- Summary should be empathetic and holistic
- Recommendations should address both emotional and physical well-being
- Include at least 3 recommendations
- Use pastel tones for colors
- Use relevant text icons for recommendations
''';
  }

  String _formatHealthData(Map<String, dynamic> healthData) {
    final sleepQuality = _getSleepQuality(healthData['sleepHours']);
    final activityLevel = _getActivityLevel(
      healthData['steps'],
      healthData['activeEnergy'],
    );
    final mindfulness = _getMindfulnessStatus(healthData['mindfulMinutes']);
    final hydration = _getHydrationStatus(healthData['waterIntake']);

    return '''- Sleep: ${healthData['sleepHours']} hours ($sleepQuality)
- Physical Activity: ${healthData['steps']} steps, ${healthData['distance']}km walked, ${healthData['activeEnergy']} calories burned ($activityLevel)
- Heart Rate: ${healthData['heartRate']} BPM
- Blood Oxygen: ${healthData['bloodOxygen']}%
- Body Temperature: ${healthData['bodyTemperature']}°C
- Mindfulness: ${healthData['mindfulMinutes']} minutes ($mindfulness)
- Hydration: ${healthData['waterIntake']}ml ($hydration)''';
  }

  String _getSleepQuality(int hours) {
    if (hours >= 8) return 'Well rested';
    if (hours >= 6) return 'Adequate';
    if (hours >= 4) return 'Insufficient';
    return 'Sleep deprived';
  }

  String _getActivityLevel(int steps, int calories) {
    if (steps >= 10000 || calories >= 500) return 'Very active';
    if (steps >= 7500 || calories >= 350) return 'Active';
    if (steps >= 5000 || calories >= 200) return 'Moderately active';
    return 'Sedentary';
  }

  String _getMindfulnessStatus(int minutes) {
    if (minutes >= 30) return 'Very mindful';
    if (minutes >= 15) return 'Mindful';
    if (minutes >= 5) return 'Somewhat mindful';
    return 'Not mindful';
  }

  String _getHydrationStatus(int ml) {
    if (ml >= 2500) return 'Well hydrated';
    if (ml >= 1500) return 'Adequately hydrated';
    if (ml >= 750) return 'Somewhat hydrated';
    return 'Dehydrated';
  }

  MoodResult _parseMoodResult(String response) {
    try {
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
      throw Exception('Failed to parse mood result: $e');
    }
  }
}
