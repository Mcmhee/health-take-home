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
