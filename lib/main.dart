import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_tracker/services/hive_service.dart';
import 'package:health_tracker/services/superbase_service.dart';
import 'package:health_tracker/util/theme.dart';
import 'package:health_tracker/views/add/add_view.dart';
import 'package:health_tracker/views/dashboard/dashboard_view.dart';
import 'package:health_tracker/views/summary/summary_view.dart';
import 'package:health_tracker/views/welcome/welcome_view.dart';

Future<void> main() async {
  //
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.instance.init();
  await HiveService.instance.init();
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Tracker',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: WelcomeView(),
      routes: {
        '/dashboard': (_) => const Dashboard(),
        '/welcome': (_) => const WelcomeView(),
        '/add': (_) => const AddView(),
        '/summary': (_) => const SummaryView(),
      },
    );
  }
}
