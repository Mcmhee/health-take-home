import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_tracker/models/health_entry_model.dart';
import 'package:health_tracker/models/user_model.dart';
import 'package:health_tracker/services/connectivity_service.dart';
import 'package:health_tracker/services/hive_service.dart';
import 'package:health_tracker/services/superbase_service.dart';
import 'package:health_tracker/util/helper.dart';
import 'package:health_tracker/views/summary/summary_view.dart';
import 'package:health_tracker/views/summary/summary_view_model.dart';

final dashboardNotifierProvider =
    NotifierProvider<DashboardNotifier, DashboardState>(
      () => DashboardNotifier(),
    );

class DashboardState {
  final bool isLoading;
  final UserModel? currentUser;
  final List<HealthEntryModel>? entries;

  DashboardState({this.isLoading = false, this.currentUser, this.entries});

  DashboardState copyWith({
    bool? isLoading,
    UserModel? currentUser,
    List<HealthEntryModel>? entries,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      currentUser: currentUser ?? this.currentUser,
      entries: entries ?? this.entries,
    );
  }
}

class DashboardNotifier extends Notifier<DashboardState> {
  final HiveService hive = HiveService.instance;
  final SupabaseService supabase = SupabaseService.instance;

  @override
  DashboardState build() {
    final initialState = DashboardState();
    Future.microtask(() => loadUser());
    Future.microtask(() => loadEntries());
    return initialState;
  }

  void setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  void setUser(UserModel user) {
    state = state.copyWith(currentUser: user);
  }

  void loadUser() {
    setLoading(true);
    final user = hive.getUser();
    setUser(user!);
    setLoading(false);
  }

  Future<void> loadEntries() async {
    setLoading(true);
    var entries = hive.getAllEntries();
    entries = entries.reversed.toList();
    state = state.copyWith(entries: entries);
    setLoading(false);

    if (state.currentUser != null &&
        await NetworkService.instance.hasConnection()) {
      final onlineEntries = await supabase.fetchEntries(state.currentUser!.id!);
      final mergedEntries = mergeEntries(entries, onlineEntries);
      await hive.saveAllEntries(mergedEntries);
      state = state.copyWith(entries: mergedEntries);
      supabase.syncEntries(mergedEntries);
    }
  }

  Future<void> loadOfflineEntries() async {
    setLoading(true);
    var entries = hive.getAllEntries();
    entries = entries.reversed.toList();
    state = state.copyWith(entries: entries);
    setLoading(false);
  }

  Future<void> deleteEntry(BuildContext context, HealthEntryModel entry) async {
    if (entry.id == null) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Entry'),
        content: Text('Are you sure you want to delete this entry?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    setLoading(true);
    try {
      await hive.deleteEntry(entry.id!);
      if (state.currentUser != null &&
          await NetworkService.instance.hasConnection()) {
        supabase.deleteEntry(entry.id!.toString());
      }
    } finally {
      await loadOfflineEntries();
      setLoading(false);
    }
  }

  String getMoodEmoji(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy':
        return '😊';
      case 'sad':
        return '😢';
      case 'angry':
        return '😠';
      case 'excited':
        return '🤩';
      case 'anxious':
        return '😰';
      default:
        return '🙂';
    }
  }

  void gotoAddEntry(BuildContext context) {
    Navigator.of(context).pushNamed('/add').then((_) => loadOfflineEntries());
  }

  void gotoSummary(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          ref.invalidate(summaryNotifierProvider);
          return const SummaryView();
        },
      ),
    );
  }
}
