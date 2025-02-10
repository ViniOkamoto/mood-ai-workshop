class MoodResult {
  final Score score;
  final String summary;
  final List<Recommendation> recommendations;
  MoodResult({
    required this.score,
    required this.summary,
    required this.recommendations,
  });
}

class Recommendation {
  final String icon;
  final String title;
  final String description;
  final String color;
  Recommendation({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}

class Score {
  final int value;
  final String description;
  Score({
    required this.value,
    required this.description,
  });

  @override
  String toString() {
    return 'Score(value: $value, description: $description)';
  }
}

List<Score> scores = List.generate(100, (index) {
  final value = index + 1;
  String description;

  if (value <= 20) {
    description = 'Very Bad';
  } else if (value <= 40) {
    description = 'Bad';
  } else if (value <= 60) {
    description = 'Okay';
  } else if (value <= 80) {
    description = 'Good';
  } else {
    description = 'Excellent';
  }

  return Score(value: value, description: description);
});
