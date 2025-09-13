import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_tracker/services/connectivity_service.dart';

class ConnectivityBanner extends ConsumerWidget {
  const ConnectivityBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connection = ref.watch(connectivityProvider);

    return connection.when(
      data: (isOnline) {
        if (isOnline) {
          return Container(
            width: double.infinity,
            color: Colors.green.withOpacity(0.8),
            padding: const EdgeInsets.all(8),
            child: const Text(
              "Online",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          );
        } else {
          return Container(
            width: double.infinity,
            color: Colors.red.withOpacity(0.8),
            padding: const EdgeInsets.all(8),
            child: const Text(
              "Offline",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          );
        }
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
