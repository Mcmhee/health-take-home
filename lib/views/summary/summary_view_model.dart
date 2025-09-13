import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_tracker/models/health_entry_model.dart';
import 'package:health_tracker/services/hive_service.dart';

final summaryNotifierProvider = NotifierProvider<SummaryNotifier, SummaryState>(
  () => SummaryNotifier(),
);

class SummaryState {
  final bool isLoading;
  final List<HealthEntryModel>? entries;
  final Map<String, int> moodCounts;

  SummaryState({
    this.isLoading = false,
    this.entries,
    this.moodCounts = const {},
  });

  SummaryState copyWith({
    bool? isLoading,
    List<HealthEntryModel>? entries,
    Map<String, int>? moodCounts,
  }) {
    return SummaryState(
      isLoading: isLoading ?? this.isLoading,
      entries: entries ?? this.entries,
      moodCounts: moodCounts ?? this.moodCounts,
    );
  }
}

class SummaryNotifier extends Notifier<SummaryState> {
  final HiveService hive = HiveService.instance;

  @override
  SummaryState build() {
    final initialState = SummaryState();
    Future.microtask(() => loadOfflineEntries());
    return initialState;
  }

  void setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  Future<void> loadOfflineEntries() async {
    setLoading(true);
    var entries = hive.getAllEntries();
    entries = entries.reversed.toList();
    state = state.copyWith(entries: entries);
    _generateWeeklySummary(entries);
    setLoading(false);
  }

  void _generateWeeklySummary(List<HealthEntryModel> entries) {
    final now = DateTime.now();
    final oneWeekAgo = now.subtract(const Duration(days: 7));

    final recentEntries = entries
        .where((e) => e.date.isAfter(oneWeekAgo))
        .toList();

    final counts = <String, int>{};

    for (var e in recentEntries) {
      final mood = e.mood.trim().toLowerCase();
      if (mood.isEmpty) continue;

      counts[mood] = (counts[mood] ?? 0) + 1;
    }

    state = state.copyWith(moodCounts: counts);
  }
}
