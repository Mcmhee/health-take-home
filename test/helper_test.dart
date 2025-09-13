import 'package:flutter_test/flutter_test.dart';
import 'package:health_tracker/models/health_entry_model.dart';
import 'package:health_tracker/util/helper.dart';

void main() {
  group('mergeEntries', () {
    test('deduplicates by id and keeps newest first', () {
      final now = DateTime(2025, 1, 10);
      final local = [
        HealthEntryModel(id: '1', userId: 'u', date: now, mood: 'Happy'),
        HealthEntryModel(
          id: '2',
          userId: 'u',
          date: now.subtract(Duration(days: 1)),
          mood: 'Sad',
        ),
      ];
      final online = [
        // duplicate id: '2' newer date should win when present in map assignment last
        HealthEntryModel(
          id: '2',
          userId: 'u',
          date: now.add(Duration(days: 1)),
          mood: 'Neutral',
        ),
        HealthEntryModel(
          id: '3',
          userId: 'u',
          date: now.subtract(Duration(days: 2)),
          mood: 'Angry',
        ),
      ];

      final merged = mergeEntries(local, online);

      // Unique IDs
      expect(merged.map((e) => e.id).toSet().length, 3);

      // Sorted newest first by date
      expect(merged.first.id, '2');

      // The newer online version should be present for id '2'
      final two = merged.firstWhere((e) => e.id == '2');
      expect(two.mood.toLowerCase(), 'neutral');
    });
  });

  group('countWeeklyMoods', () {
    test('counts moods within last 7 days and normalizes text', () {
      final anchor = DateTime(2025, 1, 8);
      final entries = [
        HealthEntryModel(
          id: '1',
          userId: 'u',
          date: anchor.subtract(Duration(days: 1)),
          mood: 'Happy',
        ),
        HealthEntryModel(
          id: '2',
          userId: 'u',
          date: anchor.subtract(Duration(days: 3)),
          mood: ' happy ',
        ),
        HealthEntryModel(
          id: '3',
          userId: 'u',
          date: anchor.subtract(Duration(days: 10)),
          mood: 'Sad',
        ), // out of range
        HealthEntryModel(id: '4', userId: 'u', date: anchor, mood: ''), // empty
      ];

      final counts = countWeeklyMoods(entries, now: anchor);
      expect(counts['happy'], 2);
      expect(counts.containsKey('sad'), false);
    });
  });
}
