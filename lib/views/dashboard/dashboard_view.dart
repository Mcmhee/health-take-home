import 'package:flutter/material.dart';
import 'package:health_tracker/services/hive_service.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Health Tracker',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart, size: 30),
            onPressed: () {},
          ),
        ],
      ),

      //
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          HiveService.instance.clearAll();
        },
        label: const Text('Add Entry'),
        icon: const Icon(Icons.add),
        elevation: 0.5,
      ),

      body: Column(
        children: [const Center(child: Text('Welcome to the Dashboard!'))],
      ),
    );
  }
}
