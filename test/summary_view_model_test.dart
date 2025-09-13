import 'package:flutter_test/flutter_test.dart';
import 'package:health_tracker/models/health_entry_model.dart';
import 'package:health_tracker/util/helper.dart';

void main() {
  test('weekly summary: counts by mood last 7 days', () {
    final now = DateTime(2025, 9, 13);
    final entries = [
      HealthEntryModel(
        id: 'a',
        userId: 'u',
        date: now.subtract(Duration(days: 1)),
        mood: 'Happy',
      ),
      HealthEntryModel(
        id: 'b',
        userId: 'u',
        date: now.subtract(Duration(days: 2)),
        mood: 'HAPPY',
      ),
      HealthEntryModel(
        id: 'c',
        userId: 'u',
        date: now.subtract(Duration(days: 8)),
        mood: 'Sad',
      ), // excluded
    ];

    final counts = countWeeklyMoods(entries, now: now);
    expect(counts['happy'], 2);
    expect(counts.containsKey('sad'), false);
  });
}
