import 'package:flutter/material.dart';

class MoodLegend extends StatelessWidget {
  final String emoji;
  final String label;
  final int days;
  final Color color;

  const MoodLegend({
    super.key,
    required this.emoji,
    required this.label,
    required this.days,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: color,
          child: Text(emoji, style: const TextStyle(fontSize: 20)),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        Text("$days days", style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class WeeklyInsightCard extends StatelessWidget {
  final String summary;
  const WeeklyInsightCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF16C6A8), Color(0xFF0AA9B6)], // teal gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lightbulb_outline, color: Colors.white, size: 36),
          SizedBox(height: 12),
          Text(
            "Weekly Insight",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12),
          Text(
            summary,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, height: 1.5, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
