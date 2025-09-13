import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_tracker/models/user_model.dart';
import 'package:health_tracker/services/device_id_service.dart';
import 'package:health_tracker/services/hive_service.dart';
import 'package:health_tracker/services/superbase_service.dart';
import 'package:uuid/uuid.dart';

class WelcomeViewModel extends Notifier<bool> {
  late final TextEditingController nameController;

  @override
  bool build() {
    nameController = TextEditingController();
    ref.onDispose(nameController.dispose);
    return false;
  }

  void init(BuildContext context) {
    final user = HiveService.instance.getUser();
    if (user != null && context.mounted) {
      Navigator.of(context).pushReplacementNamed('/dashboard');
    }
  }

  Future<void> saveUser(BuildContext context) async {
    final name = nameController.text.trim();

    if (name.isEmpty && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter your name"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    state = true;
    try {
      final deviceId = await DeviceHelper.getDeviceId();

      final existingUser = await SupabaseService.instance.getUserByDeviceId(
        deviceId,
      );
      if (existingUser != null) {
        await HiveService.instance.saveUser(existingUser);
        if (context.mounted) {
          Navigator.of(context).pushReplacementNamed('/dashboard');
        }
        return;
      }

      final user = UserModel(
        deviceId: deviceId,
        name: name,
        id: const Uuid().v4(),
      );
      final response = await SupabaseService.instance.createUser(user);

      if (response != null) {
        await HiveService.instance.saveUser(user);
      }

      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed('/dashboard');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error saving user: $e"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      state = false;
    }
  }
}

final welcomeViewModelProvider = NotifierProvider<WelcomeViewModel, bool>(
  WelcomeViewModel.new,
);
