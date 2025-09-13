// welcome_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_tracker/views/welcome/welcome_view_model.dart';

class WelcomeView extends ConsumerStatefulWidget {
  const WelcomeView({super.key});

  @override
  ConsumerState<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends ConsumerState<WelcomeView> {
  late final WelcomeViewModel _vmNotifier;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _vmNotifier = ref.read(welcomeViewModelProvider.notifier);
      _vmNotifier.init(context);
      _vmNotifier.nameController.addListener(_onNameChanged);
    });
  }

  @override
  void dispose() {
    _vmNotifier.nameController.removeListener(_onNameChanged);
    super.dispose();
  }

  void _onNameChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(welcomeViewModelProvider);
    final vm = ref.read(welcomeViewModelProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Icon(Icons.favorite, size: 80, color: Colors.redAccent),
              const SizedBox(height: 24),
              Text(
                "Welcome ${vm.nameController.text.isEmpty ? 'Guest' : vm.nameController.text}, to Health Tracker Made Easy",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),

              TextField(
                controller: vm.nameController,
                decoration: InputDecoration(
                  labelText: "Your name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: isLoading ? null : () => vm.saveUser(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Continue"),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
