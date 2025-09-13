import 'package:health_tracker/models/health_entry_model.dart';

List<HealthEntryModel> mergeEntries(
  List<HealthEntryModel> local,
  List<HealthEntryModel> online,
) {
  // Create a map keyed by id to avoid duplicates
  final Map<String, HealthEntryModel> map = {};

  for (var entry in local) {
    map[entry.id!] = entry;
  }

  for (var entry in online) {
    map[entry.id!] = entry;
  }

  // Convert back to list and sort reverse chronological
  final merged = map.values.toList();
  merged.sort((a, b) => b.date.compareTo(a.date));
  return merged;
}

/// Count moods within the last 7 days relative to [now].
/// - Normalizes mood strings by trimming and lowercasing.
/// - Skips empty moods.
Map<String, int> countWeeklyMoods(
  List<HealthEntryModel> entries, {
  DateTime? now,
}) {
  final refNow = now ?? DateTime.now();
  final oneWeekAgo = refNow.subtract(const Duration(days: 7));

  final counts = <String, int>{};
  for (final e in entries) {
    if (e.date.isAfter(oneWeekAgo)) {
      final mood = e.mood.trim().toLowerCase();
      if (mood.isEmpty) continue;
      counts[mood] = (counts[mood] ?? 0) + 1;
    }
  }
  return counts;
}
