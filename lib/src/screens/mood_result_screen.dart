import 'package:flutter/material.dart';
import 'package:mood_ai/src/model/mood_result.dart';
import 'package:mood_ai/core/theme/theme_constants.dart';

class MoodResultScreen extends StatelessWidget {
  final MoodResult result;

  const MoodResultScreen({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Mood Analysis'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mood Score: ${result.score.value}',
              style: AppTextStyles.h2,
            ),
            Text(
              result.score.description,
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: 24),
            Text(
              'Summary',
              style: AppTextStyles.h3,
            ),
            Text(
              result.summary,
              style: AppTextStyles.bodyLarge,
            ),
            const SizedBox(height: 24),
            Text(
              'Recommendation',
              style: AppTextStyles.h3,
            ),
            Text(
              result.recommendation,
              style: AppTextStyles.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
