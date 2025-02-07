import 'package:mood_ai/src/model/mood.dart';

class MoodRequest {
  final Mood mood;
  final String description;
  final List<String> factors;

  MoodRequest({
    required this.mood,
    required this.description,
    required this.factors,
  });

  @override
  String toString() {
    return 'MoodRequest(mood: $mood, description: $description, factors: $factors)';
  }
}
