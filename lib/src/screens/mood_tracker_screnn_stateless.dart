import 'package:flutter/material.dart';
import 'package:mood_ai/core/theme/theme_constants.dart';
import 'package:mood_ai/src/model/factors.dart';
import 'package:mood_ai/src/model/mood.dart';
import 'package:mood_ai/src/widgets/chip.dart';
import 'package:mood_ai/src/widgets/text_field.dart';
import 'package:mood_ai/src/widgets/app_button.dart';

class MoodTrackerScreenStateless extends StatelessWidget {
  const MoodTrackerScreenStateless({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 100,
        leading: TextButton.icon(
          style: TextButton.styleFrom(
            iconSize: 24,
          ),
          icon: const Icon(Icons.chevron_left),
          label: const Text('Back', style: AppTextStyles.bodyMedium),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How are you feeling today?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.dark_900,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                moods.length,
                (index) => InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () => print(moods[index]['value']),
                  child: Image.asset(
                    moods[index]['value'] == moods[index]['value']
                        ? moods[index]['colored']
                        : moods[index]['normal'],
                    width: 58,
                    height: 58,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "What's affecting your mood?",
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: factors.map((factor) {
                return AppChip(
                  label: factor,
                  isSelected: false,
                  onSelected: (selected) => print(selected),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            Text(
              "Let's write about it",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.dark_900,
                  ),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: TextEditingController(),
              hintText:
                  'How is your day going? How has it affected your mood? Or anything else...',
            ),
            const SizedBox(height: 32),
            AppButton(
              text: 'Log mood',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
