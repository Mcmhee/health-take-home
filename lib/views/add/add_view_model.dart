import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_tracker/models/health_entry_model.dart';
import 'package:health_tracker/services/connectivity_service.dart';
import 'package:health_tracker/services/hive_service.dart';
import 'package:health_tracker/services/superbase_service.dart';
import 'package:uuid/uuid.dart';

class AddState {
  final bool isLoading;
  final DateTime selectedDate;
  final String? mood;
  final String note;

  const AddState({
    required this.selectedDate,
    this.mood,
    this.note = '',
    this.isLoading = false,
  });

  AddState copyWith({
    DateTime? selectedDate,
    String? mood,
    String? note,
    bool? isLoading,
  }) {
    return AddState(
      selectedDate: selectedDate ?? this.selectedDate,
      mood: mood ?? this.mood,
      note: note ?? this.note,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AddViewModel extends Notifier<AddState> {
  final HiveService hive = HiveService.instance;
  final SupabaseService supabase = SupabaseService.instance;
  late final TextEditingController noteController;

  @override
  AddState build() {
    noteController = TextEditingController();
    ref.onDispose(noteController.dispose);

    return AddState(selectedDate: DateTime.now());
  }

  void pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: state.selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != state.selectedDate) {
      state = state.copyWith(selectedDate: picked);
    }
  }

  void setMood(String mood) {
    state = state.copyWith(mood: mood);
  }

  void setNote(String note) {
    state = state.copyWith(note: note);
  }

  void setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  Future<void> saveEntry(BuildContext context) async {
    setLoading(true);
    try {
      final user = hive.getUser();
      if (user == null) {
        setLoading(false);
        return;
      }

      if (state.mood == null || state.mood!.isEmpty) {
        setLoading(false);
        return;
      }

      final newEntry = HealthEntryModel(
        id: const Uuid().v4(),
        userId: user.id!,
        date: state.selectedDate,
        mood: state.mood!,
        note: state.note,
        isSynced: false,
      );

      await hive.addEntry(newEntry);

      if (await NetworkService.instance.hasConnection()) {
        supabase.createEntry(newEntry);
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Entry saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e, stack) {
      debugPrint('Error saving entry: $e\n$stack');
    } finally {
      setLoading(false);
    }
  }
}

final addViewModelProvider =
    NotifierProvider.autoDispose<AddViewModel, AddState>(AddViewModel.new);
