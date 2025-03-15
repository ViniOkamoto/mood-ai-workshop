import 'package:flutter/material.dart';
import 'package:mood_ai/core/theme/theme_constants.dart';
import 'package:mood_ai/src/screens/mood_tracker_screen.dart';
import 'package:mood_ai/src/screens/voice_mood_screen.dart';

class MoodInputSelectionScreen extends StatelessWidget {
  const MoodInputSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'How would you like to share your mood?',
                style: AppTextStyles.h2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              _InputOptionCard(
                title: 'Voice Input',
                description: 'Share your mood by speaking naturally',
                icon: Icons.mic,
                gradient: const LinearGradient(
                  colors: [Color(0xFF6448FE), Color(0xFF5FC6FF)],
                ),
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VoiceMoodScreen(),
                    ),
                  );
                  if (result != null) {
                    Navigator.pop(context, result);
                  }
                },
              ),
              const SizedBox(height: 24),
              _InputOptionCard(
                title: 'Form Input',
                description: 'Share your mood using our guided form',
                icon: Icons.edit_note,
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF9A9E), Color(0xFFFAD0C4)],
                ),
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MoodTrackerScreen(),
                    ),
                  );
                  if (result != null) {
                    Navigator.pop(context, result);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InputOptionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _InputOptionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 48,
              color: Colors.white,
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.white,
              size: 32,
            ),
          ],
        ),
      ),
    );
  }
}
