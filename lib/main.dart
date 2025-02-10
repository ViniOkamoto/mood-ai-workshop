import 'package:flutter/material.dart';
import 'package:mood_ai/core/theme/app_theme.dart';

import 'package:mood_ai/src/screens/mood_tracker_screen.dart';
import 'package:mood_ai/src/screens/mood_tracker_screen_stateful.dart';
import 'package:mood_ai/src/screens/mood_tracker_screnn_stateless.dart';
import 'package:mood_ai/src/screens/mood_dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood AI',
      theme: AppTheme.lightTheme,
      home: const MoodDashboard(),
    );
  }
}
