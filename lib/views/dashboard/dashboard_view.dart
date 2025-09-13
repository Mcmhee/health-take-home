import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_tracker/views/dashboard/dashboard_view_model.dart';
import 'package:health_tracker/widget/banner.dart';

class Dashboard extends ConsumerWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardNotifierProvider);
    final notifier = ref.read(dashboardNotifierProvider.notifier);
    final mediaQuery = MediaQuery.of(context);

    //
    return Scaffold(
      appBar: AppBar(
        title: const Text("Health Tracker"),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(30),
          child: ConnectivityBanner(),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              icon: const Icon(Icons.bar_chart, size: 26),
              label: const Text("Summary"),
              onPressed: () {
                notifier.gotoSummary(context);
              },
            ),
          ),
        ],
      ),

      //
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => notifier.gotoAddEntry(context),
        label: const Text('Add Entry'),
        icon: const Icon(Icons.add),
        elevation: 0.5,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //
            const SizedBox(height: 20),
            Text(
              'Welcome ${state.currentUser?.name ?? 'Guest'}! 👋',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            //
            const SizedBox(height: 20),

            Builder(
              builder: (context) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.entries == null || state.entries!.isEmpty) {
                  return Center(
                    child: Column(
                      children: [
                        SizedBox(height: mediaQuery.size.height * 0.2),
                        Icon(
                          Icons.health_and_safety,
                          size: 60,
                          color: Colors.grey,
                        ),
                        SizedBox(height: mediaQuery.size.height * 0.02),
                        Text(
                          'No entries yet.\nStart by adding a new health entry!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),

                        // add line to point to the floating action button
                        SizedBox(height: mediaQuery.size.height * 0.02),
                        Icon(
                          Icons.arrow_downward,
                          size: 30,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  );
                }

                return Expanded(
                  child: ListView.separated(
                    itemCount: state.entries!.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final entry = state.entries![index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.tealAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16.0),

                          border: Border.all(
                            color: Colors.teal.withOpacity(0.9),
                            width: 1,
                          ),
                        ),

                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          leading: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.tealAccent.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Text(
                              notifier.getMoodEmoji(entry.mood),
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          title: Text(
                            'Mood: ${entry.mood}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            [
                              if (entry.note != null &&
                                  entry.note!.trim().isNotEmpty)
                                entry.note,
                              '${entry.date.toLocal()}'.split(' ')[0],
                            ].whereType<String>().join('\n'),
                          ),

                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outlined),
                            color: Colors.redAccent,
                            onPressed: () {
                              notifier.deleteEntry(context, entry);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
