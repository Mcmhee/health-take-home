import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_tracker/views/add/add_view_model.dart';

class AddView extends ConsumerWidget {
  const AddView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addViewModelProvider);
    final vm = ref.read(addViewModelProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('How are you feeling today?'),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Date
                Text(
                  "Date",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () => vm.pickDate(context),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: const Icon(Icons.calendar_today_outlined),
                    ),
                    child: Text(
                      state.selectedDate.toLocal().toString().split(' ')[0],
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                /// Mood
                Text(
                  "How are you feeling today?",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildMoodOption(vm, state, "😀", "Happy", theme),
                _buildMoodOption(vm, state, "😐", "Neutral", theme),
                _buildMoodOption(vm, state, "😴", "Tired", theme),
                _buildMoodOption(vm, state, "😢", "Sad", theme),
                _buildMoodOption(vm, state, "😡", "Angry", theme),
                _buildMoodOption(vm, state, "😱", "Anxious", theme),

                const SizedBox(height: 24),

                /// Note
                Text(
                  "Note (Optional)",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: vm.noteController,
                  onChanged: vm.setNote,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: "Write a note...",
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.hintColor,
                    ),
                  ),
                  style: theme.textTheme.bodyMedium,
                  textInputAction: TextInputAction.done,
                ),

                const SizedBox(height: 24),

                /// Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state.mood == null
                        ? null
                        : () => vm.saveEntry(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: state.mood == null
                          ? theme.disabledColor
                          : theme.colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Save Entry",
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMoodOption(
    AddViewModel vm,
    AddState state,
    String emoji,
    String label,
    ThemeData theme,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: RadioListTile<String>(
        value: label,
        groupValue: state.mood,
        onChanged: (value) => vm.setMood(value!),
        title: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(
              label,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        activeColor: theme.colorScheme.primary,
      ),
    );
  }
}
