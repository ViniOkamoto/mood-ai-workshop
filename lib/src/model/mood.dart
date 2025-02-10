import 'dart:ui';

enum Mood { angry, sad, neutral, happy, excited }

final List<Map<String, dynamic>> moods = [
  {
    'value': Mood.angry,
    'normal': 'assets/emojis/emoji-angry.png',
    'colored': 'assets/emojis/colorful-emoji-angry.png',
  },
  {
    'value': Mood.sad,
    'normal': 'assets/emojis/emoji-sad.png',
    'colored': 'assets/emojis/colorful-emoji-sad.png',
  },
  {
    'value': Mood.neutral,
    'normal': 'assets/emojis/emoji-neutral.png',
    'colored': 'assets/emojis/colorful-emoji-neutral.png',
  },
  {
    'value': Mood.happy,
    'normal': 'assets/emojis/emoji-happy.png',
    'colored': 'assets/emojis/colorful-emoji-happy.png',
  },
  {
    'value': Mood.excited,
    'normal': 'assets/emojis/emoji-excited.png',
    'colored': 'assets/emojis/colorful-emoji-excited.png',
  },
];

getEmojiOnScore(int score) {
  if (score >= 90) {
    return moods.firstWhere((mood) => mood['value'] == Mood.excited)['colored'];
  } else if (score >= 70) {
    return moods.firstWhere((mood) => mood['value'] == Mood.happy)['colored'];
  } else if (score >= 50) {
    return moods.firstWhere((mood) => mood['value'] == Mood.neutral)['colored'];
  } else if (score >= 25) {
    return moods.firstWhere((mood) => mood['value'] == Mood.sad)['colored'];
  } else {
    return moods.firstWhere((mood) => mood['value'] == Mood.angry)['colored'];
  }
}

getColorsOnScore(int score) {
  if (score >= 90) {
    //green vivid
    return const Color(0xFFC0FF70);
  } else if (score >= 70) {
    //green light
    return const Color(0xFFBBFECE);
  } else if (score >= 50) {
    //yellow light
    return const Color(0xFFF5FF90);
  } else if (score >= 25) {
    //orange light
    return const Color(0xFFFEB060);
  } else {
    // red vivid
    return const Color(0xFFFE7070);
  }
}
