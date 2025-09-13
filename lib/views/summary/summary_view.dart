import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'summary_view_model.dart';

class SummaryView extends ConsumerWidget {
  const SummaryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(summaryNotifierProvider);
    final vm = ref.read(summaryNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("Summary")),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => vm.loadOfflineEntries(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        const SizedBox(height: 20),
                        _buildDateChip(),
                        const SizedBox(height: 24),

                        _buildMoodChart(state),
                        const SizedBox(height: 20),

                        _buildOverview(state),
                        const SizedBox(height: 20),

                        WeeklyInsightCard(summary: _generateInsight(state)),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateChip() {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));

    String formatDate(DateTime date) =>
        "${date.day}/${date.month}/${date.year}";

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade100,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.calendar_today, color: Colors.teal),
            const SizedBox(width: 8),
            Text(
              "${formatDate(weekAgo)} - ${formatDate(now)}",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodChart(SummaryState state) {
    final moods = state.moodCounts;

    if (moods.isEmpty) {
      return const Text("No data available for this week.");
    }

    final colors = _getMoodColors(moods.keys.toList());

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Column(
        children: [
          const Text(
            "Mood Distribution",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY:
                    (moods.values.isNotEmpty
                            ? moods.values.reduce((a, b) => a > b ? a : b)
                            : 5)
                        .toDouble(),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, interval: 1),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < moods.keys.length) {
                          return Text(moods.keys.elementAt(index));
                        }
                        return const Text("");
                      },
                    ),
                  ),
                ),
                barGroups: List.generate(
                  moods.length,
                  (i) => makeGroupData(
                    i,
                    moods.values.elementAt(i),
                    colors[i % colors.length],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          /// Dynamic Legends
          Wrap(
            spacing: 10,
            runSpacing: 4,
            children: List.generate(moods.length, (i) {
              final mood = moods.keys.elementAt(i);
              final count = moods[mood] ?? 0;
              return MoodLegend(
                emoji: "🙂",
                label: mood,
                days: count,
                color: colors[i % colors.length].withOpacity(0.2),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildOverview(SummaryState state) {
    final moods = state.moodCounts;
    if (moods.isEmpty) return const SizedBox();

    final summaryText = moods.entries
        .map((e) => "${e.value} ${e.key}")
        .join(" • ");

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.teal.shade50,
      ),
      child: Column(
        children: [
          const Text(
            "This Week's Overview",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(summaryText),
          const SizedBox(height: 8),
          const Text(
            "✨ Keep tracking your moods daily for better insights!",
            style: TextStyle(color: Colors.teal),
          ),
        ],
      ),
    );
  }

  String _generateInsight(SummaryState state) {
    final moods = state.moodCounts;
    if (moods.isEmpty) return "No insights yet. Start logging your moods!";

    final topMood = moods.entries
        .reduce((a, b) => a.value >= b.value ? a : b)
        .key;

    return "You're having a week where **$topMood** has been most frequent. "
        "Reflect on what contributes to this mood and keep journaling daily.";
  }

  /// Utility: Assign colors
  List<Color> _getMoodColors(List<String> moods) {
    final palette = [
      Colors.teal,
      Colors.orange,
      Colors.blue,
      Colors.purple,
      Colors.green,
      Colors.red,
    ];
    return List.generate(moods.length, (i) => palette[i % palette.length]);
  }

  BarChartGroupData makeGroupData(int x, int y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y.toDouble(),
          color: color,
          borderRadius: BorderRadius.circular(20),
          width: 30,
          gradient: LinearGradient(
            colors: [color.withOpacity(0.5), color],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
      ],
    );
  }
}

/// Mood Legend Widget
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
    return Chip(backgroundColor: color, label: Text("$emoji $label ($days)"));
  }
}

/// Insight Card
class WeeklyInsightCard extends StatelessWidget {
  final String summary;

  const WeeklyInsightCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(summary, style: const TextStyle(fontSize: 14)),
      ),
    );
  }
}
