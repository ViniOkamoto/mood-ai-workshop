import 'package:flutter/material.dart';
import 'package:mood_ai/core/theme/theme_constants.dart';
import 'package:mood_ai/src/model/mood.dart';
import 'package:mood_ai/src/model/mood_result.dart';
import 'package:mood_ai/src/screens/mood_tracker_screen.dart';
import 'package:mood_ai/src/widgets/app_button.dart';
import 'package:mood_ai/src/widgets/recommendation_card.dart';

class MoodDashboard extends StatefulWidget {
  const MoodDashboard({
    super.key,
  });

  @override
  State<MoodDashboard> createState() => _MoodDashboardState();
}

class _MoodDashboardState extends State<MoodDashboard> {
  MoodResult? moodResult;

  String _getMoodMessage(int score) {
    if (score >= 90) {
      return "You're feeling fantastic!";
    } else if (score >= 70) {
      return "You're doing well today!";
    } else if (score >= 50) {
      return "You're feeling balanced";
    } else if (score >= 25) {
      return "Things will get better";
    } else {
      return "Take a deep breath";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: moodResult != null
          ? FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MoodTrackerScreen(),
                  ),
                );
                setState(() {
                  moodResult = result as MoodResult;
                });
              },
              child: const Icon(Icons.add),
            )
          : null,
      body: SafeArea(
        child: moodResult == null
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('No mood request', style: AppTextStyles.h2),
                    const SizedBox(height: 16),
                    Text('Please check your mood request',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.dark_300,
                        )),
                    const SizedBox(height: 16),
                    AppButton(
                      text: 'Check your mood',
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MoodTrackerScreen(),
                          ),
                        );
                        setState(() {
                          moodResult = result as MoodResult;
                        });
                      },
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hello, John Doe',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w200,
                              color: Colors.blueGrey),
                        ),
                        const Text(
                          'Your Mood Today',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        IntrinsicHeight(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFBBFECE),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      const Text(
                                        'Current Score',
                                        style: AppTextStyles.bodySmall,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        moodResult!.score.value.toString(),
                                        style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Text('Score'),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 4,
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: getColorsOnScore(
                                        moodResult!.score.value),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const SizedBox(width: 20),
                                          Image.asset(
                                            getEmojiOnScore(
                                                moodResult!.score.value),
                                            height: 24,
                                            width: 24,
                                          ),
                                          const SizedBox(width: 20),
                                          Expanded(
                                            // Add this
                                            child: Text(
                                              _getMoodMessage(
                                                  moodResult!.score.value),
                                              style: AppTextStyles.bodyLarge
                                                  .copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Check in your trends tips that can improve your score',
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: AppColors.dark_500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFFFF8989),
                                      Color(0xFFFD5D5D),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Heart beat rate',
                                        style: TextStyle(color: Colors.white)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '90 BPM',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        Icon(Icons.favorite, color: Colors.red),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF481798),
                                      Color(0xFF2C1955),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Sleep time',
                                        style: TextStyle(color: Colors.white)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '7 hours',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        Icon(Icons.bedtime,
                                            color: Colors.deepPurple),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Trends for you',
                          style: AppTextStyles.h3.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...List.generate(
                          moodResult?.recommendations.length ?? 0,
                          (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: RecommedationCard(
                              title: moodResult!.recommendations[index].title,
                              description: moodResult!
                                  .recommendations[index].description,
                              icon: moodResult!.recommendations[index].icon,
                              color: moodResult!.recommendations[index].color,
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
      ),
    );
  }
}
